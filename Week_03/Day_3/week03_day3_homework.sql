-- MVP

--Q1 - How many employee records are lacking both a grade and salary?

SELECT 
	count(id)
FROM employees 
WHERE grade IS NULL AND salary IS NULL;

--Q2 - Produce a table with the two following fields (columns):
-- the department
--the employees full name (first and last name)
--Order your resulting table alphabetically by department, and then by last name

SELECT 
	concat(first_name , ' ', last_name) AS full_name,
	department 
FROM employees
ORDER BY department, last_name;


--Q3 - Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.

SELECT *
FROM employees 
WHERE last_name ~ '^A.'
ORDER BY salary DESC NULLS LAST 
LIMIT 10

--Q4 - Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT 
	count(id),
	department,
	start_date
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department, start_date ;

--Q5 - Obtain a table showing department, fte_hours and the number of employees in each department who 
--work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours.

SELECT 
	department ,
	fte_hours ,
	count(fte_hours)
FROM employees 
GROUP BY department, fte_hours 
ORDER BY department, fte_hours ASC NULLS LAST;

--Q6 - Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme.

--SELECT 
	--SUM(CASE pension_enrol
		--WHEN TRUE THEN 1
		--ELSE 0
		--END) "Enrolled",
	--SUM(CASE pension_enrol
		--WHEN FALSE THEN 1
		--ELSE 0
		--END) "Not enrolled",
	--SUM(CASE pension_enrol
		--WHEN NULL THEN 1
		--ELSE 0
		--END) "Unknown"
--FROM employees;

SELECT 
	count(id),
	pension_enrol 
FROM employees 
GROUP BY pension_enrol ;

--Q7 - Obtain the details for the employee with the highest salary in the ‘Accounting’ department who is not enrolled in the pension scheme?

SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE 
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

--Q8 - Get a table of country, number of employees in that country, and the average salary of employees in that country for any countries in 
--which more than 30 employees are based. Order the table by average salary descending.

SELECT 
	country,
	Round (avg(salary), 2) AS avg_salary,
	count(id)
FROM employees
GROUP BY country 
HAVING count(id) > 30
ORDER BY avg_salary DESC;

--Q9 - Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and a new column 
--effective_yearly_salary which should contain fte_hours multiplied by salary. Return only rows where effective_yearly_salary is more than 30000.

SELECT 
	first_name ,
	last_name ,
	fte_hours ,
	salary,
	round(fte_hours * salary, 2)  AS effective_yearly_salary
FROM employees 
WHERE round(fte_hours * salary, 2) > 30000
ORDER BY effective_yearly_salary ASC NULLS LAST;


--Q10 - Find the details of all employees in either Data Team 1 or Data Team 2

SELECT 
	E.*,
	T.name 
FROM employees AS E
INNER JOIN teams AS T ON E.team_id = T.id 
WHERE T.name = 'Data Team 1' OR T.name = 'Data Team 2'
ORDER BY T.name;

--Q11 - Find the first name and last name of all employees who lack a local_tax_code. Pay_details

SELECT 
	E.first_name ,
	E.last_name ,
	p_d.local_tax_code 
FROM employees AS E
LEFT JOIN pay_details AS p_d ON E.pay_detail_id = p_d.id 
WHERE p_d.local_tax_code IS NULL;

--Q12 - The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
--where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.

SELECT
	E.*,
	T.charge_cost,
	T.name,
	round((48 * 35 * CAST(T.charge_cost AS INTEGER) - E.salary) * E.fte_hours, 2)  AS expected_profit
FROM employees AS E
INNER JOIN teams AS T ON E.team_id = T.id
ORDER BY T.name, expected_profit DESC NULLS LAST;

--Q13 - Find the first_name, last_name and salary of the lowest paid employee in Japan who works the least common full-time equivalent hours across the corporation.


WITH fte_grouped AS (
	SELECT 
		count(id) AS fte_count,
		fte_hours AS least_common_fte
	FROM employees 
	GROUP BY fte_hours
	ORDER BY fte_count ASC NULLS LAST
	LIMIT 1
	)
SELECT 
	first_name ,
	last_name ,
	salary
FROM employees
WHERE country = 'Japan' AND
	fte_hours = (
		SELECT least_common_fte
		FROM fte_grouped)
ORDER BY salary ASC NULLS LAST
LIMIT 1;


-- Q14 - Obtain a table showing any departments in which there are two or more employees lacking a stored first name. 
-- Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.



SELECT 
	count(id) AS count_no_first_name,
	department
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING count(id) >= 2;


--Q15 - Return a table of those employee first_names shared by more than one employee, together with a count of the number of times 
--each first_name occurs. Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.


SELECT 
	first_name,
	count(id)
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name
HAVING count(id) >=2
ORDER BY count(id) DESC, first_name;


--Q16 - Find the proportion of employees in each department who are grade 1.

SELECT 
	department,
	SUM(CAST(grade = 1 AS INTEGER)) / CAST(count(id) AS REAL)
FROM employees
GROUP BY department ;

--Check proportion calculation
SELECT 
	department,
	SUM(CAST(grade = 1 AS INTEGER)),
	count(id)
FROM employees
GROUP BY department ;


