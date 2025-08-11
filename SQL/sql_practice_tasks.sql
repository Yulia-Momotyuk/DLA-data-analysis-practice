-- ============================================================
-- SQL PRACTICE TASKS
-- Dataset: Employees Sample Database
-- ============================================================

-- ======================
-- SECTION 1 — JOINs and Basic Queries
-- ======================

-- 1. Join employees and salaries
SELECT 	
    e.emp_no, 
    e.first_name, 
    e.last_name, 
    s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
LIMIT 10;

-- 2. Join employees and titles
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    t.title
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.to_date = '9999-01-01'
LIMIT 10;

-- 3. Join employees, dept_emp, and departments
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
LIMIT 10;

-- 4. Count employees per department
SELECT 
    d.dept_name,
    COUNT(DISTINCT de.emp_no) AS count_employees
FROM dept_emp de 
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY count_employees DESC;

-- 5. Highest-paid employee in “Development”
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Development'
  AND s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 1;

-- 6. Department of the highest-paid employee in the company
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary,
    d.dept_name
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 1;

-- 7. Third-highest salary
SELECT 	
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 1 OFFSET 2;

-- 8. Employees with multiple job titles
SELECT 	
    e.emp_no,
    e.first_name,
    e.last_name,
    GROUP_CONCAT(DISTINCT t.title SEPARATOR ', ') AS all_titles
FROM titles t 
JOIN employees e ON e.emp_no = t.emp_no
GROUP BY e.emp_no
HAVING COUNT(DISTINCT t.title) > 1
LIMIT 10;

-- 9. Employees who worked in multiple departments
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    GROUP_CONCAT(DISTINCT d.dept_name SEPARATOR ', ') AS all_departments
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY e.emp_no
HAVING COUNT(DISTINCT d.dept_name) > 1
LIMIT 10;

-- 10. Current salary of each department manager
SELECT 	
    d.dept_name,
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON dm.dept_no = d.dept_no
WHERE s.to_date = '9999-01-01'
  AND dm.to_date = '9999-01-01';

-- ======================
-- SECTION 2 — WINDOW FUNCTIONS
-- ======================

-- 1. ROW_NUMBER()
SELECT 	
    emp_no,
    first_name,
    last_name,
    ROW_NUMBER() OVER (ORDER BY emp_no) AS row_num
FROM employees
LIMIT 10;

-- 2. LAG() — Salary history for employee 10001
SELECT 	
    emp_no,
    from_date,
    salary,
    LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS previous_salary
FROM salaries
WHERE emp_no = 10001;

-- 3. RANK() — Salary rank within department
SELECT 
    e.emp_no,
    d.dept_name,
    s.salary,
    RANK() OVER (PARTITION BY d.dept_name ORDER BY s.salary DESC) AS salary_rank
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
  AND de.to_date = '9999-01-01';

-- 4. Salary change in the last 2 years for employee 10001
SELECT 
    s.emp_no,
    LAG(salary, 2) OVER (ORDER BY from_date) AS salary_2_years_ago,
    salary,
    salary - LAG(salary, 2) OVER (ORDER BY from_date) AS salary_difference
FROM salaries s
WHERE s.emp_no = 10001
ORDER BY from_date DESC
LIMIT 1;

-- 5. Largest annual salary increase
WITH salary_max AS (
    SELECT MAX(from_date) AS latest_date FROM salaries
),
salary_diff AS (
    SELECT 
        s.emp_no,
        LAG(salary) OVER (PARTITION BY s.emp_no ORDER BY from_date) AS prev_salary,
        salary,
        salary - LAG(salary) OVER (PARTITION BY s.emp_no ORDER BY from_date) AS diff
    FROM salaries s
    JOIN salary_max
      ON s.from_date BETWEEN DATE_SUB(latest_date, INTERVAL 2 YEAR) 
                         AND DATE_SUB(latest_date, INTERVAL 1 YEAR)
)
SELECT 
    emp_no,
    prev_salary,
    salary,
    MAX(diff) AS max_diff
FROM salary_diff
GROUP BY emp_no, prev_salary, salary
ORDER BY max_diff DESC
LIMIT 1;

-- 6. Average salary and first hire per title
WITH job_stats AS (
    SELECT 
        t.title,
        AVG(s.salary) AS avg_salary
    FROM titles t
    JOIN salaries s ON t.emp_no = s.emp_no
    WHERE s.to_date = '9999-01-01' 
      AND t.to_date = '9999-01-01'
    GROUP BY t.title
),
first_hired AS (
    SELECT 
        t.title,
        e.first_name,
        e.hire_date,
        DENSE_RANK() OVER (PARTITION BY t.title ORDER BY e.hire_date) AS hire_rank
    FROM titles t
    JOIN employees e ON t.emp_no = e.emp_no
    WHERE t.to_date = '9999-01-01'
)
SELECT 
    js.title,
    js.avg_salary,
    fh.first_name,
    fh.hire_date
FROM job_stats js
JOIN first_hired fh ON js.title = fh.title AND fh.hire_rank = 1
ORDER BY js.title, fh.first_name;

-- 7. NTILE() — Divide employees into 3 salary groups
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary,
    NTILE(3) OVER (ORDER BY s.salary DESC) AS salary_group
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no IN (
    419748, 496734, 264134, 209076, 86631, 456171, 16887, 230255, 
    246465, 420097, 44362, 280370, 479975, 433320, 473949
)
  AND s.to_date = '9999-01-01';

-- ======================
-- SECTION 3 — EXTRA TASKS
-- ======================

-- 1. Department ranking by average salary
WITH current_salaries AS (
    SELECT emp_no, salary
    FROM salaries
    WHERE to_date = '9999-01-01'
),
current_dept_emp AS (
    SELECT emp_no, dept_no
    FROM dept_emp
    WHERE to_date = '9999-01-01'
),
dept_avg_salary AS (
    SELECT 
        d.dept_no,
        AVG(s.salary) AS avg_salary
    FROM current_salaries s
    JOIN current_dept_emp d USING (emp_no)
    GROUP BY d.dept_no
)
SELECT
    d.dept_name,
    das.avg_salary,
    RANK() OVER (ORDER BY das.avg_salary DESC) AS salary_rank
FROM dept_avg_salary das
JOIN departments d ON das.dept_no = d.dept_no;

-- 2. Average salary by gender in each department
WITH current_salaries AS (
    SELECT s.emp_no, s.salary
    FROM salaries s
    WHERE s.to_date = '9999-01-01'
),
current_dept_emp AS (
    SELECT emp_no, dept_no
    FROM dept_emp
    WHERE to_date = '9999-01-01'
),
base AS (
    SELECT 
        e.emp_no,
        d.dept_no,
        s.salary,
        AVG(s.salary) OVER (PARTITION BY d.dept_no, e.gender) AS avg_gender_dept_salary
    FROM employees e
    JOIN current_salaries s USING (emp_no)
    JOIN current_dept_emp d USING (emp_no)
)
SELECT *,
       salary - avg_gender_dept_salary AS diff
FROM base;

