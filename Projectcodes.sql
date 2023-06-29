#Creating schema 
CREATE SCHEMA IF NOT EXISTS Profit_loss_abc;
USE Profit_loss_abc;

#Creating table
CREATE TABLE dataset 
(
Company varchar(20),
Location varchar(20),
State varchar(20),
Month varchar(10),
Quarter varchar (10),
PL_Head varchar(10),
Category varchar(20),
Budget INT,
Actual INT, 
Salesperson varchar(20)
)

#Imported the datafile and now looking at the imported data
SELECT 
*
FROM 
dataset;

#Question1: What is the Total Sales for all the companies
SELECT
DISTINCT Company,
SUM(Actual)
From dataset
WHERE 	PL_Head = 'Sales'
GROUP BY Company
;

#Question2: What is the budgeted and actual sales for all the products?
SELECT
DISTINCT Category,
SUM(Budget),
SUM(Actual)
From dataset
WHERE 	PL_Head = 'Sales'
GROUP BY Category
;

#Question3: What is the budgeted and actual Profit for all the products?
SELECT
DISTINCT Category,
SUM(Budget),
SUM(Actual)
From dataset
WHERE 	PL_Head = 'Profit'
GROUP BY Category
;

#Question4: What is the total Cost, Sales, Profit of all the companies?
With cost as 
(
SELECT
	Company,
    SUM(Actual) as Cost
FROM dataset
WHERE 	PL_Head = 'Cost'
GROUP BY Company
),
Profit as 
(
SELECT
	Company,
    SUM(Actual) as Profit
FROM dataset
WHERE 	PL_Head = 'Profit'
GROUP BY Company
),
Sales as 
(
SELECT
	Company,
    SUM(Actual) as Sales
FROM dataset
WHERE 	PL_Head = 'Sales'
GROUP BY Company
)

SELECT
	DISTINCT d.Company, 
    c.Cost,
    s.Sales,
    p.Profit
FROM
	dataset d
JOIN cost c ON c.Company = d.Company
JOIN Sales s ON s.Company = d.Company
JOIN Profit p ON p.Company = d.Company
ORDER BY p.Profit DESC;

#Question5: What is the Sales achieved by each Salesperson?
SELECT 
	Salesperson, 
	SUM(Actual) AS Total_Sales, 
    ROUND(SUM(Actual) * 100.0 / (SELECT SUM(Actual) FROM dataset WHERE PL_Head LIKE 'Sales') , 2) AS Percentage
FROM dataset
WHERE PL_Head LIKE 'Sales'
GROUP BY Salesperson;

#Question6: Which Product earns the highest Profit?
SELECT
	Category, 
    SUM(Actual)
FROM 	dataset
WHERE PL_HEAD LIKE 'Profit'
GROUP BY Category;

#Question7: What is the Statewise Sales? Which Sales has the highest sales and which has the lowest sales?
SELECT
	State,
    SUM(Actual)
FROM 
	dataset
WHERE PL_Head LIKE 'Sales'
GROUP BY State
ORDER BY SUM(Actual) DESC;

#Question8: What is the Total sales Location-wise? Which Location has the highest and which has the lowest sales?
SELECT 
	Location,
    SUM(Actual)
FROM dataset
WHERE PL_Head LIKE 'Sales'
GROUP BY Location
ORDER BY SUM(Actual) DESC;
    
#Question9: What is the budgeted and actual sales Quarter-wise? What is the Variance?
SELECT 
	Quarter,
    SUM(Budget),
    SUM(Actual), 
    SUM(Actual) - SUM(Budget) as Variance
FROM dataset
WHERE PL_Head LIKE 'Sales'
GROUP BY Quarter
ORDER BY Quarter;

