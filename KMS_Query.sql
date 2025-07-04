USE [ Kultra Mega Stores]

SELECT * FROM KMS_sales

-- cleaning round to two decimal place
UPDATE KMS_sales
SET Sales = ROUND(Sales, 2);



-- Case Scenario I 
-- 1. Which product category had the highest sales? 

SELECT Product_Category AS CATEGORY, COUNT(*) AS Count
FROM KMS_sales
GROUP BY Product_Category

-- 2. What are the Top 3 and Bottom 3 regions in terms of sales?

		--- Top 3
SELECT TOP 3 Region, 
SUM(Sales) AS Total_Sales
FROM KMS_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

		
		
		--- Bottom 3


SELECT Top 3 Region, 
SUM(Sales) AS Total_Sales
FROM KMS_sales
GROUP BY Region
ORDER BY Total_Sales ASC;



-- 3. What were the total sales of appliances in Ontario? 
SELECT SUM(Sales) AS Total_Sales, province
FROM  KMS_sales
WHERE  Product_Sub_Category = 'Appliances' AND
		Province = 'Ontario'
Group by Province


--4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers

SELECT  SUM(Sales) AS Total_Sales, Customer_Name
FROM  KMS_sales
Group by Customer_Name
Order by Total_Sales Asc



--5. KMS incurred the most shipping cost using which shipping method?

select count(Ship_Mode) as Shipping_Mode, ship_mode
from KMS_sales
group by ship_mode
order by Shipping_Mode DESC


--Case Scenario II 
--6. Who are the most valuable customers, and what products or services do they typically purchase? 


-- Top 10 Most Valuable Customers and Their Most Purchased Product Categories


SELECT TOP 10 SUM(Sales) AS Total_Sales, Customer_Name
FROM KMS_sales
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


		---  Their Most Purchased Product Categories

WITH CustomerCategorySales AS (
    SELECT 
        Customer_Name,
        Product_Category,
        SUM(Sales) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY Customer_Name ORDER BY SUM(Sales) DESC) AS rn
    FROM KMS_sales
    GROUP BY Customer_Name, Product_Category
)
SELECT TOP 10
    Customer_Name,
    Total_Sales,
    Product_Category AS Most_Purchased_Category
FROM CustomerCategorySales
WHERE rn = 1
ORDER BY Total_Sales DESC;



-- 7. Which small business customer had the highest sales?

select sum(Sales) as Total, Customer_Name, Customer_Segment
from KMS_Sales
where Customer_Segment = 'Small Business'
group by Customer_Name, Customer_Segment
order by Total desc 




-- 8. Which Corporate Customer placed the most number of orders in 2009 – 2012?

select customer_name, Customer_Segment, count(Order_ID) as Total_Order 
from KMS_Sales
where Customer_Segment = 'Corporate' and YEAR(Order_Date) between 2009 and 2012
group by customer_name, Customer_Segment
order by Total_Order  desc


-- 9. Which consumer customer was the most profitable one?

Select Customer_Name, sum(profit) as total_profit
from KMS_sales
where Customer_Segment = 'consumer'
group by Customer_Name
order by total_profit desc


-- 10. Which customer returned items, and what segment do they belong to? 


SELECT Customer_Name, Customer_Segment
FROM  KMS_Sales
WHERE Return_Status = 'Returned';

--Based on the analysis of the available data in the KMS_Sales table,
--there is no record indicating any product returns during the evaluated period. 
--This suggests that either no returns occurred, or return-related transactions 
--were not captured or stored in the current dataset.


--11. If the delivery truck is the most economical but the slowest shipping method and 
--Express Air is the fastest but the most expensive one, do you think the company 
--appropriately spent shipping costs based on the Order Priority? Explain your answer 




-- total numbers of order that falls in each shipping mode and there order of priority

SELECT Order_Priority, Ship_Mode, COUNT(Order_ID) AS Num_Orders
FROM KMS_Sales
GROUP BY  Order_Priority, Ship_Mode
ORDER BY Order_Priority desc



SELECT 
    Order_Priority,
    Ship_Mode,
    COUNT(Order_ID) AS Num_Orders,
    CONCAT(
        CAST(CAST(COUNT(Order_ID) * 100.0 / SUM(COUNT(Order_ID)) OVER (PARTITION BY Order_Priority) AS DECIMAL(5,2)) AS VARCHAR(10)),
        '%'
    ) AS Percentage_Within_Priority
FROM 
    KMS_Sales
GROUP BY 
    Order_Priority, Ship_Mode
ORDER BY 
    Order_Priority, Ship_Mode;




SELECT Order_Priority, Ship_Mode,
    COUNT(Order_ID) AS Num_Orders,
    SUM(Shipping_Cost) AS Total_Shipping_Cost,
    CONCAT(CAST(CAST(COUNT(Order_ID) * 100.0 / SUM(COUNT(Order_ID)) OVER (PARTITION BY Order_Priority) AS DECIMAL(5,2)) AS VARCHAR(10)),'%')
	AS Percentage_Within_Priority
FROM  KMS_Sales
GROUP BY  Order_Priority, Ship_Mode
ORDER BY  Order_Priority, Ship_Mode, Total_Shipping_Cost desc ;





Select * from KMS_sales