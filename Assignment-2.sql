1. Product Sales

	SELECT DISTINCT
    c.customer_id, 
    c.first_name, 
    c.last_name,
    CASE
        WHEN (
            SELECT COUNT(DISTINCT product_id)
            FROM sale.order_item oi, sale.orders o
            WHERE oi.order_id = o.order_id AND product_id IN (
                SELECT p.product_id 
                FROM product.product p
                WHERE p.product_name IN ('Polk Audio - 50 W Woofer - Black', '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')
            )
            AND o.customer_id = c.customer_id
        ) = 2 THEN 'YES'
        ELSE 'NO'
    END AS Other_product
FROM sale.orders o, sale.customer c, sale.order_item oi,  product.product p
WHERE o.customer_id = c.customer_id AND o.order_id = oi.order_id AND oi.product_id = p.product_id
AND p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
ORDER BY c.customer_id;


2.Product Sales 

WITH T1 AS (
		SELECT Adv_Type, COUNT(*) Total_action,
				COUNT(CASE WHEN Action1= 'Order' THEN 1 ELSE 0 END) Order_action
		FROM ecommerce
		GROUP BY
				Adv_Type

SELECT Adv_Type, 1.0*Order_action/Total_action AS Conversion_Rate
FROM  T1
