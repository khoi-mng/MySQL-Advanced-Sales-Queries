-- Query 1 : Month-Over-Month (MoM) Revenue Grouth Rate
-- Goal : Calculate the percentage change in total revenue compared to the previous month

WITH MonthlyRevenue AS (
    -- Aggregate total revenue for each month
    SELECT
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS SaleMonth,
        SUM(Purchase_Amount) AS CurrentMonthRevenue
    FROM ecommerce_transactions
    GROUP BY SaleMonth
)
SELECT
    SaleMonth,
    CONCAT('$', FORMAT(CurrentMonthRevenue, 2)) AS CurrentMonthRevenue,
    CONCAT('$', FORMAT(LAG(CurrentMonthRevenue, 1, 0) OVER (ORDER BY SaleMonth), 2)) AS PreviousMonthRevenue,
    -- Calculate growth rate
    CONCAT(FORMAT((CurrentMonthRevenue - LAG(CurrentMonthRevenue, 1, 0) OVER (ORDER BY SaleMonth)) * 100.0 
    / NULLIF(LAG(CurrentMonthRevenue, 1, 0) OVER (ORDER BY SaleMonth), 0), 2), '%') AS MoMGrowthRate
FROM MonthlyRevenue
ORDER BY SaleMonth;





-- Query 2: Country-Specific Top Product Category Ranking 
-- Goal: Rank the product categories based on total revenue within each country.

SELECT
    Country,
    Product_Category,
    CONCAT('$', FORMAT(TotalCategoryRevenue, 2)) AS TotalCategoryRevenue,
    -- Assign a rank to each category, restarting the rank for every new country
    RANK() OVER (PARTITION BY Country ORDER BY TotalCategoryRevenue DESC) AS CategoryRank
FROM (
    SELECT
        Country,
        Product_Category,
        SUM(Purchase_Amount) AS TotalCategoryRevenue
    FROM ecommerce_transactions
    GROUP BY Country, Product_Category
) AS SubqueryCategoryRevenue
ORDER BY Country, CategoryRank;





-- Query 3: Identifying High-Value Outliers
-- Goal: Find transactions where the purchase amount is more than twice the average purchase amount for that product's category.

SELECT
    t1.transaction_id,
    t1.product_category,
    CONCAT('$', FORMAT(t1.purchase_amount, 2)) AS purchase_amount,
    CONCAT('$', FORMAT(t2.AvgCategoryPurchase, 2)) AS AvgCategoryPurchase
FROM ecommerce_transactions t1
INNER JOIN (
    -- Subquery: Calculate the average purchase amount per category
    SELECT
        product_category,
        AVG(purchase_amount) AS AvgCategoryPurchase
    FROM ecommerce_transactions
    GROUP BY product_category
) t2 ON t1.product_category = t2.product_category
WHERE t1.purchase_amount > (t2.AvgCategoryPurchase * 2.0);





-- Query 4: Customer Segmentation by Total Spend
-- Goal: Classify each unique user into High, Medium, or Low Spenders based on their total lifetime purchases.

WITH UserTotalSpend AS (
    -- CTE 1: Calculate total spending for each unique user
    SELECT
        user_name,
        SUM(purchase_amount) AS LifetimeSpend
    FROM ecommerce_transactions
    GROUP BY user_name
),
SegmentedSpend AS (
    -- CTE 2: Apply the NTILE function to determine the spending tier
    SELECT
        user_name,
        LifetimeSpend,
        -- NTILE(3) divides all users into 3 groups (1=Lowest, 3=Highest)
        NTILE(3) OVER (ORDER BY LifetimeSpend ASC) AS SpendingTier
    FROM UserTotalSpend
)
SELECT
    user_name,
    CONCAT('$', FORMAT(LifetimeSpend, 2)) AS LifetimeSpend,
    CASE
        WHEN SpendingTier = 3 THEN 'Top Spender (Top 33%)'
        WHEN SpendingTier = 2 THEN 'Middle Spender (Middle 33%)'
        ELSE 'Bottom Spender (Bottom 33%)'
    END AS SpendingSegment
FROM SegmentedSpend
ORDER BY LifetimeSpend DESC;





-- Query 5: Pivot Table using Conditional Aggregation
-- Goal: Summarize total revenue and transaction count by country, broken down by payment method (pivoting the payment method field)

