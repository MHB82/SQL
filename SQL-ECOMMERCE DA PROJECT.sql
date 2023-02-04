CREATE DATABASE dbo.e_commerce_data 
USE dbo.e_commerce_data 



--DaWSQL ---

--1.We created a new table named "combined_table" consisting these tables (“market_fact”, “cust_dimen”, “orders_dimen”, “prod_dimen”, “shipping_dimen”,)

select A.Sales, A.Discount, A.Order_Quantity, A.Product_Base_Margin, B.*,C.*,D.*,E.*
INTO dbo.e_commerce_data 
  from dbo.e_commerce_data A
        FULL OUTER JOIN orders_dimen B ON B.Ord_id = A.Ord_id
        FULL OUTER JOIN prod_dimen C ON C.Prod_id = A.Prod_id
        FULL OUTER JOIN cust_dimen D ON D.Cust_id = A.Cust_id
        FULL OUTER JOIN Shipping_Dimen E ON E.Ship_id = A.Ship_id 


------------------

--2. Find the top 3 customers who have the maximum count of orders.


SELECT TOP 3 Cust_ID, Customer_Name, COUNT(DISTINCT Ord_ID) AS count_of_order
FROM dbo.e_commerce_data 
GROUP BY Cust_ID, Customer_Name
ORDER BY count_of_order DESC 


--3.Create a new column at combined_table as DaysTakenForShipping that contains the date difference of Order_Date and Ship_Date.

Alter table dbo.e_commerce_data  add DaysTakenForShipping INT;

UPDATE dbo.e_commerce_data 
SET DaysTakenForShipping = DATEDIFF(DAY,Order_Date,Ship_date)

SELECT DaysTakenForShipping
FROM dbo.e_commerce_data 

--4. Find the customer whose order took the maximum time to get shipping.

SELECT top 1 Cust_ID, Customer_Name, Order_Date, Ship_Date, DaysTakenForShipping
FROM dbo.e_commerce_data 
ORDER BY DaysTakenForShipping DESC


--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011.


SELECT MONTH(Order_Date) as month, count(DISTINCT Cust_ID) as count_of_customer
FROM dbo.e_commerce_data 
WHERE Cust_ID IN(
                    SELECT Cust_ID
                    FROM dbo.e_commerce_data 
                    WHERE Datepart(MONTH, Order_Date) = 1 and YEAR(Order_Date) = 2011  
                )
AND YEAR(Order_Date) = 2011
GROUP BY MONTH(Order_Date)

--6. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.


GO

WITH T1 AS
(
SELECT Cust_ID,Order_Date,
MIN(Order_Date) OVER (PARTITION BY Cust_ID order by Order_Date, Cust_ID) first_order,
DENSE_RANK() OVER (PARTITION BY Cust_ID order by Order_Date, Cust_ID) dn_rnk
FROM dbo.e_commerce_data  
)
SELECT distinct Cust_ID, Order_Date, DATEDIFF(DAY,first_order,Order_Date ) AS elapsed_time
FROM  T1 
WHERE dn_rnk  = 3 
ORDER BY Cust_ID

--7.Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.



WITH T1 AS 
(
SELECT  Cust_ID, COUNT(Prod_ID) total_prod,
        SUM(CASE WHEN Prod_ID = 'Prod_11' THEN 1 ELSE 0 END) AS PRO_11,
        SUM(CASE WHEN Prod_ID = 'Prod_14' THEN 1 ELSE 0 END) AS PRO_14
FROM dbo.e_commerce_data 
WHERE Cust_ID in (SELECT Cust_ID
                  FROM dbo.e_commerce_data  
                  WHERE Prod_ID = 'Prod_11'
                  INTERSECT
                  SELECT Cust_ID
                  FROM dbo.e_commerce_data  
                  WHERE Prod_ID = 'Prod_14')
GROUP BY Cust_ID
)
SELECT Cust_ID, ROUND((cast(PRO_11 as float) ) / cast(total_prod as float),2) RATIO_11,
ROUND((cast(PRO_14 as float)) / cast(total_prod as float),2) RATIO_14
FROM T1


--Customer Segmentation
--Categorize customers based on their frequency of visits. The following steps will guide you. If you want, you can track your own way.

--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW logs_of_customer
AS 
SELECT Cust_ID, YEAR(Order_Date) [Year], MONTH(Order_Date) [Month]
FROM dbo.e_commerce_data 

SELECT*
FROM logs_of_customer
ORDER by Cust_ID,[Year]


--2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)


CREATE VIEW montly_visits
AS 
SELECT Cust_ID, MONTH(Order_Date) Month_order, COUNT(Order_Date) cnt_order
FROM dbo.e_commerce_data 
GROUP BY Cust_ID, MONTH(Order_Date)


SELECT*
FROM montly_visits
ORDER BY Cust_ID

--3. For each visit of customers, create the next month of the visit as a separate column.


CREATE VIEW Next_Visit_Month AS

SELECT Cust_ID, Year_order , Month_order,
LEAD(Month_order) OVER (partition by Cust_ID order by Year_order, Month_order) Next_Order,
DENSE_RANK() OVER(partition by Cust_ID ORDER BY Year_order, Month_order) dns_rnk
FROM montly_visits
;

--4. Calculate the monthly time gap between two consecutive visits by each customer.

CREATE VIEW montly_time_gaps AS
WITH T2  AS
(
SELECT distinct Cust_ID, Order_Date,
lead(Order_Date) over (partition by Cust_ID ORDER by Order_Date) next_order
FROM dbo.e_commerce_data 
)
SELECT*, DATEDIFF(MONTH, Order_Date, next_order) as monthly_time_gap
FROM T2


--5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.
---For example:
-- Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
-- Labeled as regular if the customer has made a purchase every month.


select Cust_ID,
case when AVG(monthly_time_gap) is Null then 'Churn' 
     when AVG(monthly_time_gap) <= 3 then 'Regular' 
     ELSE 'Irregular' END Labeling
FROM montly_time_gaps 
GROUP BY Cust_ID


/*
Month-Wise Retention Rate
Find month-by-month customer retention ratei since the start of the business.
There are many different variations in the calculation of Retention Rate. But we will try to calculate the month-wise retention rate in this project.
So, we will be interested in how many of the customers in the previous month could be retained in the next month.
Proceed step by step by creating “views”. You can use the view you got at the end of the Customer Segmentation section as a source.



SELECT distinct YEAR(Order_Date) year, Month(Order_Date) month, COUNT(Cust_ID) OVER(partition by YEAR(Order_Date),MONTH(Order_Date)) retained_month_wise
FROM montly_time_gaps
WHERE monthly_time_gap = 1
ORDER by YEAR(Order_Date), Month(Order_Date)



 WITH CTE as 
(
SELECT top 50 YEAR(Order_Date) year, MONTH(Order_Date) month, Count(Cust_ID) as TotalCustomer,
sum(case when monthly_time_gap = 1 then 1 END) RetainedCustomer
FROM montly_time_gaps
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER by YEAR(Order_Date), MONTH(Order_Date)
)
select*, round(1.0 *(cast(RetainedCustomer as float) / cast(TotalCustomer as float)), 2) MonthWise_RetentionRate
FROM CTE 
WHERE RetainedCustomer is not null
