-- ================================================
-- Basic SQL Queries for Practice (ORDER BY, LIMIT, INSERT, UPDATE, DELETE)
-- Database: Example dataset (e.g., Northwind)
-- ================================================

-- 1. List products sorted by price in ascending order
SELECT 
    product_name,
    unit_price
FROM products
ORDER BY unit_price ASC;

-- 2. List employees in alphabetical order by last name
SELECT 
    first_name,
    last_name
FROM employees
ORDER BY last_name ASC;

-- LIMIT examples

-- 3. Show the 5 most expensive products
SELECT 
    product_name,
    unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

-- 4. Show the first 3 customers from the list, sorted by company name
SELECT 
    company_name
FROM customers 
ORDER BY company_name
LIMIT 3;

-- INSERT, UPDATE and DELETE examples

-- 5. Add a new category to the 'categories' table
INSERT INTO categories (category_id, category_name, description)
VALUES (9, 'Organic/Healthy', 'Eco-friendly, dietary products');
SELECT * 
FROM categories;

-- 6. Update description for the category with id = 1
UPDATE categories 
SET description = 'Soft drinks and juices'
WHERE category_id = 1;
SELECT * 
FROM categories;

-- 7. Delete categories with id 3 and 4
DELETE FROM categories 
WHERE category_id IN (3,4);
SELECT *
FROM categories;

-- 8. Increase prices by 10% for all products from suppliers with supplier_id 3, 4, 7
UPDATE products
SET unit_price = unit_price * 1.1
WHERE supplier_id IN (3, 4, 7);
SELECT 
    product_name,
    supplier_id,
    ROUND(unit_price, 2) AS unit_price
FROM products
WHERE supplier_id IN (3, 4, 7);

-- 9. Delete all products with units_in_stock = 0 (check before deleting)
SELECT * 
FROM products 
WHERE units_in_stock = 0;

DELETE FROM products 
WHERE units_in_stock = 0;

SELECT * 
FROM products;
