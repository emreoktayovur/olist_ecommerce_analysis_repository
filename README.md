# Olist SQL Analysis (BigQuery)

This repository contains a simple SQL-based analysis project using the Olist dataset in BigQuery.

## Dataset
BigQuery dataset:
- `dbt-projem.olist_raw_data`

Main tables used:
- `olist_orders_data`
- `olist_order_items`
- `olist_customers`
- `olist_products`
- `product_category_translation` (category name translation)

## What I analyze
I answer a few core business questions with SQL:
- Top customers by total spend (delivered orders)
- Repeat purchase rate (customers with 2+ delivered orders)
- Top products by revenue
- Revenue trends over time (monthly)
- Category contribution to revenue (+ share %)
- Operations: average delivery delay/time

## How to run
Run the SQL files in order:

1. `00_admin.sql`  
   Checks table and column names.

2. `01_data_quality.sql`  
   Basic data quality checks (counts, duplicates, join coverage).

3. `02_customers.sql`  
   Customer analysis (top spenders + repeat rate).

4. `03_sales.sql`  
   Sales analysis (top products, revenue trend, category contribution).

5. `04_operations.sql`  
   Operations metric(s) (delivery delay
