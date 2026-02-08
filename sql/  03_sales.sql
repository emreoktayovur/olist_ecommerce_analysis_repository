/* =========================================================
03_sales.sql

-- Purpose: Sales insights (top products, revenue trend, category contribution)
-- Inputs: olist_orders_data, olist_order_items, olist_products, product_category_translation
-- Output grain:
--   - Top products: 1 row per product_id
--   - Revenue trend: 1 row per time period (e.g., month)
--   - Category revenue: 1 row per category
-- Notes: Delivered orders only; revenue proxy uses SUM(price) (optionally + freight_value)


========================================================= */

-- Top 15 Products by revenue

SELECT 
  ordit.product_id,
  SUM(ordit.price) AS revenue
FROM `dbt-projem.olist_raw_data.olist_orders_data` AS ordata
JOIN `dbt-projem.olist_raw_data.olist_order_items` AS ordit
ON ordata.order_id = ordit.order_id
WHERE ordata.order_status = 'delivered'
GROUP BY ordit.product_id
ORDER BY revenue DESC
LIMIT 15

-- Revenue trends over time

SELECT 
  DATE_TRUNC(DATE(order_purchase_timestamp),MONTH) AS monthly_trend,
  ROUND(SUM(ordit.price), 2) AS revenue
FROM `dbt-projem.olist_raw_data.olist_orders_data` AS ordata
JOIN `dbt-projem.olist_raw_data.olist_order_items` AS ordit
ON ordata.order_id = ordit.order_id
WHERE ordata.order_status = 'delivered'
GROUP BY monthly_trend
ORDER BY monthly_trend;


-- Category contribution to revenue (delivered orders only)
-- Category revenue + share (%)

WITH category_rev AS (
  SELECT
    COALESCE(tr.string_field_1, prd.product_category_name) AS category_en,
    SUM(oit.price) AS revenue
  FROM `dbt-projem.olist_raw_data.olist_orders_data` AS ord
  JOIN `dbt-projem.olist_raw_data.olist_order_items` AS oit
    ON ord.order_id = oit.order_id
  JOIN `dbt-projem.olist_raw_data.olist_products` AS prd
    ON prd.product_id = oit.product_id
  LEFT JOIN `dbt-projem.olist_raw_data.product_category_translation` AS tr
    ON TRIM(LOWER(tr.string_field_0)) = TRIM(LOWER(prd.product_category_name))
  WHERE ord.order_status = 'delivered'
  GROUP BY category_en
)
SELECT
  category_en,
  ROUND(revenue, 2) AS revenue,
  ROUND(100 * SAFE_DIVIDE(revenue, SUM(revenue) OVER()), 2) AS revenue_share_pct
FROM category_rev
ORDER BY revenue DESC;





