-- MVP

--Q1.a - Find the first name, last name and team name of employees who are members of teams.


SELECT
	EM.first_name ,
	EM.last_name ,
	T.name
FROM employees AS EM
INNER JOIN teams AS T ON EM.team_id  = T.id
ORDER BY T.name, EM.last_name ;

--Q1.b -  Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.

SELECT
	EM.first_name ,
	EM.last_name ,
	EM.pension_enrol, 
	T.name
FROM employees AS EM
INNER JOIN teams AS T ON EM.team_id  = T.id 
WHERE EM.pension_enrol IS TRUE
ORDER BY T.name, EM.last_name ;

--Q1.c - Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.

SELECT
	EM.first_name ,
	EM.last_name ,
	T.name,
	T.charge_cost 
FROM employees AS EM
INNER JOIN teams AS T ON EM.team_id  = T.id 
WHERE (CAST(T.charge_cost AS INTEGER)) > 80
ORDER BY T.charge_cost, T.name, EM.last_name ;

--Q2.a -  Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.

SELECT 
	employees.*,
	PD.local_account_no,
	PD.local_sort_code 
FROM employees
LEFT JOIN pay_details AS PD ON employees.pay_detail_id  = PD.id
ORDER BY employees.last_name ;

--Q2.b - Amend your query above to also return the name of the team that each employee belongs to.

SELECT 
	employees.*,
	PD.local_account_no,
	PD.local_sort_code,
	T.name 
FROM employees
LEFT JOIN pay_details AS PD ON employees.pay_detail_id  = PD.id
LEFT JOIN teams AS T ON employees.team_id = T.id 
ORDER BY employees.last_name ;


-- Q3.a - Make a table, which has each employee id along with the team that employee belongs to.

SELECT
	E.id,
	T.name
FROM employees AS E
LEFT JOIN teams AS T ON E.team_id = T.id
ORDER BY E.id;

-- Q3.b/c -  Breakdown the number of employees in each of the teams and then order by least to most employees
SELECT
	count(E.id) AS employees_count,
	T.name
FROM employees AS E 
LEFT JOIN teams AS T ON E.team_id = T.id
GROUP BY T.name
ORDER BY employees_count;

-- Q4.a - Create a table with the team id, team name and the count of the number of employees in each team.

SELECT
	count(E.id) AS employees_count,
	T.name,
	T.id
FROM employees AS E 
LEFT JOIN teams AS T ON E.team_id = T.id
GROUP BY T.name, T.id
ORDER BY T.id;

--Q4.b - The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of
-- employees in the team. Calculate the total_day_charge for each team.

SELECT
	count(E.id) * CAST(T.charge_cost AS INTEGER) AS total_day_charge,
	T.name,
	T.id
FROM employees AS E 
LEFT JOIN teams AS T ON E.team_id = T.id
GROUP BY T.name, T.id;

--Check total_day_charge

SELECT
	count(E.id) AS employees_count,
	count(E.id) * CAST(T.charge_cost AS INTEGER) AS total_day_charge,
	T.charge_cost, 
	T.name,
	T.id
FROM employees AS E 
LEFT JOIN teams AS T ON E.team_id = T.id
GROUP BY T.name, T.id, T.charge_cost ;

--Q4.c - How would you amend your query from above to show only those teams with a total_day_charge greater than 5000?

SELECT
	count(E.id) * CAST(T.charge_cost AS INTEGER) AS total_day_charge,
	T.name,
	T.id
FROM employees AS E 
LEFT JOIN teams AS T ON E.team_id = T.id
GROUP BY T.name, T.id
HAVING (Cast(T.charge_cost AS integer)*count(E.id)) > 5000;

-- Extensions

-- Q5. How many of the employees serve on one or more committees?

SELECT
	count(DISTINCT(employees_committees.employee_id))
FROM employees_committees;

-- Q6. How many of the employees do not serve on a committee?

SELECT 
	count(E.id)
FROM employees AS E
LEFT JOIN employees_committees AS EC ON E.id = EC.employee_id 
WHERE EC.committee_id IS NULL;




































