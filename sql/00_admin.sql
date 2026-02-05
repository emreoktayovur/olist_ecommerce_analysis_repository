/* =========================================================
00_admin.sql
Goal:
- List tables in the dataset
- Inspect columns for core tables

========================================================= */

SELECT
  table_name
FROM `dbt-projem.olist_raw_data.INFORMATION_SCHEMA.TABLES`
ORDER BY table_name;


SELECT
  column_name,
  data_type,
  is_nullable
FROM `dbt-projem.olist_raw_data.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN (
  'olist_orders_data',
  'olist_order_items',
  'olist_customers',
  'olist_products',
  'olist_sellers',
  'olist_order_reviews',
  'olist_order_payment',
  'olist_geolocation',
  'product_category_tr'
)
ORDER BY table_name, ordinal_position;


