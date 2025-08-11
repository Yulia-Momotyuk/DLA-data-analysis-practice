-- ================================================
-- SQL Queries for Practice (JOINs)
-- Database: Example dataset (e.g., Northwind)
-- ================================================

-- 1. List all orders with order ID, and the first and last name of the employee who processed it
SELECT 
    order_id,
    last_name,
    first_name
FROM orders o 
LEFT JOIN employees e 
    ON o.employee_id = e.employee_id;

-- 2. Show orders with date, order ID, and customer company name
-- Filter only orders made in October, sorted by date ascending
SELECT 
    order_id,
    order_date,
    company_name
FROM orders o 
LEFT JOIN customers c 
    ON o.customer_id = c.customer_id
WHERE MONTH(order_date) = 10
ORDER BY order_date ASC;

-- 3. List product names along with supplier name and region
-- Only for suppliers in "North America" or "Western Europe"
-- Sort by supplier name ascending
SELECT 
    product_name,
    company_name AS supplier,
    region
FROM suppliers s 
LEFT JOIN products p 
    ON s.supplier_id = p.supplier_id
WHERE region IN ('North America', 'Western Europe')
ORDER BY supplier ASC;

-- 4. List products that have been ordered
-- For each product: number of orders containing it (n_orders)
-- and total quantity across all orders (sum_quantity)
-- Sort by n_orders ascending
SELECT 
    product_name,
    COUNT(*) AS n_orders,
    SUM(quantity) AS sum_quantity
FROM products p
LEFT JOIN order_details od  
    ON p.product_id = od.product_id
GROUP BY product_name
ORDER BY n_orders ASC;

-- 5. Count orders for each customer
-- Show only customers with more than 7 orders
SELECT 
    company_name,
    COUNT(*) AS total_orders 
FROM customers c
LEFT JOIN orders o  
    ON c.customer_id = o.customer_id
GROUP BY company_name
HAVING COUNT(*) > 7
ORDER BY total_orders ASC;

-- 6. Show employees working in territories starting with "Santa"
-- Using employees, employee_territories, and territories tables
SELECT 
    first_name,
    last_name,
    territory_description
FROM employees e
LEFT JOIN employee_territories et 
    ON e.employee_id = et.employee_id
LEFT JOIN territories t 
    ON et.territory_id = t.territory_id
WHERE territory_description LIKE 'Santa%';

-- 7. Show products priced over 20 per unit with their price and supplier name
SELECT
    product_name,
    unit_price,
    company_name
FROM products p 
LEFT JOIN suppliers s 
    ON p.supplier_id = s.supplier_id
WHERE unit_price > 20;

-- 8. Show categories with more than 5 products
-- Include the number of products in each category
SELECT
    category_name,
    COUNT(product_name) AS total_number
FROM categories c 
LEFT JOIN products p 
    ON c.category_id = p.category_id
GROUP BY category_name
HAVING COUNT(product_name) > 5;

-- 9. Show employees hired in 2013 along with their managers
SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    e.hire_date,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m
    ON e.reports_to = m.employee_id
WHERE YEAR(e.hire_date) = 2013;
