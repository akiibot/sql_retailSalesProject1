-- Create the database
CREATE DATABASE retailProject;

-- Create the retail_sales table
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- View all data
SELECT * FROM retail_sales;

-- Total number of records
SELECT COUNT(*) AS total_records FROM retail_sales;

-- Unique customers count
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Unique product categories
SELECT DISTINCT category FROM retail_sales;

--Null Value Check: Check for any null values in the dataset and delete records with missing data.

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


-- Delete records with missing values

DELETE  FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--Data Analysis & Findings

--1. Sales made on a specific date:

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


--Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


SELECT * FROM retail_sales;
--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales rs 
where rs.total_sale  < 1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_sales
WHERE rank = 1;

    
--**Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


--Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;


--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

--Top 3 selling product categories (by total revenue)
SELECT 
    category,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 3;


--Repeat customers (customers who made more than 1 purchase)

SELECT 
    customer_id,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_transactions DESC;

-- Daily sales trend (total sale per day)

SELECT 
    sale_date,
    SUM(total_sale) AS daily_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;

--Average quantity sold per category
SELECT 
    category,
    ROUND(AVG(quantity), 2) AS avg_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY avg_quantity_sold DESC;

--Price analysis: Max, Min, and Avg price per unit for each category

SELECT 
    category,
    MAX(price_per_unit) AS max_price,
    MIN(price_per_unit) AS min_price,
    ROUND(AVG(price_per_unit)::NUMERIC, 2) AS avg_price
FROM retail_sales
GROUP BY category
ORDER BY avg_price DESC;

