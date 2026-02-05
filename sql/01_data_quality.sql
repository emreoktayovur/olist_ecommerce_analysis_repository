/* =========================================================
01_data_quality.sql
Checks:
1) Row counts
2) Duplicate keys
3) Join coverage
========================================================= */

-- 1) Row counts
SELECT 'olist_orders_data' AS t, COUNT(*) c FROM `dbt-projem.olist_raw_data.olist_orders_data`
UNION ALL SELECT 'olist_order_items', COUNT(*) FROM `dbt-projem.olist_raw_data.olist_order_items`
UNION ALL SELECT 'olist_customers', COUNT(*) FROM `dbt-projem.olist_raw_data.olist_customers`;


-- 2) Duplicate keys
SELECT
  'orders(order_id)' AS check_name,
  COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_rows
FROM `dbt-projem.olist_raw_data.olist_orders_data`
UNION ALL
SELECT
  'order_items(order_id, order_item_id)' AS check_name,
  COUNT(*) - COUNT(DISTINCT CONCAT(order_id,'-',CAST(order_item_id AS STRING))) AS duplicate_rows
FROM `dbt-projem.olist_raw_data.olist_order_items`;


-- 3) Join coverage
SELECT
  'orders -> customers (customer_id)' AS check_name,
  SUM(CASE WHEN c.customer_id IS NULL THEN 1 ELSE 0 END) AS missing_rows
FROM `dbt-projem.olist_raw_data.olist_orders_data` o
LEFT JOIN `dbt-projem.olist_raw_data.olist_customers` c
  ON o.customer_id = c.customer_id
UNION ALL
SELECT
  'order_items -> orders (order_id)' AS check_name,
  SUM(CASE WHEN o.order_id IS NULL THEN 1 ELSE 0 END) AS missing_rows
FROM `dbt-projem.olist_raw_data.olist_order_items` i
LEFT JOIN `dbt-projem.olist_raw_data.olist_orders_data` o
  ON i.order_id = o.order_id;
