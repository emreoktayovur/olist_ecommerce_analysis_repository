--Purpose: average delivery delay
--Inputs: olist_orders_data
--Grain: single row (overall metric)
--Notes: delivered only, uses estimated vs delivered

SELECT
  ROUND(AVG(DATE_DIFF(
    DATE(order_delivered_customer_date),
    DATE(order_purchase_timestamp),
    DAY
  )), 2) AS avg_delivery_days
FROM `dbt-projem.olist_raw_data.olist_orders_data`
WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;