/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [customer_id]
      ,[first_name]
      ,[last_name]
      ,[phone]
      ,[email]
      ,[street]
      ,[city]
      ,[state]
      ,[zip_code]
FROM [SampleRetail].[sale].[customer]

SELECT  city,
COUNT(customer_id) AS customers_city
FROM sale.customer 
GROUP BY city
ORDER BY  customers_city  DESC;


SELECT order_id, SUM(quantity) AS total_quantity
FROM sale.order_item 
GROUP BY order_id



SELECT customer_id, MIN(order_date) AS order_date
FROM sale.orders
GROUP BY customer_id;


SELECT  order_id, SUM(quantity*list_price* (1- discount)) total_amount
FROM sale.order_item
GROUP BY order_id



SELECT TOP 1 order_id, AVG(list_price) avg_product_price
FROM sale.order_item
GROUP BY order_id
ORDER BY avg_product_price  DESC;



SELECT brand_id, product_id, list_price FROM product.product ORDER BY brand_id, list_price DESC;

SELECT list_price, brand_id, product_id FROM product.product ORDER BY list_price DESC, brand_id ASC;

SELECT TOP(10) * FROM product.product WHERE list_price >=3000;

SELECT TOP(5) * FROM product.product WHERE list_price <3000;

SELECT last_name
FROM sale.customer
WHERE last_name LIKE 'B%s';


SELECT *
FROM sale.customer 
WHERE city='Allen' OR city='Buffalo' OR city='Boston' OR city='Berkeley';

