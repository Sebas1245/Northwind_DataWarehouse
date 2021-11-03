--poblar tablas de modelo multidimensional (NorthWindDW) a partir de base de datos operacional (Northwind)*/

--dimension producto
INSERT INTO DimProduct
   SELECT P.ProductID, P.ProductName, C.CategoryName AS 'categoryName', S.CompanyName AS 'SupplierName', S.Address, S.City, S.Region, S.PostalCode, S.Country
   FROM NorthwindDB.dbo.Products AS P
   JOIN NorthwindDB.dbo.Categories AS C ON P.CategoryID = C.CategoryID
   JOIN NorthwindDB.dbo.Suppliers AS S ON P.SupplierID = S.SupplierID

-- limpieza de las regiones
UPDATE DimProduct SET Region='Europe' 
WHERE Country = 'UK' OR Country = 'Denmark' OR Country = 'Finland' OR Country = 'France' OR Country = 'Germany' OR Country = 'Italy' OR Country = 'Netherlands' OR Country = 'Norway' OR Country = 'Sweden'

UPDATE DimProduct SET Region='South America'
WHERE Country='Brazil'

UPDATE DimProduct SET Region='Asia'
WHERE Country='Japan' OR Country='Singapore'

-- dimension Empleado
INSERT INTO DimEmployee
   SELECT E.EmployeeID, E.FirstName + ' ' + E.LastName AS Name, E.City, E.Country, E.Region,E.HireDate
   FROM NorthwindDB.dbo.Employees E;

-- limpieza de las regiones
UPDATE DimEmployee SET Region='Europe' 
WHERE Country = 'UK'

--falta poblar customer y DimTime. DimTime es solo el orderdate que tomamos de orders 
-- dimension Customer
INSERT INTO DimCustomer
   SELECT C.CustomerID, C.CompanyName 'CustomerName', C.City, C.Country, C.Region
   FROM NorthwindDB.dbo.Customers C

-- limpieza de las regiones
UPDATE DimCustomer SET Region='Europe' 
WHERE (Country = 'UK' AND Region IS NULL) OR Country='Austria' OR Country='Belgium' OR Country='Denmark' OR Country='Finland' OR Country='France' OR Country='Germany' OR Country='Italy' OR Country='Norway' OR Country='Poland' OR Country='Portugal' OR Country='Spain' OR Country='Switzerland'

UPDATE DimCustomer SET Region='South America'
WHERE Country='Argentina'

UPDATE DimCustomer SET Region='North America'
WHERE Country='Mexico' 


/* Falta DimTime y FactSales */
-- dimension Time
INSERT INTO DimTime
   SELECT DISTINCT O.OrderDate
   FROM NorthwindDB.dbo.Orders O


--  tablas de hechos
INSERT INTO FactSales
SELECT OD.ProductID, O.EmployeeID, O.CustomerID, O.OrderDate , 
O.orderID, OD.quantity, OD.unitPrice, 
OD.discount, 
OD.unitPrice * OD.quantity * OD.discount , 
OD.unitPrice * OD.quantity - OD.unitPrice * OD.quantity * OD.discount   
FROM NorthwindDB.dbo.Orders O, NorthwindDB.dbo.[Order Details] OD 
WHERE O.OrderID = OD.OrderID;

