USE pizza_sales

-- KPIs
-- 1) Total Revenue (How much money did we make this year?)
-- 2) Average Order Value
-- 3) Total Pizzas Sold
-- 4) Total Orders
-- 5) Average Pizzas per Order
-- SALES ANALYSIS QUESTIONS
-- 1) What is the Busiest Day for Pizza Sales?
-- 2) What Hour of the Day has the Most Total Orders?
-- 3) What is the Sales Percentage per Pizza Category?
-- 4) What is the Percentage of Sales per Pizza Size?
-- 5) How Many Total Pizzas are Sold per Pizza Category
-- 6) What are the Top 5 Best Sellers Measured by Total Pizzas Sold?
-- 7) What are the Bottom 5 Worst Sellers Measured by Total Pizzas Sold?

-- KPIs
-- 1) Total Revenue (How much money did we make this year?)

SELECT *
FROM order_details as o
	JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id
	ORDER BY quantity DESC;

SELECT *
FROM pizzas
WHERE pizza_id = 'sicilian_m'

SELECT 
round(SUM(quantity * price), 2) AS [Total Revenue]
FROM order_details as o
	JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id


-- 2) Average Order Value

SELECT 
round(SUM(quantity * price)/COUNT(DISTINCT order_id), 2) AS [Average Order Value]
FROM order_details as o
	JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id


-- 3) Total Pizzas Sold

 SELECT 
  SUM(quantity) AS [Total Pizzas Sold]
 FROM order_details;


-- 4) Total Orders
SELECT 
COUNT(DISTINCT order_id) AS [Total Orders]
 FROM order_details;


-- 5) Average Pizzas per Order

SELECT 
 SUM(quantity)/COUNT(DISTINCT order_id) AS [Average Pizzas Per Order]
FROM order_details;


-- SALES ANALYSIS QUESTIONS
-- 1) What is the Busiest Day for Pizza Sales?

SELECT *
FROM orders


SELECT 
 FORMAT( date, 'dddd') AS DayOfWeek
 ,COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT( date, 'dddd')
ORDER BY total_orders DESC;

-- 2) What Hour of the Day has the Most Total Orders?

SELECT 
    DATEPART(HOUR, time) AS [Hour]
	,COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [Hour]


-- 3) What is the Sales Percentage per Pizza Category?

-- tr_pc: calculate total revenue per category
-- % sales calculated as (tr_pc:/total revenue) * 100

SELECT 
    category,
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS sales_percentage
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    category;

-- 4) What is the Percentage of Sales per Pizza Size?

SELECT 
size
,SUM(quantity * price) AS revenue
,round(SUM(quantity * price) * 100/(
  SELECT SUM(quantity * price)
  FROM pizzas AS p2
  JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
  ), 2) AS percentage_sales
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY percentage_sales DESC;

-- 5) How Many Total Pizzas are Sold per Pizza Category

SELECT 
category
,SUM(quantity) AS quantity_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY SUM(quantity) DESC;

-- 6) What are the Top 5 Best Sellers Measured by Total Pizzas Sold?

SELECT TOP 5
name
,SUM(quantity) AS total_pizzas_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold DESC;

-- 7) What are the Bottom 5 Worst Sellers Measured by Total Pizzas Sold?

SELECT TOP 5
name
,SUM(quantity) AS total_pizzas_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold ASC;