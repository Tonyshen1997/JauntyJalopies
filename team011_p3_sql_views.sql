USE Jaunty_Jalopies;
GO


-- View:Gross_Customer_Income_Report
DROP VIEW IF EXISTS Gross_Customer_Income_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Gross_Customer_Income_Report]
as



WITH tempcte AS(
    SELECT customerID, SUM(sold_price) AS income, MIN(transaction_date) AS  
first_date ,MAX(transaction_date) AS last_date, COUNT(1) ServiceCount, 'Sale' as ServiceType
FROM SalesTransaction s
inner join Vehicle v on s.VIN = v.VIN
GROUP BY customerID 

UNION

 select distinct r.customerID, labor.totallabor+ partcost, MIN(r.start_date), MAX(r.start_date),COUNT(1),'Repair' from RepairDetails r LEFT JOIN
 (select customerID, sum(labor_charge) totallabor from RepairDetails group by customerID) labor
 on labor.customerID = r.customerID
 LEFT join 
 ( select customerID , isnull(sum(quantity*price),0) partcost
from RepairDetails r left join Part p on r.VIN = p.vin and r.start_date = p.start_date

group by customerID) part on part.customerID = r.customerID


group by r.customerID,labor.totallabor+ partcost
 
) 

 SELECT 
 t.customerID,
 CASE when 
  i.driver_license IS NOT NULL THEN  CONCAT(i.first_name, ', ',i.last_name) 
 ELSE bu.business_name END AS Customer_Name,  
 MIN(t.first_date) as First_Service_Date, MAX(t.last_date) as Latest_Service_Date,
 isnull(t1.ServiceCount,0) as NumOfSale,
isnull(t2.ServiceCount,0) as NumOfRepair,
  SUM(t.income) as Total_Income
 from tempcte t 
 left join tempcte t1 on t.customerID = t1.customerID and t1.ServiceType='Sale'
left join tempcte t2 on t.customerID = t2.customerID and t2.ServiceType='Repair' 

 LEFT JOIN  Individual i ON t.customerID = i.customerID 
 LEFT JOIN Business bu ON t.customerID = bu.customerID 

 GROUP BY CASE when i.driver_license IS NOT NULL 
 THEN CONCAT(i.first_name,', ', i.last_name) ELSE bu.business_name END, t.customerID,t1.ServiceCount,t2.ServiceCount 

GO

-- View: Manufacturer_Repair_Report

DROP VIEW IF EXISTS Manufacturer_Repair_Report

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Manufacturer_Repair_Report]
as

WITH VehicleCTE 
AS( 
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date,  'Car' as vehicle_type 
FROM Vehicle v INNER JOIN Car c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Convertible' 
FROM Vehicle v INNER JOIN Convertible c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Truck' 
FROM Vehicle v INNER JOIN Truck t on  v.VIN = t.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Van' 
FROM Vehicle v INNER JOIN Van  on  v.VIN = Van.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'SUV' 
FROM Vehicle v INNER JOIN SUV s  on  v.VIN = s.VIN 
)

SELECT DISTINCT temp1.name as ManufacturerName, temp2.repair_count as RepairCount, temp1.total_parts_cost as TotalPartsCost, temp2.total_labor_cost as TotalLaborCost,   (temp1.total_parts_cost+temp2.total_labor_cost) as TotalRepairCost
FROM(
SELECT M.name,SUM(ISNULL(P.quantity, 0 )*ISNULL(P.price, 0 )) AS total_parts_cost, SUM(ISNULL(R.labor_charge, 0 )) AS total_labor_cost, (SUM(ISNULL(P.quantity, 0 )*ISNULL(P.price, 0 ))+SUM(ISNULL(R.labor_charge, 0 ))) AS total_repair_cost
FROM RepairDetails AS R
INNER JOIN VehicleCTE as V ON V.VIN=R.VIN
LEFT OUTER JOIN Part AS P ON P.VIN=R.VIN AND P.start_date=R.start_date
RIGHT OUTER JOIN Manufacturer AS M ON M.name=V.manufacturer_name
GROUP BY M.name
) AS temp1

LEFT OUTER JOIN
(
SELECT M.name, COUNT(VIN) as repair_count, SUM(ISNULL(temp.labor_charge, 0 )) as total_labor_cost
FROM(
SELECT Distinct V.manufacturer_name, R.VIN, R.start_date, R.labor_charge
FROM RepairDetails AS R
INNER JOIN VehicleCTE as V ON V.VIN=R.VIN
) AS temp
RIGHT OUTER JOIN Manufacturer AS M ON M.name=temp.manufacturer_name
GROUP BY M.name
) AS temp2
ON temp1.name=temp2.name
ORDER BY temp1.name ASC offset 0 rows;

