DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

CREATE TABLE departments (
	dept_no character varying(20) NOT NULL,
	dept_name character varying(45) NOT NULL,
	PRIMARY KEY (dept_no)
);


CREATE TABLE employees (
	emp_no integer NOT NULL, 
	birth_date date NOT NULL,
	first_name character varying(45) NOT NULL,	
	last_name character varying(45) NOT NULL,	
	gender character varying(10) NOT NULL,	
	hire_date date NOT NULL,
	PRIMARY KEY (emp_no)
);

ALTER TABLE employees
	ADD UNIQUE dept_manager (emp_no);


CREATE TABLE dept_emp (
	emp_no integer NOT NULL,
	dept_no character varying(20) NOT NULL,	
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


CREATE TABLE dept_manager (
	dept_no character varying(20) NOT NULL,
	emp_no integer NOT NULL, 
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

	
CREATE TABLE salaries (
	emp_no integer NOT NULL, 
	salary integer NOT NULL, 
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles (
	emp_no integer NOT NULL, 
	title character varying(30) NOT NULL,	
	from_date date NOT NULL,
	to_date date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);



--SQL assignment code 

-- 1. List the following details of each employee: 
-- employee number, last name, first name, gender, and salary
select e.emp_no, e.last_name, e.first_name, e.gender, s.salary
from employees AS e
left join salaries AS s
on s.emp_no = e.emp_no;


-- 2. List employees who were hired in 1986.
select *
from employees
where hire_date::TEXT LIKE '1986%';


-- **3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name, and start and end employment dates.
SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name, m.from_date, m.to_date
FROM departments AS d
JOIN dept_manager AS m
ON d.dept_no = m.dept_no
JOIN employees AS e
ON m.emp_no = e.emp_no;


SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name, m.from_date, m.to_date
FROM employees AS e
JOIN dept_manager AS m
ON m.emp_no = e.emp_no
JOIN departments AS d
ON d.dept_no = m.dept_no;



-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, t.dept_name
FROM employees AS e
JOIN dept_emp AS d
ON e.emp_no = d.emp_no
JOIN departments AS t
ON t.dept_no = d.dept_no;


-- 5. List all employees whose first name is "Hercules" and 
-- last names begin with "B."

select first_name, last_name
from employees
where first_name = 'Hercules' AND last_name::TEXT LIKE 'B%';


-- 6. List all employees in the Sales department, including their 
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, t.dept_name
FROM employees AS e
JOIN dept_emp AS d
ON e.emp_no = d.emp_no
JOIN departments AS t
ON t.dept_no = d.dept_no
WHERE t.dept_name:: TEXT LIKE 'Sales';


-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and 
-- department name.
SELECT e.emp_no, e.last_name, e.first_name, t.dept_name
FROM employees AS e
JOIN dept_emp AS d
ON e.emp_no = d.emp_no
JOIN departments AS t
ON t.dept_no = d.dept_no
WHERE t.dept_name:: TEXT LIKE 'Sales' OR t.dept_name:: TEXT LIKE 'Development' AND t.dept_name:: TEXT LIKE 'Development';


-- 8. In descending order, list the frequency count of employee 
-- last names, i.e., how many employees share each last name.
select * from employees;

SELECT last_name, COUNT (last_name) AS "Last name counts"
From employees
GROUP BY last_name
ORDER BY "last_name" DESC;