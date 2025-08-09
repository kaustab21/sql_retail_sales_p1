--SQL RETAIL SALES ANALYSIS -p1

CREATE DATABASE sql_project_p2;

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) 
FROM retail_sales


SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time  IS NULL

--DATA CLEANING
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time  IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
-- delete null values

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time  IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
--DATA EXPLORATION 
--HOW MANY SALAES WE HAVE

SELECT COUNT(*) AS total_sale FROM retail_sales

--HOW MANY UNIQUEUE CUSTOMERS WE HAVE

SELECT COUNT( DISTINCT customer_id) AS total_sale FROM retail_sales

SELECT  DISTINCT category FROM retail_sales

-- DATA ANALYSIS &  BUSINESS KEY PROBLEM AND ANSWERS

--Q1. WRITE A SQL QUERY TO RETRIEVE ALL COL FOR SALES MADE ON '2022-11-05'

SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

--Q2. WRITE A SQL QUERY TO RETRIEVE  ALL TRANSACTIONS WHERE THE CATAGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022

/*SELECT 
	category,
	SUM(quantiy)
FROM retail_sales 
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-YY')= '2022-11'
GROUP BY 1
*/

SELECT *
FROM retail_sales 
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-YY')= '2022-11'
	AND 
	quantiy >=1;

--Q3. write a sql query to calculate total_sales for each catagoy


SELECT category,
	SUM (total_sale) AS net_sale,
	COUNT(*) AS total_orders
from retail_sales
GROUP BY 1

--Q4. write a sql query to find avg age of customers who purchased items from the 'beauty' catagory

SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category= 'Beauty'

--Q5. write a sql query to find all transaction where the total_sale is greater than 1000

SELECT * FROM retail_sales
WHERE total_sale >1000

--Q6. write a sql query to find THE TOTAL NP OF TRANSACTION MADE BY EACH GENDER EACH CATAGORY

SELECT 
	category, 
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1

--Q7. write a sql query to CALCULATE avg sale for each month. find the best selling month of a year
SELECT * FROM 
(
SELECT 
	EXTRACT(year FROM sale_date) as year,
	EXTRACT(month FROM sale_date) as month,
	AVG(total_sale) as AVG_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2
) AS T1
WHERE RANK =1
-- ORDER BY 1,3 DESC

--Q8. WRITE SQL QUERIES TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGEST TOTAL SALES

SELECT customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9. WRITE SQL QUERIES TO FIND THE NO OF UNIQUE CUSTOMR WHO PURCHASED EACH CATAGORY


SELECT 
	category,
	COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER
FROM retail_sales
GROUP BY category

--Q10. WRITE SQL QUERIES TO create each shift and no of orders (EX: morning <12, afternoon btw 12 & 17, evening>17)

WITH hourly_sale
as
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift 


--end of project--







