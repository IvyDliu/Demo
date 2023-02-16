USE AdventureWorks2019
GO
--1.
SELECT COUNT(*) AS TotalNumProduct 
FROM Production.Product
--2.
SELECT Name 
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
--3.
SELECT ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
--4.
SELECT COUNT(*) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
--5.
SELECT SUM(Quantity) AS SumOfQuantity
FROM Production.ProductInventory
--6.
SELECT ProductID, Quantity AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 AND Quantity < 100
--7.
SELECT Shelf, ProductID, Quantity AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 AND Quantity < 100
--8.
SELECT AVG(Quantity) AS AvgQuantity
FROM Production.ProductInventory
WHERE LocationID = 10
--9.
SELECT ProductID, Shelf, AVG(Quantity) AS AvgQuantity
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
--10.
SELECT ProductID, Shelf, AVG(Quantity) AS AvgQuantity
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf
--11.
SELECT Color, Class, Count(ProductID) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class
--12.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode
--13.
SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Canada', 'Germany')
-- Change db
USE Northwind
GO
--14.
SELECT DISTINCT d.ProductID, p.ProductName
FROM [Order Details] d JOIN Orders o
ON d.OrderID = o.OrderID JOIN Products p
ON d.ProductID = p.ProductID
WHERE DATEDIFF(YEAR,o.OrderDate, GETDATE()) <= 25
--15.
SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] d
ON o.OrderID = d.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY SUM(d.Quantity)  DESC
--16.
SELECT TOP 5 o.ShipPostalCode
FROM Orders o JOIN [Order Details] d
ON o.OrderID = d.OrderID
WHERE o.ShipPostalCode IS NOT NULL
AND DATEDIFF(YEAR,o.OrderDate, GETDATE()) <= 25
GROUP BY o.ShipPostalCode
ORDER BY SUM(d.Quantity)  DESC
--17.
SELECT c.City, COUNT(c.CustomerID) AS NumOfCustomers
FROM Customers c
GROUP BY c.City 
--18.
SELECT c.City, COUNT(c.CustomerID) AS NumOfCustomers
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2
--19.
SELECT DISTINCT c.ContactName AS CustomerName
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID 
WHERE o.OrderDate > '1998/1/1'
--20.
SELECT DISTINCT c.ContactName
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (
SELECT TOP 1 o.OrderDate
FROM Orders o
ORDER BY o.OrderDate DESC
)
--21.
SELECT c.ContactName, SUM(d.Quantity) AS NumOfQuantity
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] d ON d.OrderID = o.OrderID
GROUP BY c.ContactName
--22.
SELECT c.CustomerID
FROM Customers c JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] d ON d.OrderID = o.OrderID
GROUP BY c.CustomerID
HAVING SUM(d.Quantity) > 100
--23.
SELECT spl.CompanyName AS [Supplier Company Name], s.CompanyName AS [Shipping Company Name]
from Orders o JOIN Shippers s ON o.ShipVia = s.ShipperID
JOIN [Order Details] d ON o.OrderID = d.OrderID
JOIN Products p ON p.ProductID = d.ProductID
JOIN Suppliers spl ON spl.SupplierID = p.SupplierID
GROUP BY s.CompanyName, spl.CompanyName
ORDER BY spl.CompanyName
--24.
SELECT o.OrderDate, p.ProductName 
FROM Orders o JOIN [Order Details] d ON o.OrderID = d.OrderID
JOIN Products p ON p.ProductID = d.ProductID
ORDER BY o.OrderDate
--25.
SELECT STRING_AGG(e.FirstName + ' ' + e.LastName, ', ') AS EmployeeName, Title
FROM Employees e
GROUP BY Title
--26.
SELECT m.FirstName + ' ' + m.LastName AS ManagerName
FROM Employees m
WHERE m.EmployeeID IN (
SELECT e.ReportsTo
FROM Employees e
GROUP by e.ReportsTo
HAVING COUNT(e.EmployeeID) > 2
)
--27.
SELECT c.City, c.CompanyName AS Name, c.ContactName AS [Contact Name], 'Customers' AS Type
FROM Customers c
UNION
SELECT s.City, s.CompanyName AS Name, s.ContactName AS [Contact Name], 'Suppliers' AS Type
FROM Suppliers s
ORDER BY City