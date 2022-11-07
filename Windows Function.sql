-- Active: 1659213076581@@localhost@5432@postgres@public

SELECT emp_id,emp_name,dept_name,salary FROM employee;

-- Windows Function in SQL (Analystical functions)
-- row_number, rank, dense_rank, lead, lag

-- 1. Row_Number ()
SELECT e.*,
ROW_NUMBER() over() as rn
FROM employee e;

SELECT e.*,
ROW_NUMBER() over(partition by dept_name) as rn
FROM employee e;


/* Q1 - The first 2 employee from each department to join the company 
(joing is as per emp_id) */
SELECT * FROM(
    SELECT e.*,
    ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn
    FROM employee e) x
WHERE x.rn<3;

-- 2. RANK()

/* Q.2 - Top 3 employees with max salary from each department */
 SELECT * FROM (
    SELECT e.*,
    RANK() OVER (PARTITION BY dept_name ORDER BY salary DESC) AS rnk
    FROM employee e)x
    WHERE x.rnk<4;

-- Comparision between RANK, DENSE RANK & ROW NUMBER.
SELECT e.*,
RANK() OVER (PARTITION BY dept_name ORDER BY salary DESC) AS rnk,
DENSE_RANK() OVER (PARTITION BY dept_name ORDER BY salary DESC) dns_rnk,
ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY salary DESC) row_num
FROM employee e;
 

-- LEAD & LAG
/* Q.1 - Check if the salary of the employee is higher or lower than the previous employee */

SELECT e.*,
LAG(salary,1,0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_emp_salary,
LEAD(salary,1,0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS nxt_emp_salary
FROM employee e;

/* Q.2 - Check if the salary of the employee is higher or lower than the previous employee 
and display 'Higher' for higher and 'lower' for lower salary*/

SELECT e.*,
LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_emp_salary,
CASE    WHEN e.salary > LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) 
            THEN 'Higher than previous employee'
        WHEN e.salary < LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) 
            THEN 'Lower than previous employee'
        WHEN e.salary = LAG(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) 
            THEN 'Equal to previous employee'
        END sal_range
FROM employee e;