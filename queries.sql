CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR(40) NOT NULL,
     last_name VARCHAR(40) NOT NULL,
     gender VARCHAR(40) NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
	emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no,dept_no)
);
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR(20) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no,from_date)
);
--SELECT * FROM departments;
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employees_per_department
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;


SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');


SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

SELECT	ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name	
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

SELECT	di.emp_no, di.first_name, di.last_name,di.dept_name
INTO tailored_list_0
FROM dept_info as di
INNER JOIN employees as e
ON (di.emp_no = e.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT	tl0.emp_no, tl0.first_name, tl0.last_name,tl0.dept_name
INTO tailored_list_1
FROM tailored_list_0 as tl0
WHERE tl0.dept_name = 'Sales';

SELECT	tl0.emp_no, tl0.first_name, tl0.last_name,tl0.dept_name
INTO tailored_list_2
FROM tailored_list_0 as tl0
WHERE tl0.dept_name IN ('Sales', 'Development');

-- SELECT	di.emp_no, di.first_name, di.last_name,di.dept_name
-- INTO tailored_list_2
-- FROM dept_info as di
-- INNER JOIN employees as e
-- ON (di.emp_no = e.emp_no)
-- INNER JOIN dept_emp as de
-- ON (e.emp_no = de.emp_no)
-- INNER JOIN departments AS d
-- ON (de.dept_no = d.dept_no)
-- WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
-- AND (de.to_date = '9999-01-01')
-- AND (d.dept_name = 'Sales' OR d.dept_name = 'Development');



----------------------------------
--CHALLENGE
----------------------------------

-- Challenge_derivable_1

-- Quoting from the section 7.3.1 in Module 7:
-- "Bobby’s boss has determined that anyone born between 1952 and 1955 will begin to retire".
-- "This time, we’re looking for employees born between 1952 and 1955, who were also hired between 1985 and 1988.""
-- Following this definition, I determined the number of retiring people in the following way
-- and following instruction given by the Challenge to the maximum possible extent:

-- Preparing a full table
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, s.salary, de.to_date
INTO challenge_d1_full
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');


-- Selecting the desired records from the full table
SELECT emp_no, first_name, last_name, title, from_date
INTO challenge_d1
FROM
  (SELECT cd1f.emp_no, cd1f.first_name, cd1f.last_name, cd1f.title, cd1f.from_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   FROM challenge_d1_full as cd1f
  ) tmp WHERE rn = 1;



-- Challenge_derivable_2: Mentorship program 1965

-- preparing a full table
SELECT cd1.emp_no, cd1.first_name, cd1.last_name, cd1.title, cd1.from_date, ti.to_date, e.birth_date
INTO challenge_d2_full_b
FROM challenge_d1 as cd1
INNER JOIN employees as e
ON (cd1.emp_no = e.emp_no)
INNER JOIN titles as ti
ON (cd1.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');


-- Selecting the desired records from the full table
SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO challenge_d2_b
FROM
  (SELECT cd2fb.emp_no, cd2fb.first_name, cd2fb.last_name, cd2fb.title, cd2fb.from_date, cd2fb.to_date, cd2fb.birth_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY to_date DESC) rn
	FROM challenge_d2_full_b as cd2fb
  ) tmp WHERE rn = 1;

-- Result: 0 records selected.
-- Since one of the conditions that define retiring employees is that they are born
-- between 1952 and 1955, there is no retiring employee fit for the mentorship program
-- because the condition for this is to have been born in 1965.
-- If we change the condition of eligibility to: being born in the year 1955, we can extract
-- the desired data by using the following query script:

-- EXTRA Challenge_derivable_2: Mentorship program 1955
-- preparing a full table
SELECT cd1.emp_no, cd1.first_name, cd1.last_name, cd1.title, cd1.from_date, ti.to_date, e.birth_date
INTO challenge_d2_full
FROM challenge_d1 as cd1
INNER JOIN employees as e
ON (cd1.emp_no = e.emp_no)
INNER JOIN titles as ti
ON (cd1.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1955-01-01' AND '1955-12-31');


-- Selecting the desired records from the full table
SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO challenge_d2
FROM
  (SELECT cd2f.emp_no, cd2f.first_name, cd2f.last_name, cd2f.title, cd2f.from_date, cd2f.to_date, cd2f.birth_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY to_date DESC) rn
	FROM challenge_d2_full as cd2f
  ) tmp WHERE rn = 1;



