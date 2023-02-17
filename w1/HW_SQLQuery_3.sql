--1.
SELECT DISTINCT C.City
FROM Customers C INNER JOIN Employees E
ON C.City = E.City
--2a. With sub-query
SELECT DISTINCT C.City
FROM Customers C
WHERE C.City NOT IN (
    SELECT DISTINCT E.City
    FROM Employees E
)
--2b. Without Sub-query
SELECT DISTINCT C.City
FROM Customers C LEFT JOIN Employees E 
ON C.City = E.City
WHERE E.City IS NULL
--3.
SELECT P.ProductID, SUM(OD.Quantity) AS TotalQuantity
FROM Products P INNER JOIN [Order Details] OD
ON P.ProductID = OD.ProductID
GROUP BY P.ProductID
--4.
SELECT C.City, SUM(OD.Quantity) AS TotayProductQuantity
FROM Customers C LEFT JOIN Orders O
ON C.CustomerID = O.CustomerID INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.City
--5a. Not sure
SELECT DISTINCT C.City
FROM Customers C
GROUP BY C.City
HAVING COUNT(C.CustomerID) >= 2
--5b. Not sure
--6.
SELECT C.City
FROM Customers C JOIN Orders O 
ON C.CustomerID = O.CustomerID JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.City
HAVING COUNT(OD.ProductID) >= 2
ORDER BY C.City
--7.
SELECT DISTINCT C.CustomerID, C.ContactName
FROM Customers C JOIN Orders O 
ON C.CustomerID = O.CustomerID 
WHERE C.City != O.ShipCity
--8.
SELECT P1.ProductID, P2.[avg], P1.City
FROM 
(
SELECT dt.ProductID, dt.City FROM (
SELECT OD.ProductID, C.City, RANK() OVER (PARTITION BY OD.ProductID ORDER BY SUM(OD.Quantity) DESC) RNK
FROM Customers C JOIN Orders O 
ON C.CustomerID = O.CustomerID JOIN [Order Details] OD
ON OD.OrderID = O.OrderID
GROUP BY OD.ProductID, C.City
) dt
WHERE RNK = 1
) P1
JOIN (
    SELECT TOP 5 od.ProductID, AVG(od.UnitPrice) avg
    FROM [Order Details] od
    GROUP BY od.ProductID
    ORDER BY SUM(od.Quantity) DESC
) P2
ON P1.ProductID = P2.ProductID
--9a.
SELECT DISTINCT E.City
FROM Employees E
WHERE E.City NOT IN (
    SELECT DISTINCT O.ShipCity 
    FROM Orders O
)
--9b.
SELECT DISTINCT E.City
FROM Employees E LEFT JOIN Orders O
ON O.ShipCity = E.City
WHERE O.ShipCity IS NULL
--10.
SELECT P1.City FROM (
SELECT TOP 1 C.City
FROM Orders O JOIN Customers C
ON O.CustomerID = C.CustomerID
GROUP BY C.City
ORDER BY COUNT(O.OrderID) DESC
) P1 JOIN (
SELECT TOP 1 C.City
FROM Orders O JOIN Customers C
ON O.CustomerID = C.CustomerID JOIN [Order Details] OD
ON OD.OrderID = O.OrderID
GROUP BY C.City
ORDER BY SUM(OD.Quantity)  DESC
) P2 ON
P1.City = P2.City
--11.
DELETE FROM [TABLE]
    WHERE [ID] NOT IN
    (
        SELECT MAX(ID) FROM [TABLE]
        GROUP BY [ALL FIELDS EXCEPT ID]
    )