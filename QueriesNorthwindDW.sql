-- q0 Cuantos y cuales anios hay registros de ordenes en NorthwindDW
SELECT YEAR(T.orderDate) 'Year', COUNT(T.OrderID) 'Orders in year'
FROM ( SELECT DISTINCT OrderID, orderDate FROM FactSales ) T
GROUP BY YEAR(T.orderDate)
ORDER BY YEAR(T.orderDate) ASC

-- q1 cual es el producto del que mas unidades se vendieron en 1996
SELECT DP.ProductName
FROM FactSales FS
JOIN DimProduct DP ON FS.ProductID = DP.ProductID
WHERE YEAR(FS.orderDate) = 1996
GROUP BY FS.ProductID, DP.ProductName
HAVING SUM(Quantity) = (
    SELECT MAX(T.TotalUnitsSold) 
    FROM ( SELECT SUM(Quantity) 'TotalUnitsSold'
            FROM FactSales
            WHERE YEAR(orderDate) = 1996
            GROUP BY ProductID ) T
)

-- q2 cual es el total de ventas (dinero) en 1996
SELECT ROUND(SUM(Total),2) 'Sales in 1996'
FROM FactSales
WHERE YEAR(orderDate) = 1996

-- q3 cual es el total de ventas (dinero ) en 1997
SELECT ROUND(SUM(Total),2) 'Sales in 1997'
FROM FactSales
WHERE YEAR(orderDate) = 1997

-- q4 cual es el total de ventas (dinero) considerando todos los anios incluidos en la BD
SELECT ROUND(SUM(Total),2) 'Historic sales'
FROM FactSales

-- -- q5 cual es el producto que genero mas ganancias en 1997 
SELECT DP.ProductName
FROM FactSales FS
JOIN DimProduct DP ON FS.ProductID = DP.ProductID
WHERE YEAR(orderDate) = 1997
GROUP BY FS.ProductID, DP.ProductName
HAVING SUM(FS.Total) = ( 
    SELECT MAX(T.ProductSales)
        FROM (
            SELECT SUM(Total) 'ProductSales'
            FROM FactSales
            WHERE YEAR(orderDate) = 1997
            GROUP BY ProductID
        ) T 
)

-- q6 cual es la region de Estados Unidos que vendio mas productos en 1997 
SELECT DE.Region 'Region in USA with most sales in 1997'
FROM FactSales FS
JOIN DimEmployee DE ON FS.EmployeeID = DE.EmployeeID
WHERE YEAR(FS.orderDate) = 1997 AND DE.Country = 'USA'
GROUP BY DE.Region
HAVING SUM(FS.Quantity) = ( 
    SELECT MAX(T.ProductsSoldByRegion)
        FROM (
            SELECT SUM(Quantity) 'ProductsSoldByRegion'
            FROM FactSales FS
            JOIN DimEmployee DE ON FS.EmployeeID = DE.EmployeeID
            WHERE YEAR(FS.orderDate) = 1997 AND DE.Country = 'USA'
            GROUP BY DE.Region
        ) T
)

-- q7 para la region q6 cual es la ciudad que mas ventas tuvo (dinero) en 1997
SELECT DE.City
FROM FactSales FS
JOIN DimEmployee DE ON FS.EmployeeID = DE.EmployeeID
WHERE YEAR(orderDate) = 1997 AND DE.Region = 'WA'
GROUP BY DE.City
HAVING SUM(FS.Total) = ( 
    SELECT MAX(T.SalesByCityInWA)
        FROM (
            SELECT SUM(Total) 'SalesByCityInWA'
            FROM FactSales FS
            JOIN DimEmployee DE ON FS.EmployeeID = DE.EmployeeID
            WHERE YEAR(FS.orderDate) = 1997 AND DE.Region = 'WA'
            GROUP BY DE.City
        ) T 
)

-- q8 cual es el total de ventas en total (todos  los anios) organizado por  Pais, Region y Cuidad  
SELECT DE.Country, DE.Region, DE.City, SUM(FS.total) 'Sales'
FROM FactSales FS
JOIN DimEmployee DE ON FS.EmployeeID = DE.EmployeeID
GROUP BY  DE.Country, DE.Region, DE.City
ORDER BY 'Sales'