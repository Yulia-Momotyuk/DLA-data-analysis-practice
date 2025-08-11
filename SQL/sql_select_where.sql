-- ================================================
-- Basic SQL Queries for Practice (SELECT, WHERE)
-- Database: Example dataset (e.g., Northwind)
-- ================================================

-- 1. Retrieve all category names from the categories table
SELECT category_name
FROM categories;

-- 2. Get first and last names of all employees
SELECT 
    first_name, 
    last_name
FROM employees;

-- 3. Display all fields for all products
SELECT *
FROM products;

-- 4. Retrieve company name and city for all customers
SELECT 
    company_name, 
    city
FROM customers;


-- ================================================
-- Filtering Results (WHERE)
-- ================================================

-- 5. Get all products with a unit price greater than 33
SELECT 
    product_name, 
    unit_price
FROM products
WHERE unit_price > 33;

-- 6. Find all customers from Germany and Spain
SELECT 
    company_name, 
    country
FROM customers
WHERE country IN ('Germany', 'Spain');

-- 7. Show products that are not discontinued and have more than 10 units in stock
SELECT 
    product_name, 
    units_in_stock
FROM products
WHERE discontinued = 0
  AND units_in_stock > 10;

-- 8. Retrieve employees not from the USA
SELECT 
    first_name, 
    last_name, 
    country
FROM employees
WHERE country != 'USA';

-- 9. Display all customers where the region field is NULL
SELECT *
FROM customers
WHERE region IS NULL;

-- 10. Find products with a price between 20 and 50 (inclusive)
SELECT 
    product_name, 
    unit_price
FROM products
WHERE unit_price BETWEEN 20 AND 50;

-- 11. Get all customers whose contact names start with "C"
SELECT 
    contact_name
FROM customers
WHERE contact_name LIKE 'C%';