GO

-- View: Sales_By_Color_Report

DROP VIEW IF EXISTS Sales_By_Color_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Sales_By_Color_Report]
as

SELECT thirtydays.color AS color, thirtydays.totalsales as thirtyDaysSales,  lastyear.totalsales as lastYearSales, overall.totalsales as overallSales
FROM ( 
SELECT Color.name as color, ISNULL(temp.sales, 0) AS totalsales 
FROM Color  
LEFT JOIN ( 
SELECT DISTINCT vc.color, COUNT(DISTINCT s.VIN) AS sales 
FROM ( 
SELECT VIN, COUNT(1) count  
FROM  VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE s. transaction_date >= ( 
SELECT dateadd (DAY,-30, MAX(transaction_date) )  
FROM SalesTransaction)  
AND c. count = 1 
GROUP BY vc.color 
) temp ON temp.color = Color.name 
UNION  
SELECT DISTINCT 'Multiple', COUNT(DISTINCT s.VIN) AS sales 
FROM (SELECT VIN, COUNT(1) count FROM VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE s. transaction_date >= (SELECT dateadd(DAY,-30, MAX(transaction_date) ) FROM SalesTransaction) AND c. count > 1 
) thirtydays  
INNER JOIN  
( 
SELECT Color.name as color, ISNULL(temp.sales, 0) AS totalsales 
FROM 
Color LEFT JOIN ( 
SELECT DISTINCT vc.color, COUNT(DISTINCT s.VIN) AS sales 
FROM (SELECT VIN, COUNT(1) count FROM  VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE s. transaction_date >= (SELECT dateadd(YEAR,-1, MAX(transaction_date) )FROM SalesTransaction)  AND c. count = 1 
GROUP BY vc.color 
) temp ON temp.color = Color.name 
UNION  
SELECT DISTINCT 'Multiple', COUNT(DISTINCT s.VIN) AS sales 
FROM (SELECT VIN, COUNT(1) count FROM VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE s. transaction_date >= (SELECT dateadd(YEAR,-1, MAX(transaction_date) ) FROM SalesTransaction)  AND c. count > 1 
) lastyear ON thirtydays.color = lastyear.color 
INNER JOIN  
( 
SELECT Color.name as color, ISNULL(temp.sales, 0) AS totalsales 
FROM  
Color LEFT JOIN ( 
SELECT DISTINCT vc.color, COUNT(DISTINCT s.VIN) as sales 
FROM (SELECT VIN, COUNT(1) count FROM  VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE  c. count = 1 
GROUP BY vc.color 
) temp ON temp.color = Color.name 
UNION  
SELECT DISTINCT 'Multiple' AS multiColor, COUNT(DISTINCT s.VIN) AS sales 
FROM (SELECT VIN, COUNT(1) count FROM  VehicleHasColor GROUP BY VIN) c 
LEFT JOIN VehicleHasColor vc ON vc.VIN = c.VIN 
LEFT JOIN SalesTransaction s ON vc.VIN = s.VIN 
WHERE c. count > 1 
) overall ON thirtydays.color = overall.color;

GO



-- View: Sales_By_Vehicle_Type_Report


DROP VIEW IF EXISTS Sales_By_Vehicle_Type_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Sales_By_Vehicle_Type_Report]
as
with vehicleTypeCTE as (
select 'Van' as vehicle_type 
union 
select 'Car'
union 
select 'SUV'
union 
select 'Truck'
union 
select 'Convertible'

)
  
SELECT thirtydays.vehicle_type as vehicleType, thirtydays.totalsales AS thirtyDaysSales,  
lastyear.totalsales AS lastYearSales, overall.totalsales AS overallSales
FROM ( 
SELECT all_vehicle_types.vehicle_type, ISNULL(temp.sales, 0) AS totalsales 
FROM (SELECT DISTINCT vehicleTypeCTE.vehicle_type FROM vehicleTypeCTE) as all_vehicle_types 
LEFT JOIN ( 
SELECT DISTINCT v.vehicle_type, COUNT(DISTINCT s.VIN) AS sales 
FROM  Vehicle_details v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
WHERE s. transaction_date >= ( 
SELECT DATEADD(DAY,-30, MAX(transaction_date) )  
FROM SalesTransaction)  
GROUP BY v.vehicle_type 
) temp ON temp.vehicle_type = all_vehicle_types.vehicle_type 
 
) thirtydays  
INNER JOIN  
( 
SELECT all_vehicle_types.vehicle_type, ISNULL(temp.sales, 0) AS totalsales 
FROM (SELECT DISTINCT vehicleTypeCTE.vehicle_type FROM vehicleTypeCTE) as all_vehicle_types 
LEFT JOIN ( 
SELECT DISTINCT v.vehicle_type, COUNT(DISTINCT s.VIN) AS sales 
FROM  Vehicle_details v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
WHERE s. transaction_date >= (SELECT DATEADD(YEAR,-1, MAX(transaction_date) )FROM SalesTransaction)  
GROUP BY v.vehicle_type 
) temp ON temp.vehicle_type = all_vehicle_types.vehicle_type 
) lastyear ON thirtydays.vehicle_type = lastyear.vehicle_type 
INNER JOIN  
( 
SELECT all_vehicle_types.vehicle_type, ISNULL(temp.sales, 0) AS totalsales 
FROM (SELECT DISTINCT vehicleTypeCTE.vehicle_type FROM vehicleTypeCTE) as all_vehicle_types 
LEFT JOIN ( 
SELECT DISTINCT v.vehicle_type, COUNT(DISTINCT s.VIN) AS sales 
FROM  Vehicle_details v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
GROUP BY v.vehicle_type 
) temp ON temp.vehicle_type = all_vehicle_types.vehicle_type 
) overall ON thirtydays.vehicle_type = overall.vehicle_type;

GO


--View: Sales_By_Manufacturer_Report


DROP VIEW IF EXISTS Sales_By_Manufacturer_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Sales_By_Manufacturer_Report]
as

WITH VehicleCTE 
AS( 
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date,  'Car' as vehicle_type 
FROM Vehicle v INNER JOIN Car c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Convertible' 
FROM Vehicle v INNER JOIN Convertible c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Truck' 
FROM Vehicle v INNER JOIN Truck t on  v.VIN = t.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Van' 
FROM Vehicle v INNER JOIN Van  on  v.VIN = Van.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'SUV' 
FROM Vehicle v INNER JOIN SUV s  on  v.VIN = s.VIN 
)

SELECT overall.manufacturer_name AS manufacturer, ISNULL(thirtydays.sales, 0 )  AS thirtyDaysSales,  ISNULL(lastyear.sales, 0 )  AS lastYearSales, ISNULL(overall.sales, 0 )  AS overallSales
FROM ( 
SELECT DISTINCT v. manufacturer_name, COUNT(DISTINCT s.VIN) AS sales 
FROM  VehicleCTE v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
WHERE s. transaction_date >= ( 
SELECT DATEADD(DAY,-30, MAX(transaction_date) )  
FROM SalesTransaction)  
GROUP BY v.manufacturer_name 
) thirtydays  
RIGHT OUTER JOIN  
( 
SELECT DISTINCT v. manufacturer_name, COUNT(DISTINCT s.VIN) AS sales 
FROM  VehicleCTE v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
WHERE s. transaction_date >= (SELECT DATEADD(YEAR,-1, MAX(transaction_date) )FROM SalesTransaction) 
GROUP BY v.manufacturer_name 
) lastyear ON thirtydays.manufacturer_name = lastyear.manufacturer_name 
RIGHT OUTER JOIN  
( 
SELECT DISTINCT v. manufacturer_name, COUNT(DISTINCT s.VIN) AS sales 
FROM  VehicleCTE v 
INNER JOIN SalesTransaction s ON v.VIN = s.VIN 
GROUP BY v.manufacturer_name 
) overall ON thirtydays.manufacturer_name = overall.manufacturer_name;

GO




--View: Parts_Statics_Report


DROP VIEW IF EXISTS Parts_Statics_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Parts_Statics_Report]
as
SELECT vendor, SUM(quantity) AS totalpartssupplied, SUM(quantity*price) AS totalspent
FROM Part
GROUP BY vendor;
GO

--View:Monthly_Sales_Part1


DROP VIEW IF EXISTS Monthly_Sales_Part1
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Monthly_Sales_Part1]
as

SELECT YEAR(transaction_date) AS Year , MONTH(transaction_date) AS Month, COUNT(t.VIN) as totalVehicleSold ,
SUM(sold_price - invoice_price) as totalNetIncome, SUM(sold_price ) as SalesIncome, SUM(sold_price)/SUM(invoice_price)*100 as Ratio

from SalesTransaction t inner join Vehicle v on t.VIN = v.VIN

group By Year(transaction_date), Month(transaction_date)

order by Year(transaction_date) desc , Month(transaction_date) desc offset 0 rows;

GO


--View: Vehicle_Details

DROP VIEW IF EXISTS Vehicle_Details
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view  [dbo].[Vehicle_Details]
as
With VehicleCTE
as(
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date,  'Car' as vehicle_type 
FROM Vehicle v INNER JOIN Car c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Convertible' 
FROM Vehicle v INNER JOIN Convertible c on  v.VIN = c.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Truck' 
FROM Vehicle v INNER JOIN Truck t on  v.VIN = t.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Van' 
FROM Vehicle v INNER JOIN Van  on  v.VIN = Van.VIN 
UNION  
SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'SUV' 
FROM Vehicle v INNER JOIN SUV s  on  v.VIN = s.VIN )
select  cte.*,cte.invoice_price * 1.25 as list_price, case when t.transaction_date is not null then 1 else  0 end as isSold,
STRING_AGG(c.color, ',') color from VehicleCTE cte
left join [dbo].[VehicleHasColor] c on cte.VIN = c.VIN
left join [dbo].[SalesTransaction] t on cte.VIN = t.VIN
group BY cte.VIN, cte.[description], cte.model_name, cte.model_year,cte.invoice_price, cte.invoice_price * 1.25,
cte.manufacturer_name,cte.add_date, cte.vehicle_type, cte.inv_writer_user_name,
case when t.transaction_date is not null then 1 else  0 end
GO

--View: Below_Cost_Sales_Report

DROP VIEW IF EXISTS Below_Cost_Sales_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Below_Cost_Sales_Report]
as
WITH VehicleCTE

