-- Active: 1661105228585@@localhost@3306@atif_with

SELECT `emp_ID`,`emp_NAME`,`SALARY` FROM emp;
describe emp;
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(101,'Mohan',40000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(102,'Robin',60000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(103,'Sunny',70000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(102,'Robin',60000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(104,'Alice',50000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(101,'Mohan',40000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(102,'Robin',60000);
INSERT INTO emp (emp_ID,emp_NAME,SALARY) VALUES(105,'Jimmy',90000);

/* How to SELECT UNIQUE records */
SELECT * FROM emp
GROUP BY emp_ID;

/* How to count the total number of records and number of unique record? */
/* Count all records */
SELECT COUNT(*) as row_count FROM emp;
/* Count unique records */
SELECT COUNT (DISTINCT emp_NAME) as unique_rec FROM emp;

/* How to select duplicate records */
SELECT emp_ID,emp_NAME,SALARY, count(emp_ID) as duplicate_count
FROM emp
GROUP BY emp_ID
HAVING duplicate_count > 1;


/* How to delete duplicate records */
/* Method for  MySQL/PostgreSQL*/

/* Sep 1. Create a new table whose structure is the same as the original table: */
CREATE Table copy_table LIKE emp;
SELECT * FROM copy_table;

/* Step 2. Insert distinct rows from the original table to the new table: */
INSERT INTO copy_table
SELECT * FROM emp
GROUP BY emp_ID;

SELECT * from copy_table;

/*Step 3. drop the original table and rename the immediate table to the original one*/
DROP Table emp;
ALTER Table copy_table RENAME TO emp;

SELECT * FROM emp;


-- Case 2 When no unique value column is there
-- Method only for Oracle DB.

SELECT ROWID,
       emp_id,
       emp_name,
       salary,
       ROW_NUMBER() OVER(PARTITION BY emp_id,emp_name,salary ORDER BY emp_id) as row_num
FROM atif_emp;



SELECT ROWID FROM (  SELECT ROWID,
                            emp_id,
                            emp_name,
                            salary,
                            ROW_NUMBER() OVER(PARTITION BY emp_id,emp_name,salary ORDER BY emp_id) as row_num
                     FROM atif_emp
                   )
WHERE row_num > 1;



DELETE FROM atif_emp WHERE ROWID IN (
                                          SELECT ROWID FROM (  SELECT ROWID,
                                                               emp_id,
                                                               emp_name,
                                                               salary,
                                                               ROW_NUMBER() OVER(PARTITION BY emp_id,emp_name,salary ORDER BY emp_id) as row_num
                                                        FROM atif_emp
                                                        )
WHERE row_num > 1);
                                   


SELECT * FROM atif_emp;
----------------------------------------------
-- Case 2 When unique value column exists (contact table)

DROP TABLE IF EXISTS contacts;

CREATE TABLE contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(255) NOT NULL
);

INSERT INTO contacts (first_name,last_name,email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
       ('Jean','King','jean.king@me.com'),
       ('Peter','Ferguson','peter.ferguson@google.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com'),
       ('Julie','Murphy','julie.murphy@yahoo.com'),
       ('Kwai','Lee','kwai.lee@google.com'),
       ('Jean','King','jean.king@me.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com');

--Method 1 usning DELETE and INNER JOIN
DELETE c1 FROM contacts c1
INNER JOIN contacts c2
WHERE
c1.id<c2.id AND
c1.email=c2.email;


--------------------------------------------------------------------------------------------
-- Interview Questions
-- 1. How to select UNIQUE records from a table using a SQL Query?
SELECT emp_ID,emp_NAME,SALARY from emp
GROUP BY emp_ID;

-- 2. How to delete DUPLICATE records from a table using a SQL Query?
-- When there is a column with unique values?
DELETE c1 FROM contacts c1
INNER JOIN contacts c2
WHERE
c1.id<c2.id AND
c1.email=c2.email;

-- 3. How to read TOP 5 records from a table using a SQL query?
SELECT *  from contacts ORDER BY id LIMIT 5;

-- 4. How to read LAST 5 records from a table using a SQL query?
SELECT * FROM (
    SELECT * FROM contacts ORDER BY id DESC LIMIT 5
    )var1
ORDER BY id ASC;

-- 5. How to select all rows from a table except the last one?
SELECT * FROM contacts
WHERE id != (SELECT MAX(id)FROM contacts);

-- 6. How to find the employee with second MAX Salary using a SQL query?
--step 1 employee with max salary
SELECT emp_name,MAX(salary) as max_sal FROM emp;
--step 2
--eleminate the above record and then find the max 
SELECT emp_name, MAX(salary) as sec_max 
FROM emp 
WHERE SALARY NOT IN (SELECT MAX(salary) as max_sal FROM emp);

-- or 
SELECT emp_name, MAX(salary) as sec_max 
FROM emp 
WHERE SALARY != (SELECT MAX(salary) as max_sal FROM emp);

-- 7. How to find the employee with third MAX Salary using a SQL query
--using Analytic Functions?
-- Method 1. 
-- With Dense Rank(Analytical function)
SELECT * FROM(
                SELECT 
                    emp_name, 
                    salary, 
                    dense_rank() over(order by salary desc)r 
                FROM emp
            ) as den
WHERE r=3
GROUP BY SALARY ;


--Method 2 
--Alternate Use of Limit
SELECT * FROM emp ORDER BY SALARY LIMIT 2,1;














SELECT store_id, store_name,product,quantity*cost, row_number() over(
    partition by store_id,store_name
    ORDER BY cost DESC) row_num
from sales;


       