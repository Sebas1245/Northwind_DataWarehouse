
/* Northwind Data Warehouse ya debe estar creada */

use NorthwindDW
go

/* Creacion de una dimension. Agregue los campos que hagan falta de acuerdo a lo que indicamos en clase.*/
create table DimProduct (
ProductID    int,
ProductName  varchar (40),
categoryName varchar (15),
SupplierName varchar(40),
SuppplierAddress varchar(100),
City varchar(40),
Region varchar(40),
PostalCode varchar(10),
Country varchar(30),
primary key (productID))

create table DimTime (
 OrderDate date,
 primary key (OrderDate)
 )


/*FALATAN LAS OTRAS Dimensiones: Clientes, Empleados  */
create table DimEmployee (
	EmployeeID int, 
	EmployeeName varchar(50),
	City varchar(40),
	Country varchar(30),
	Region varchar(40),
	hiredate date,
	primary key (EmployeeID)
)

create table DimCustomer (
	CustomerID char(5), 
	CustomerName varchar(50),
	City varchar(30),
	Country varchar(30),
	Region varchar(40),
	primary key(CustomerID)
)

--tabla de Hechos FACT SALES puede ser necesario agregar-quitar columnas
-- OrderId  es llamda dimension degenerada pero es necesario solo para efectos de la carga de los datos
create table FactSales (
ProductID       int,
EmployeeID      int,
CustomerID      char(5),
orderDate       date,
OrderID         int,                               
Quantity        smallint,
unitPrice       money,
discountPercent real,
discountAmount  money,
total           money, 
primary key (ProductID, EmployeeID, CustomerID, orderDate),
foreign key (ProductID)  references dbo.DimProduct(productID),
foreign key (EmployeeID) references dbo.DimEmployee(employeeID),
foreign key (CustomerID) references dbo.DimCustomer(CustomerID),
foreign key (orderDate)  references dbo.DimTime(orderDate)
)