AS(

SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Car' as vehicle_type

FROM Vehicle v INNER JOIN Car c on v.VIN = c.VIN

UNION

SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Convertible'

FROM Vehicle v INNER JOIN Convertible c on v.VIN = c.VIN

UNION

SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Truck'

FROM Vehicle v INNER JOIN Truck t on v.VIN = t.VIN

UNION

SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'Van'

FROM Vehicle v INNER JOIN Van on v.VIN = Van.VIN

UNION

SELECT v.VIN, description, model_year, model_name, invoice_price,manufacturer_name , inv_writer_user_name, add_date, 'SUV'

FROM Vehicle v INNER JOIN SUV s on v.VIN = s.VIN

)

SELECT (COALESCE(B.business_name, '') + COALESCE(I.first_name, '') + SPACE(1) + COALESCE(I.last_name, '')) AS customer_name, S.transaction_date, S.VIN, S.sold_price, (S.sold_price/V.invoice_price*100) AS ratio, V.model_year, V.manufacturer_name, V.model_name, V.invoice_price, U.first_name, U.last_name

FROM
(Customer LEFT OUTER JOIN Individual AS I ON Customer.customerID=I.customerID

LEFT OUTER JOIN Business AS B ON Customer.customerID=B.customerID)

INNER JOIN SalesTransaction AS S ON Customer.customerID=S.customerID

