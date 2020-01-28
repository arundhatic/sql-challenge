-- importing the csv files and creating their respective tables 

DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS dept_employee;
DROP TABLE IF EXISTS dept_manager;

CREATE TABLE Public."employees" (
    emp_no int PRIMARY KEY NOT NULL,
    birth_date date  NOT NULL,
    first_name varchar(30)   NOT NULL,
    last_name varchar(30)   NOT NULL,
    gender varchar   NOT NULL,
    hire_date date   NOT NULL
);

SELECT * FROM Public."employees";

-- workaround for pgAdmin on Mac
COPY Public."employees" FROM '/sql-challenge/Resources/employees.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE Public."departments" (
    dept_no VARCHAR(30)   NOT NULL,
    dept_name varchar(30)   NOT NULL,
    PRIMARY KEY (dept_no)
);

SELECT * FROM Public."departments";

-- workaround for pgAdmin on Mac
COPY Public."departments" FROM '/sql-challenge/Resources/departments.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE Public."salaries" (
    emp_no int   NOT NULL,
    salary int   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM Public."salaries";

-- workaround for pgAdmin on Mac
COPY Public."salaries" FROM '/sql-challenge/Resources/salaries.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE Public."titles" (
    emp_no int   NOT NULL,
    title varchar(30)   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM Public."titles";

-- workaround for pgAdmin on Mac
COPY Public."titles" FROM '/sql-challenge/Resources/titles.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE Public."dept_employee" (
    emp_no int   NOT NULL,
    dept_no VARCHAR(30)   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT * FROM Public."dept_employee";

COPY Public."dept_employee" FROM '/sql-challenge/Resources/dept_emp.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE Public."dept_manager" (
    dept_no VARCHAR(30)   NOT NULL,
    emp_no int   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT * FROM Public."dept_manager";

COPY Public."dept_manager" FROM '/sql-challenge/Resources/dept_manager.csv'
DELIMITER ',' CSV HEADER;

--List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT * FROM employees;

-- List employees who were hired in 1986.
SELECT * FROM employees
WHERE hire_date 
BETWEEN '1986-01-01' AND '1986-12-31';

--List the manager of each department with the following information: department number, department name, the manager's 
--employee number, last name, first name, and start and end employment dates.

SELECT * FROM departments;
SELECT * FROM dept_manager; 
SELECT * FROM employees;

SELECT e.emp_no, dm.dept_no, d.dept_name, e.last_name, 
e.first_name,e.hire_date, dm.from_date, dm.to_date
FROM employees AS e
INNER JOIN dept_manager AS dm
ON e.emp_no = dm.emp_no
INNER JOIN departments AS d
ON dm.dept_no = d.dept_no;

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e 
INNER JOIN dept_manager AS dm
ON e.emp_no = dm.emp_no
INNER JOIN departments AS d
ON dm.dept_no = d.dept_no;

--List all employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List all employees in the Sales department, including their employee number, 
--last name, first name, and department name

SELECT e.emp_no, e.first_name, e.last_name
FROM employees AS e
WHERE emp_no IN (
   SELECT emp_no
   FROM dept_employee
   WHERE dept_no IN (
      SELECT dept_no
	  FROM departments 
	  WHERE dept_name = 'Sales' 
   )
);

SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_employee AS de
JOIN employees AS e
ON de.emp_no = e.emp_no
JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_employee AS de
JOIN employees AS e
ON de.emp_no = e.emp_no
JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' 
OR d.dept_name = 'Development';

--In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.

SELECT last_name,
COUNT(last_name) AS "count of last name"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;
