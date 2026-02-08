/* =========================================================
02_customers.sql

-- Purpose: Customer insights (top spenders + repeat purchase rate)
-- Inputs: olist_orders_data, olist_order_items, olist_customers
-- Output grain:
--   - Top spenders: 1 row per customer_unique_id
--   - Repeat rate: 1 summary row
-- Notes: Delivered orders only; customer_unique_id used as "real customer"

========================================================= */

-- Who are the most valuable customers?

SELECT 
  cust.customer_unique_id,
  SUM(orditems.price) AS total_price,
  COUNT(DISTINCT ordata.order_id) AS orders_cnt
FROM `dbt-projem.olist_raw_data.olist_orders_data` AS ordata
JOIN `dbt-projem.olist_raw_data.olist_order_items` AS orditems
ON orditems.order_id = ordata.order_id
JOIN `dbt-projem.olist_raw_data.olist_customers` AS cust
ON ordata.customer_id = cust.customer_id
WHERE ordata.order_status = 'delivered'
GROUP BY cust.customer_unique_id
ORDER BY total_price DESC
LIMIT 10


-- How often do customers repurchase (repeat rate)?

WITH orderCount AS (
  SELECT
    cust.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS orders_cnt
  FROM `dbt-projem.olist_raw_data.olist_orders_data` AS o
  JOIN `dbt-projem.olist_raw_data.olist_customers` AS cust
    ON o.customer_id = cust.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY cust.customer_unique_id
),
repeat_cte AS (
  SELECT COUNT(*) AS repeat_customers
  FROM orderCount
  WHERE orders_cnt >= 2
),
total_cte AS (
  SELECT COUNT(DISTINCT cust.customer_unique_id) AS total_customers
  FROM `dbt-projem.olist_raw_data.olist_orders_data` AS o
  JOIN `dbt-projem.olist_raw_data.olist_customers` AS cust
    ON o.customer_id = cust.customer_id
  WHERE o.order_status = 'delivered'
)
SELECT
  repeat_cte.repeat_customers,
  total_cte.total_customers,
  ROUND(100 * SAFE_DIVIDE(repeat_cte.repeat_customers, total_cte.total_customers), 2) AS repeat_rate_pct
FROM repeat_cte
CROSS JOIN total_cte;