INNER JOIN VehicleCTE AS V ON S.VIN=V.VIN

INNER JOIN Users AS U ON U.user_name=S.sales_writer_user_name

WHERE(S.sold_price<V.invoice_price)

ORDER BY S.transaction_date DESC, (S.sold_price/V.invoice_price*100) DESC offset 0 rows;;

GO


--View: Average_Time_Inventory_Report

DROP VIEW IF EXISTS Average_Time_Inventory_Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Average_Time_Inventory_Report]
as
  SELECT v.vehicle_type, round(SUM(DATEDIFF(DAY,v.add_date, t.transaction_date) + 1)/ cast(COUNT(v.VIN) as float) ,1) AS avg_day_in_inventory
    FROM Vehicle_Details v inner JOIN SalesTransaction t ON v.vin = t.vin
    GROUP BY v.vehicle_type;


GO


--View:Customer_Details

DROP VIEW IF EXISTS Customer_Details
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Customer_Details] 
as 
select c.customerID, c.email, c.phone_number, c.street_Address, 
c.city, c.[state], c.postal_code, i.driver_license as DL_Tax_ID, CONCAT( i.first_name,', ',i.last_name) CustomerName, CONCAT( i.first_name,', ',i.last_name) as contactName,  'Individual' as CustomerType
from [dbo].[Customer] c
Inner join [dbo].[Individual] i on c.customerID =  i.customerID
Union 
select c.customerID, c.email, c.phone_number,  c.street_Address, 
c.city, c.[state], c.postal_code,b.tax_ID,b.business_name, b.contact_name, 'Business'
from Customer c 
  

inner join  [dbo].[Business] b on c.customerID = b.customerID
GO
