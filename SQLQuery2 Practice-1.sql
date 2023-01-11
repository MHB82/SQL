-- SQL SESSÝON-1,  11,01,2023- SQL BASÝC COMMANDS

-- SELECT


SELECT 1


SELECT 'MARTIN'

SELECT 1 , 'MARTIN'

SELECT 'MARTIN' AS first_name

SELECT 1 AS 'ID'  , 'MARTIN' AS 'First Name';


-- FROM 

SELECT * 
FROM sale.customer;

SELECT first_name, last_name FROM sale.customer;

SELECT email, first_name, last_name FROM sale.customer;

-- WHERE

SELECT * 
FROM sale.customer 
WHERE city= 'Atlanta' ;


-- AND/OR
SELECT * 
FROM sale.customer 
WHERE state = 'TX'AND city='Allen' ;


SELECT *
FROM sale.customer
WHERE state = 'tX' OR city = 'Allen';


SELECT *
FROM sale.customer
WHERE  state = 'TX' AND city NOT IN ('Allen', 'Austin') ;

-- LIKE
-- '_' match any single character 
-- '%' unknown character numbers

SELECT *
FROM sale.customer
WHERE email LIKE '%gmail%'; 

SELECT *
FROM sale.customer
WHERE first_name LIKE 'di__e';



SELECT *
FROM sale.customer
WHERE first_name LIKE '[TZ]%';


SELECT *
FROM sale.customer
WHERE first_name LIKE '[A-B]%';


-- BEETWEEN

SELECT * 
FROM product.product
WHERE list_price BETWEEN 599.1 AND 799.1;

SELECT *
FROM sale.orders
WHERE order_date BETWEEN '2018-01-05' AND '2018-01-08';

-- <, >, <=, >=, =, != <>

SELECT * 
FROM product.product
WHERE list_price <1000;


-- ÝS NULL / IS NOT NULL

SELECT *	
FROM sale.customer
WHERE phone IS NULL;
 
SELECT *	
FROM sale.customer
WHERE phone IS NOT NULL;

-- TOP N

SELECT TOP 10*
FROM sale.orders

SELECT TOP 10 customer_id
FROM sale.customer


-- ORDER BY 

SELECT TOP 10 *	
FROM sale.orders
ORDER BY order_id DESC;


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY first_name ASC , last_name DESC;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY 1,2;


SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY customer_id DESC;


-- DISTINCT 

SELECT DISTINCT state, city
FROM sale.customer 

SELECT DISTINCT state, city
FROM sale.customer
ORDER BY state DESC ;
-- ORDER BY DESC

SELECT DISTINCT * -- duplicate rows
FROM sale.customer

--------------------------------------

SELECT DISTINCT  [first_name], [last_name], [phone], [email], [street], [city], [state], [zip_code]
FROM sale.customer