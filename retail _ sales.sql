CREATE DATABASE RETAIL_SALES 

USE RETAIL_SALES 

CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender CHAR(1),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    JoinDate DATE
);

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(10),
    EmployeeID VARCHAR(10),
    ProductID VARCHAR(10),
    Quantity INT,

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
INSERT INTO Customers
(CustomerID, CustomerName, Gender, Age, City, State, JoinDate)
VALUES
('C001','John Smith','M',32,'New York','NY','2021-03-12'),
('C002','Sarah Lee','F',29,'Chicago','IL','2022-01-20'),
('C003','Michael Brown','M',41,'Dallas','TX','2020-08-13'),
('C004','Emma Davis','F',36,'Miami','FL','2021-11-03'),
('C005','David Wilson','M',45,'Seattle','WA','2019-06-22'),
('C006','Jessica Moore','F',27,'Boston','MA','2023-02-15'),
('C007','James Taylor','M',39,'Denver','CO','2021-07-30'),
('C008','Olivia Martin','F',31,'Atlanta','GA','2022-09-18'),
('C009','Daniel Anderson','M',42,'Phoenix','AZ','2020-04-25'),
('C010','Sophia Thomas','F',25,'San Diego','CA','2023-01-10');


INSERT INTO Products
(ProductID, ProductName, Category, UnitPrice)
VALUES
('P001','Laptop','Electronics',1200),
('P002','Headphones','Electronics',150),
('P003','Office Chair','Furniture',250),
('P004','Desk','Furniture',300),
('P005','Monitor','Electronics',350),
('P006','Keyboard','Electronics',50),
('P007','Mouse','Electronics',30),
('P008','Tablet','Electronics',600),
('P009','Printer','Office Supplies',200),
('P010','Notebook','Office Supplies',10);

INSERT INTO Employees
(EmployeeID, EmployeeName, Department, Region)
VALUES
('E001','Robert King','Sales','North'),
('E002','Linda Scott','Sales','South'),
('E003','Mark White','Sales','East'),
('E004','Nancy Green','Sales','West'),
('E005','Chris Hall','Sales','Central');

INSERT INTO Orders
(OrderID, OrderDate, CustomerID, EmployeeID, ProductID, Quantity)
VALUES
('O1001','2024-01-05','C001','E001','P001',1),
('O1002','2024-01-06','C002','E002','P002',2),
('O1003','2024-01-08','C003','E003','P003',1),
('O1004','2024-01-10','C004','E004','P004',1),
('O1005','2024-01-12','C005','E005','P005',2),
('O1006','2024-01-15','C001','E001','P006',3),
('O1007','2024-01-16','C006','E002','P007',4),
('O1008','2024-01-18','C007','E003','P008',1),
('O1009','2024-01-20','C008','E004','P009',2),
('O1010','2024-01-22','C009','E005','P010',10),
('O1011','2024-02-05','C010','E001','P001',1),
('O1012','2024-02-08','C002','E002','P005',1),
('O1013','2024-02-10','C003','E003','P008',2),
('O1014','2024-02-15','C004','E004','P002',3),
('O1015','2024-02-18','C005','E005','P006',5);


SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Orders;

-- task 1 total sales  -- 
select 
sum( o.quantity * p.unitprice) as total_price 
from Orders o 
join Products p 
on o.ProductID = p.ProductID;

--- task 2  selling products. --
select 
p.productName,
sum(o.quantity) as totalQTY 
from orders o 
join products p 
on  o.productid = P.productid     
group by  p. productname 
order by  totalQTY DESC 

-- task 3  Customer with highest purchases. ---- 
select c.customername, 
sum(o.Quantity * p.unitprice) as revenue 
from Orders o 
join Customers c 
on  o.customerid = c.customerid
join Products p
on o.ProductID = p.ProductID
group by  c.CustomerName
order by revenue desc 

--- task 4 Monthly Revenue Trend---
select 
MONTH(ORDERDATE) MONTH_NO,
SUM ( O.QUANTITY * P.UNITPRICE) REVENUE 
FROM ORDERS O 
JOIN PRODUCTS P 
ON O.PRODUCTID = P.PRODUCTID 
GROUP BY  MONTH (ORDERDATE);

-- TASK - 5 Sales by Region -- 
SELECT 
e.REGION,
sum( o.Quantity * p.unitprice) revenue 
from Orders o
join Employees e 
on o. EmployeeID = e.EmployeeID
join Products p 
on p.ProductID= o.ProductID 
group by  e.Region

-- task - 6 category wise - revenue -- 

select 
p.category,
sum( o.quantity * p.UnitPrice) revenue 
from orders o 
join Products p 
on o.ProductID = p.ProductID 
group by  p.Category;

--- task 7 average order  value --  

select 
AVG( order_revenue  ) AVG_order_value
from (
select
orderID,
sum( o.quantity * p.unitprice) order_revenue 
from Orders o
join Products p 
on o.ProductID=p.ProductID
group by orderID )x;

-- task - 8 customer segment -- 
select 
customerID,
sum (o.quantity * p.UnitPrice) total_spend, 
case 
when sum( o.quantity * p.unitprice) >  3000 then 'premium'
when sum( o.quantity * p.unitprice) > 1000 then 'gold'
else 'regular'
end as  segment 
from Orders o 
join Products p 
on o.ProductID=p.ProductID
group by CustomerID;

--- task - 9 rank product by region -- 
select 
productname,
revenue,
DENSE_RANK() over( order by revenue desc )  rank_no 
from(
select  
p.productname,
sum ( o.quantity * p.unitprice )  revenue 
from Orders o 
join Products p 
on o. ProductID=p. ProductID
group by p.ProductName)x;

-- task  10 -- runnine sales ----
select 
orderdate,
sum(sales) over (order by  orderdate) 
Running_sales 
from
(
select 
orderdate,
sum (o.quantity * p.unitprice ) sales 
from orders o
join products p 
on o.productid= p.ProductID
group by orderdate)x;


----------------------

SELECT @@SERVERNAME AS ServerName;



