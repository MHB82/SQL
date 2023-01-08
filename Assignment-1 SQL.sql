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


SELECT DISTINCT city,
MAX(customer_id) AS customer_city
FROM sale.customer 
GROUP BY city
ORDER BY  customer_city  DESC;

SELECT  product_id,
SUM(order_id) AS total_quantity
FROM sale.order_item 
GROUP BY product_id
ORDER BY total_quantity;


SELECT order_date, customer_id FROM sale.orders;

SELECT order_id,
SUM(quantity) AS total_amount
FROM sale.order_item
GROUP BY order_id
ORDER BY total_amount DESC;


SELECT MAX(list_price) AS max_price
FROM sale.order_item;


SELECT brand_id, product_id, list_price FROM product.product ORDER BY brand_id DESC;

SELECT list_price, brand_id, product_id FROM product.product ORDER BY list_price DESC;

SELECT TOP(10) * FROM product.product WHERE list_price >=3000;

SELECT TOP(5) * FROM product.product WHERE list_price <3000;

SELECT last_name
FROM sale.customer
WHERE last_name LIKE 'B%s';


SELECT *
FROM sale.customer 
WHERE city='Allen' OR city='Buffalo' OR city='Boston' OR city='Berkeley';

