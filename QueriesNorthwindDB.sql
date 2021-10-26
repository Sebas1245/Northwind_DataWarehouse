-- q0 Cuantos y cuales anios hay registros de ordenes en NorthwindDB
SELECT YEAR(O.OrderDate) 'Year', COUNT(*) 'OrdersInYear' 
FROM Orders AS O
GROUP BY YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate) ASC

-- q1 cual es el producto del que mas unidades se vendieron en 1996

SELECT TOP 1 P.ProductNameFROM Products AS PJOIN [Order Details] AS OD ON P.ProductID = OD.ProductIDJOIN Orders AS O ON OD.OrderID = O.OrderIDWHERE YEAR(O.OrderDate) = 1996GROUP BY P.ProductNameORDER BY SUM(OD.Quantity) DESC

-- q2 cual es el total de ventas (dinero) en 1996
SELECT ROUND(SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)),2)'Venta en el 96' 
FROM [Order Details] AS OD
JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1996

-- q3 cual es el total de ventas (dinero ) en 1997
SELECT ROUND(SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)),2)'Venta en el 97' 
FROM [Order Details] AS OD
JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997

-- q4 cual es el total de ventas (dinero) considerando todos los anios incluidos en la BD
SELECT ROUND(SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)),2)'Venta Historica' 
FROM [Order Details] AS OD

-- q5 cual es el producto que genero mas ganancias en 1997 
SELECT ROUND(SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)),2)'Venta en el 97' 
FROM [Order Details] AS OD
JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997

-- q6 cual es la region de Estados Unidos que vendio mas  productos en 1997 
SELECT C.Region
FROM Customers AS C 
JOIN ORDERS AS O ON C.CustomerID = O.CustomerID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE C.Country = 'USA' AND YEAR(O.OrderDate) = 1997
GROUP BY C.Region
HAVING SUM(OD.Quantity) =  (
							SELECT MAX(T.Suma) FROM (
													SELECT SUM(OD.Quantity) 'Suma'
													FROM Customers AS C 
													JOIN ORDERS AS O ON C.CustomerID = O.CustomerID
													JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
													WHERE C.Country = 'USA' AND YEAR(O.OrderDate) = 1997
													GROUP BY C.Region) AS T 
							)

SELECT O.ShipRegion
FROM Customers AS C 
JOIN ORDERS AS O ON C.CustomerID = O.CustomerID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE O.ShipCountry = 'USA' AND YEAR(O.OrderDate) = 1997
GROUP BY O.ShipRegion
HAVING SUM(OD.Quantity) =  (
							SELECT MAX(T.Suma) FROM (
													SELECT SUM(OD.Quantity) 'Suma'
													FROM Customers AS C 
													JOIN ORDERS AS O ON C.CustomerID = O.CustomerID
													JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
													WHERE O.ShipCountry = 'USA' AND YEAR(O.OrderDate) = 1997
													GROUP BY O.ShipRegion) AS T 
							)

-- q7 para la region q6 cual es el estado o que mas ventas tuvo (dinero) en  1997



-- q8 cual es el total de ventas en total (todos  los anios) organizado por  Region, Pais, Estado y Cuidad  
SELECT C.Country 'Pais',C.Region 'Region' , C.City 'Ciudad', ROUND(SUM((OD.UnitPrice * OD.Quantity)*(1-OD.Discount)),2)'Venta Historica' 
FROM [Order Details] AS OD
JOIN Orders AS O ON OD.OrderID = O.OrderID
JOIN Customers AS C ON C.CustomerID = O.CustomerID
GROUP BY C.Region, C.Country, C.City
ORDER BY C.Country