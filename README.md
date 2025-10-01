# E-Commerce Transactions Analysis

This project analyzes **50,000 e-commerce transactions** (8 columns: `transaction_id`, `user_name`, `age`, `country`, `product_category`, `purchase_amount`, `payment_method`, `transaction_date`) to uncover insights into user behavior, sales trends, and payment preferences.  

The analysis demonstrates **SQL querying** for insights and **Power BI** dashboards for visualization.

---

##  Dataset
- **Rows:** 50,000
- **Columns:** 8
- **Key Fields:**
  - `transaction_id` (unique ID)
  - `user_name` (customer identifier)
  - `age` (customer’s age)
  - `country` (customer’s country)
  - `product_category` (type of product purchased)
  - `purchase_amount` (transaction value)
  - `payment_method` (Credit Card, PayPal, etc.)
  - `transaction_date` (date of transaction)

---

##  Objectives
1. Perform SQL-based business analysis:
   - Revenue growth
   - Customer segmentation
   - Category rankings
   - Outlier detection
   - Pareto (80/20) analysis
2. Visualize results in Power BI dashboards.
3. Showcase SQL + BI integration for business insights.

---

##  Technologies Used
- **SQL (MySQL)** → for queries and analysis
- **Power BI** → for dashboards
- **Excel/CSV** → dataset storage

---

##  SQL Queries & Insights
The project includes **10 queries**:
1. Month-over-Month Revenue Growth Rate
2. Country-Specific Top Product Category Ranking
3. Identifying High-Value Outliers
4. Customer Segmentation by Total Spend
5. Pivot Table of Revenue by Country & Payment Method
6. Average Order Value by Age Group & Payment Method
7. Cumulative Market Share (Pareto Analysis)
8. Cumulative Revenue Over Time
9. User’s First vs Last Purchase Gap
10. Top 3 Most Popular Categories by Country

(See `queries.sql` for full code.)

---

##  Power BI Dashboard
The dashboard highlights:
- **Revenue trends over time**
- **Category performance by country**
- **Customer segmentation**
- **Age group + payment method preferences**
- **Pareto (80/20) distribution**

*(Screenshots or `.pbix` file can be included here once ready)*

---

##  How to Run
1. Clone this repository
   ```bash
   git clone https://github.com/khoi-mng/MySQL-Advanced-Sales-Queries.git
