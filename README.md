# Sales Data Analysis: Advanced MySQL Queries on 50k Transactions
## Executive Summary & Key Findings
This project provides a comprehensive analysis of a 50,000-row transactional dataset, demonstrating proficiency in advanced SQL for deriving essential business metrics.

### Key Data Insights:

Time-Series Performance (Query 1): The maximum Month-over-Month (MoM) revenue growth was 30.48% achieved in April, 2023. The maximum decline was -71.57% in March, 2025.

Product Contribution (Query 7): The top-performing product category, Sports, drives 12.70% of the total company revenue.

Average Order Value (Query 6): The global Average Purchase Amount (APA) is $503. The highest APA belongs to the Cash on Delivery payment method at $521.

## Project Structure & Deliverables
Directory/File

Description

Status

README.md

Documentation: Overview, Findings, and Methodology. (This file)

Complete

sales_data.csv

Source Data: The raw 50,000-row transaction dataset.

Complete

sql/queries.sql

Core Artifact: All 10 advanced MySQL analytical queries.

Complete

analysis/

Results: Contains summary output files and visualizations.

[Need to Upload]

analysis/data_dictionary.md

Reference: Defines all columns and data types in the source file.

[Need to Create/Upload]

analysis/Query_X_Results.csv

Verification: CSV output of complex query results (e.g., MoM Growth).

[Need to Upload]

analysis/Visual_1_MoM_Trend.png

Visual: Line chart showing time-series revenue trend.

[Need to Upload]

## Methodology: Advanced MySQL Techniques
The analysis focused on demonstrating proficiency with analytical window functions and sophisticated aggregation methods.

Query Focus

MySQL Technique Demonstrated

Analytical Goal

MoM Growth Rate (Q1)

LAG() Window Function, DATE_FORMAT(), NULLIF()

Calculates time-series momentum and percentage change while safely handling division by zero.

Outlier Identification (Q3)

INNER JOIN on Aggregate Subquery

Flags individual transactions that exceed a category's average purchase amount by 2x.

Relative Segmentation (Q4)

NTILE(3) Window Function

Dynamically classifies the entire user base into equally sized High, Medium, and Low Spending tiers.

Payment Method Pivot (Q5)

SUM(CASE WHEN ...) Conditional Aggregation

Creates a pivot table directly in SQL to summarize revenue contributions by country and payment type.

Top N per Group (Q10)

ROW_NUMBER() OVER (PARTITION BY...)

Ranks categories within each country to find the Top [N] most popular items.

Running Total (Q8)

SUM() OVER (ORDER BY ...) Window Function

Calculates the cumulative revenue over the project's entire time period.

📊 Data Visualization & Pivot Summary
1. Visualization Summary
The charts below showcase the most critical findings derived from the queries:

Chart Title

Query Source

Key Insight

MoM Revenue Trend

Query 1

[Insert one sentence summary of the time trend observed.]

Category Market Share

Query 7

[Insert one sentence summary about product concentration.]

Reference the charts in the analysis/ folder for visual proof:
[Insert Link or Image Tag for MoM Trend Chart]
[Insert Link or Image Tag for Category Share Chart]

2. Pivot Table Summary
The Pivot Table focused on [Pivot Table Focus, e.g., Total Revenue by Country and Payment Method].

Primary Takeaway: [One sentence finding based on the pivot, e.g., "The US market relies on Credit Card payments for 90% of revenue, whereas the German market is split between PayPal and Bank Transfer."]

▶️ Setup and Reproducibility
To replicate this analysis, follow these steps:

Clone the Repository: git clone [Your Repo URL]

Database Setup (MySQL 8.0+): Create a new schema (e.g., CREATE DATABASE sales_db;).

Data Import: Import sales_data.csv into a table named Transactions.

Execute Queries: Run the entire script: SOURCE sql/queries.sql;
