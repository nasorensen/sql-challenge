-- Data Engineering
-- Drop tables
DROP TABLE IF EXISTS "Departments" CASCADE;
DROP TABLE IF EXISTS "Dept_Emp" CASCADE;
DROP TABLE IF EXISTS "Dept_Manager";
DROP TABLE IF EXISTS "Employees" CASCADE;
DROP TABLE IF EXISTS "Salaries" CASCADE;
DROP TABLE IF EXISTS "Titles";

-- Created ERD from QuickDBD, exported code here:
-- Import info from CSVs

CREATE TABLE "Departments" (
    "Dept_No" VARCHAR(10)   NOT NULL,
    "Dept_Name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "Dept_No"
     )
);

CREATE TABLE "Dept_Emp" (
    "Deptemp_No" INTEGER   NOT NULL,
    "Dept_No" VARCHAR(10)   NOT NULL
);

CREATE TABLE "Titles" (
    "Title_ID" VARCHAR(10)   NOT NULL,
    "Title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "Title_ID"
     )
);

CREATE TABLE "Employees" (
    "Emp_No" INTEGER   NOT NULL,
    "Emp_Title_ID" VARCHAR   NOT NULL,
    "Birth_Date" VARCHAR   NOT NULL,
    "First_Name" VARCHAR   NOT NULL,
    "Last_Name" VARCHAR   NOT NULL,
    "Sex" VARCHAR   NOT NULL,
    "Hire_Date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "Emp_No"
     )
);

CREATE TABLE "Dept_Manager" (
    "Dept_No" VARCHAR(10)   NOT NULL,
    "Emp_No" INTEGER   NOT NULL
);

CREATE TABLE "Salaries" (
    "Emp_No" INTEGER   NOT NULL,
    "Salary" INTEGER   NOT NULL
);

ALTER TABLE "Dept_Emp" ADD CONSTRAINT "fk_Dept_Emp_Dept_No" FOREIGN KEY("Dept_No")
REFERENCES "Departments" ("Dept_No");

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_Emp_Title_ID" FOREIGN KEY("Emp_Title_ID")
REFERENCES "Titles" ("Title_ID");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_Dept_Manager_Dept_No" FOREIGN KEY("Dept_No")
REFERENCES "Departments" ("Dept_No");

ALTER TABLE "Dept_Manager" ADD CONSTRAINT "fk_Dept_Manager_Emp_No" FOREIGN KEY("Emp_No")
REFERENCES "Employees" ("Emp_No");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_Emp_No" FOREIGN KEY("Emp_No")
REFERENCES "Employees" ("Emp_No");

-- Query * FROM for each table to test
SELECT * FROM "Departments";
SELECT * FROM "Dept_Emp";
SELECT * FROM "Employees";
SELECT * FROM "Dept_Manager";
SELECT * FROM "Salaries";
SELECT * FROM "Titles";

-- Data Analysis
-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT "Employees"."Emp_No", "Employees"."Last_Name", "Employees"."First_Name", "Employees"."Sex", "Salaries"."Salary"
FROM "Employees"
JOIN "Salaries"
ON "Employees"."Emp_No" = "Salaries"."Emp_No";

-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT "First_Name", "Last_Name", "Hire_Date"
FROM "Employees"
WHERE "Hire_Date" ~ '1986'
ORDER BY "Hire_Date";

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT "Departments"."Dept_No", "Departments"."Dept_Name", "Dept_Manager"."Emp_No", "Employees"."Last_Name", "Employees"."First_Name"
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp"."Deptemp_No" = "Employees"."Emp_No"
JOIN "Departments"
ON "Dept_Emp"."Dept_No" = "Departments"."Dept_No";

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT "Departments"."Dept_No", "Dept_Emp"."Deptemp_No", "Employees"."Last_Name", "Employees"."First_Name"
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp"."Deptemp_No" = "Employees"."Emp_No"
JOIN "Departments"
ON "Dept_Emp"."Dept_No" = "Departments"."Dept_No";

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT "Employees"."First_Name", "Employees"."Last_Name", "Employees"."Sex"
FROM "Employees"
WHERE "First_Name" = 'Hercules'
AND "Last_Name" LIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name.
SELECT "Departments"."Dept_Name", "Employees"."Emp_No", "Employees"."Last_Name", "Employees"."First_Name"
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp"."Deptemp_No" = "Employees"."Emp_No"
JOIN "Departments"
ON "Dept_Emp"."Dept_No" = "Departments"."Dept_No"
WHERE "Departments"."Dept_Name" = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT "Dept_Emp"."Deptemp_No", "Employees"."Last_Name", "Employees"."First_Name", "Departments"."Dept_Name"
FROM "Dept_Emp"
JOIN "Employees"
ON "Dept_Emp"."Deptemp_No" = "Employees"."Emp_No"
JOIN "Departments"
ON "Dept_Emp"."Dept_No" = "Departments"."Dept_No"
WHERE "Departments"."Dept_Name" = 'Sales' OR "Departments"."Dept_Name" = 'Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT "Last_Name", 
COUNT("Last_Name") AS "Frequency"
FROM "Employees"
GROUP BY "Last_Name"
ORDER BY
COUNT ("Last_Name") DESC;
