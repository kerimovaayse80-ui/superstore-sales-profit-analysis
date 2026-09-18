-- Q1: Profile the orders table
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT product_id) AS distinct_products,
    MIN(order_date) AS min_order_date,
    MAX(order_date) AS max_order_date
FROM orders;


-- Q2: NULL Count for Every Column
SELECT
    SUM(CASE WHEN row_id IS NULL THEN 1 ELSE 0 END) AS row_id_nulls,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
    SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS ship_date_nulls,
    SUM(CASE WHEN ship_mode IS NULL THEN 1 ELSE 0 END) AS ship_mode_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS customer_name_nulls,
    SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS segment_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS state_nulls,
    SUM(CASE WHEN postal_code IS NULL THEN 1 ELSE 0 END) AS postal_code_nulls,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) AS sub_category_nulls,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS product_name_nulls,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS sales_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS discount_nulls,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS profit_nulls
FROM orders;


-- Q3: Detect Duplicate Order Lines
SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Q4: Average Days to Ship by Ship Mode
SELECT
    ship_mode,
    AVG(julianday(ship_date) - julianday(order_date)) AS avg_days_to_ship
FROM orders
GROUP BY ship_mode
ORDER BY avg_days_to_ship;


-- Q5: Sales, Profit and Profit Margin by Region, Category and Sub-Category
SELECT
    region,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    1.0 * SUM(profit) / NULLIF(SUM(sales), 0) AS profit_margin
FROM orders
GROUP BY region, category, sub_category
ORDER BY total_profit ASC;


-- Q6: Top 5 and Bottom 5 Sub-Categories by Total Profit
SELECT * FROM (
    SELECT sub_category, SUM(profit) AS total_profit, 'Top 5' AS ranking_group
    FROM orders
    GROUP BY sub_category
    ORDER BY total_profit DESC
    LIMIT 5
)

UNION ALL

SELECT * FROM (
    SELECT sub_category, SUM(profit) AS total_profit, 'Bottom 5' AS ranking_group
    FROM orders
    GROUP BY sub_category
    ORDER BY total_profit ASC
    LIMIT 5
);


-- Q7: Discount Band Analysis
SELECT
    CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.40 THEN '21-40%'
        ELSE '41%+'
    END AS discount_band,
    COUNT(DISTINCT order_id) AS order_count,
    AVG(profit) AS avg_profit,
    SUM(profit) AS total_profit
FROM orders
GROUP BY CASE
        WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.20 THEN '1-20%'
        WHEN discount <= 0.40 THEN '21-40%'
        ELSE '41%+'
    END;


-- Q8: Year-over-Year Sales Trend
SELECT
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) AS previous_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY year) AS yoy_change,
    100.0 * (total_sales - LAG(total_sales) OVER (ORDER BY year)) / LAG(total_sales) OVER (ORDER BY year) AS yoy_percent
FROM (
    SELECT strftime('%Y', order_date) AS year, SUM(sales) AS total_sales
    FROM orders
    GROUP BY strftime('%Y', order_date)
)
ORDER BY year;


-- Q9: Negative Profit Sub-Categories and Revenue Share
SELECT
    sub_category,
    SUM(profit) AS total_profit,
    SUM(sales) AS total_sales,
    100.0 * SUM(sales) / (SELECT SUM(sales) FROM orders) AS revenue_share_percent
FROM orders
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- Q10: Top 10 Customers by Lifetime Profit
SELECT
    customer_id,
    customer_name,
    SUM(profit) AS lifetime_profit,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(sales) / COUNT(DISTINCT order_id) AS average_order_value
FROM orders
GROUP BY customer_id, customer_name
ORDER BY lifetime_profit DESC
LIMIT 10;
