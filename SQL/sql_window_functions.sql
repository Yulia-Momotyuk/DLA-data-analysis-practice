-- ================================================
-- SQL Queries for Practice (Window Functions)
-- Database: Example dataset (e.g., Northwind)
-- ================================================

-- 1. Previous order for each customer using LAG
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_id) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_id
FROM orders;

-- 2. First order for each customer using FIRST_VALUE
SELECT
    customer_id,
    order_id,
    order_date,
    FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_order_id
FROM orders;

-- 3. Top 3 most expensive products in each category using RANK
WITH ranked_products AS (
    SELECT
        c.category_id,
        category_name,
        product_id,
        product_name,
        unit_price,
        RANK() OVER (PARTITION BY c.category_id ORDER BY unit_price DESC) AS product_rank
    FROM categories c
    LEFT JOIN products p 
        ON c.category_id = p.category_id
)
SELECT
    category_id,
    category_name,
    product_id,
    product_name,
    unit_price,
    product_rank
FROM ranked_products
WHERE product_rank <= 3;

-- 4. Time difference between consecutive orders for each customer
WITH orders_with_lag AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_id) AS previous_order_date
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    JULIANDAY(order_date) - JULIANDAY(previous_order_date) AS diff_days
FROM orders_with_lag;

-- 5. Average interval in days between customer orders per region
WITH orders_with_lag AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_id) AS previous_order_date
    FROM orders
),
order_diff_days AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        previous_order_date,
        JULIANDAY(order_date) - JULIANDAY(previous_order_date) AS diff_days
    FROM orders_with_lag
)
SELECT
    region,
    ROUND(AVG(diff_days), 2) AS avg_diff_days
FROM order_diff_days odd
JOIN customers c 
    ON odd.customer_id = c.customer_id
GROUP BY region;

-- 6. Top 3 employees by number of processed orders
WITH order_rank AS (
    SELECT 
        e.employee_id,
        first_name,
        last_name,
        COUNT(*) AS order_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS employee_rank
    FROM employees e
    LEFT JOIN orders o 
        ON e.employee_id = o.employee_id
    GROUP BY e.employee_id
)
SELECT
    employee_id,
    first_name,
    last_name,
    order_count,
    employee_rank
FROM order_rank
WHERE employee_rank <= 3;

-- 7. Top 3 employees by number of processed orders in each region
WITH ranked_employees AS (
    SELECT 
        region,
        e.employee_id,
        first_name,
        last_name,
        COUNT(*) AS order_count,
        RANK() OVER (PARTITION BY region ORDER BY COUNT(*) DESC) AS employee_rank
    FROM employees e
    LEFT JOIN orders o 
        ON e.employee_id = o.employee_id
    GROUP BY region, e.employee_id
)
SELECT
    region,
    employee_id,
    first_name,
    last_name,
    order_count,
    employee_rank
FROM ranked_employees
WHERE employee_rank <= 3;