SELECT
    country,
    CONCAT('$', FORMAT(SUM(purchase_amount), 2)) AS TotalRevenue,
    -- Pivot 1: Revenue from Credit Card
    CONCAT('$', FORMAT(SUM(CASE WHEN payment_method = 'Credit Card' THEN purchase_amount ELSE 0 END), 2)) AS Revenue_CreditCard,
    -- Pivot 2: Revenue from PayPal
    CONCAT('$', FORMAT(SUM(CASE WHEN payment_method = 'PayPal' THEN purchase_amount ELSE 0 END), 2)) AS Revenue_PayPal,
	COUNT(transaction_id) AS TotalTransactions
FROM ecommerce_transactions
GROUP BY country
ORDER BY CAST(SUM(purchase_amount) AS DECIMAL(10,2)) DESC;





-- Query 6: Average Order Value by Age Group and Payment Method
-- Goal: Find the Average Purchase Amount for transactions, grouped into custom 10-year age bins.

SELECT
    CASE
        WHEN age BETWEEN 18 AND 29 THEN '18-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS AgeGroup,
    payment_method,
    COUNT(transaction_id) AS TransactionCount,
    CONCAT('$', FORMAT(AVG(purchase_amount), 2)) AS AvgPurchaseAmount
FROM ecommerce_transactions
GROUP BY AgeGroup, payment_method
-- Order by the underlying numeric value
ORDER BY AgeGroup, CAST(AVG(purchase_amount) AS DECIMAL(10,2)) DESC;





-- Query 7: Product Category Market Share Percentage (Uses CTE for total)
-- Goal: Calculate the percentage of total company revenue contributed by each product category.

WITH TotalRevenueCTE AS (
    SELECT SUM(purchase_amount) AS TotalCompanyRevenue FROM ecommerce_transactions
)
SELECT
    t.product_category,
    CONCAT('$', FORMAT(SUM(t.purchase_amount), 2)) AS CategoryRevenue,
    -- Calculate percentage
    CONCAT(FORMAT((SUM(t.purchase_amount) * 100.0 / (SELECT TotalCompanyRevenue FROM TotalRevenueCTE)), 2), '%') AS RevenueSharePercentage
FROM ecommerce_transactions t
GROUP BY t.product_category
ORDER BY CAST(SUM(t.purchase_amount) AS DECIMAL(10,2)) DESC;





-- Query 8: Time-based Cumulative Running Total (Uses a Window Function - SUM OVER)
-- Goal: Calculate the cumulative sum of revenue over time, providing a running total.

SELECT
    transaction_date,
    CONCAT('$', FORMAT(purchase_amount, 2)) AS purchase_amount,
    -- Calculate the running sum of all purchase amounts up to the current row
    CONCAT('$', FORMAT(SUM(purchase_amount) OVER (ORDER BY transaction_date ASC), 2)) AS RunningTotalRevenue
FROM ecommerce_transactions
ORDER BY transaction_date ASC;





-- Query 9: User's First and Last Purchase Gap (Uses MySQL DATEDIFF)
-- Goal: Calculate the number of days between a user's first and most recent purchase.

SELECT
    user_name,
    MIN(transaction_date) AS FirstPurchase,
    MAX(transaction_date) AS LastPurchase,
    -- Calculate difference in days using DATEDIFF(latest, earliest)
    DATEDIFF(MAX(transaction_date), MIN(transaction_date)) AS DaysBetweenPurchases
FROM ecommerce_transactions
GROUP BY user_name
-- Filter: Only users with more than one transaction
HAVING COUNT(transaction_id) > 1
ORDER BY DaysBetweenPurchases DESC;





-- Query 10: Top 3 Most Popular Categories by Country (Advanced Filtering with Subquery)
-- Goal: Retrieve only the top 3 most popular categories (by transaction count) for each country.

WITH CategoryRanks AS (
    -- 1. Count transactions per category per country
    SELECT
        country,
        product_category,
        COUNT(transaction_id) AS TransactionsCount,
        -- 2. Assign a sequential rank that resets for every new country (PARTITION BY)
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY COUNT(transaction_id) DESC
        ) AS CategoryRank
    FROM ecommerce_transactions
    GROUP BY country, product_category
)
SELECT
    country,
    product_category,
    TransactionsCount
FROM CategoryRanks
-- 3. Filter to keep only the top 3 rows (ranks 1, 2, and 3) within each country
WHERE CategoryRank <= 3
ORDER BY country, TransactionsCount DESC;






