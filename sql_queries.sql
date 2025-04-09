Tasks:
1.List the top 5 customers by total purchase amount.


2.Find the most popular genre in terms of total tracks sold.


3.Retrieve all employees who are managers along with their subordinates.


4.For each artist, find their most sold album.


5.Write a query to get monthly sales trends in the year 2013.




1.
SELECT CustomerId, FirstName, LastName, SUM(Total) AS TotalSpent
FROM Customer
JOIN Invoice USING (CustomerId)
GROUP BY CustomerId, FirstName, LastName
ORDER BY TotalSpent DESC
LIMIT 5;


2.
SELECT g.Name AS genre_name, SUM(i.Quantity) AS total_track_sold
FROM Genre AS g
JOIN Track AS t ON g.GenreId = t.GenreId
JOIN InvoiceLine AS i ON i.TrackId = t.TrackId
GROUP BY g.GenreId, g.Name
ORDER BY total_track_sold DESC
LIMIT 1;

3.
SELECT
    m.EmployeeId AS manager_id,
    CONCAT(m.FirstName, ' ', m.LastName) AS manager_name,
    e.EmployeeId AS emp_id,
    CONCAT(e.FirstName, ' ', e.LastName) AS emp_name
FROM Employee AS e
JOIN Employee AS m ON e.ReportsTo = m.EmployeeId;

4.
WITH album_sold AS (
  SELECT a.ArtistId, 
  a.Name, 
  b.AlbumId, 
  b.Title,
  SUM(i.Quantity) AS total_sales,
  RANK() OVER (PARTITION BY a.ArtistId ORDER BY SUM(i.Quantity) DESC) AS rank
FROM Artist AS a 
JOIN Album  AS b 
ON b.ArtistId = a.ArtistId
JOIN Track as t 
ON b.AlbumId = t.AlbumId
JOIN InvoiceLine AS i 
ON t.TrackId = i.TrackId
GROUP BY a.ArtistId,a.Name,b.AlbumId,b.Title
)
  SELECT *
  FROM album_sold
  WHERE rank = 1;

5.
SELECT 
  STRFTIME('%m', InvoiceDate) AS month,
  SUM(Total) AS total_sales
FROM Invoice
WHERE STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY month
ORDER BY month;