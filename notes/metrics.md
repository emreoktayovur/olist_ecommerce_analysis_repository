# Metrics (Definitions)

## Order filter
- Most analyses use `order_status = 'delivered'` to focus on completed orders.

## Revenue
- **Product revenue (proxy):** `SUM(price)` from `olist_order_items`
- **Gross value (optional):** `SUM(price + freight_value)` from `olist_order_items`

## Top customers
- Ranked by total spend (revenue) per `customer_unique_id` on delivered orders.

## Repeat purchase
- **orders_cnt (per customer):** `COUNT(DISTINCT order_id)` on delivered orders
- **repeat_customers:** number of customers with `orders_cnt >= 2`
- **repeat_rate:** `repeat_customers / total_customers` (reported as %)

## Revenue trend (monthly)
- Revenue aggregated by month using `DATE_TRUNC(DATE(order_purchase_timestamp), MONTH)`.

## Category contribution
- Revenue grouped by product category (`olist_products.product_category_name`)
- Category translation uses `product_category_translation` when available.

## Operations (delivery)
- **Delivery time (days):** `DATE_DIFF(delivered_date, purchase_date, DAY)`
- **Delay (late**
