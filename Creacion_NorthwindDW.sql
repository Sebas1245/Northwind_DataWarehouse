/*Creacion de Northwind DW */
USE MASTER
CREATE DATABASE NorthwindDW
GO

/* Northwind Data Warehouse ya debe estar creada */

USE NorthwindDW
GO

/* Creacion de dimensiones. */
CREATE TABLE DimProduct (
ProductID    INT,
ProductName  VARCHAR (40),
categoryName VARCHAR (15),
SupplierName VARCHAR(40),
SuppplierAddress VARCHAR(100),
City VARCHAR(40),
Region VARCHAR(40),
PostalCode VARCHAR(10),
Country VARCHAR(30),
PRIMARY KEY (productID))

CREATE TABLE DimTime (
 OrderDATE DATE,
 PRIMARY KEY (OrderDATE)
 )

CREATE TABLE DimEmployee (
	EmployeeID INT, 
	EmployeeName VARCHAR(50),
	City VARCHAR(40),
	Country VARCHAR(30),
	Region VARCHAR(40),
	hireDATE DATE,
	PRIMARY KEY (EmployeeID)
)

CREATE TABLE DimCustomer (
	CustomerID char(5), 
	CustomerName VARCHAR(50),
	City VARCHAR(30),
	Country VARCHAR(30),
	Region VARCHAR(40),
	PRIMARY KEY(CustomerID)
)

--tabla de Hechos FACT SALES puede ser necesario agregar-quitar columnas
-- OrderId  es llamda dimension degenerada pero es necesario solo para efectos de la carga de los datos
CREATE TABLE FactSales (
ProductID       INT,
EmployeeID      INT,
CustomerID      char(5),
orderDATE       DATE,
OrderID         INT,                               
Quantity        SMALLINT,
unitPrice       MONEY,
discountPercent REAL,
discountAmount  MONEY,
total           MONEY, 
PRIMARY KEY (ProductID, EmployeeID, CustomerID, orderDATE),
FOREIGN KEY (ProductID)  REFERENCES dbo.DimProduct(productID),
FOREIGN KEY (EmployeeID) REFERENCES dbo.DimEmployee(employeeID),
FOREIGN KEY (CustomerID) REFERENCES dbo.DimCustomer(CustomerID),
FOREIGN KEY (orderDATE)  REFERENCES dbo.DimTime(orderDATE)
)
