--- 1.Total number of customers located in each continent

SELECT
	region,
	COUNT(*) AS n_sub
FROM (
	SELECT
	   country,
    	   CASE 
    	    WHEN country IN ('USA', 'Canada') THEN 'North America'
	    WHEN country IN ('Brazil') THEN 'South America'
            WHEN country IN ('Italy', 'Belgium', 'Germany', 'Denmark', 'Portugal') THEN 'Europe'
    	    ELSE 'Other Regions'
           END AS region
	FROM customers
) AS sub
GROUP BY 1
ORDER BY 2 DESC -- descending order high to low

-- refactor using WITH clause

WITH sub AS (
	SELECT
	   country,
         CASE
    	    WHEN country IN ('USA', 'Canada') THEN 'North America'
	    WHEN country IN ('Brazil') THEN 'South America'
            WHEN country IN ('Italy', 'Belgium', 'Germany', 'Denmark', 'Portugal') THEN 'Europe'
    	    ELSE 'Other Regions'
         END AS region
	FROM customers
)

SELECT 
   region,
   COUNT(*) AS n_sub
FROM sub
GROUP BY 1
ORDER BY 2 DESC

---2.Total spending by each customer in the USA in 2010 and Ranked from the highest paying customers to the lowest.

WITH invoice_y2010 AS (
      SELECT -- factInvoices
        invoicedate,
        STRFTIME('%Y%m', invoicedate) AS monthID,
        customerid, -- key
        total
      FROM invoices
      WHERE  STRFTIME('%Y', invoicedate) = '2010'
), usa_customers AS ( -- dimCustomers
		SELECT
	          customerid, -- key
	          firstname,
	          lastname
		FROM customers
		WHERE country = 'USA'
)

SELECT
    u.customerid,
    u.firstname,
    u.lastname,
    ROUND(SUM(i.total),2) AS total_invoice
FROM usa_customers AS u
JOIN invoice_y2010 AS i ON u.customerid = i.customerid
GROUP BY u.customerid, u.firstname, u.lastname
ORDER BY SUM(i.total) DESC -- descending high to low

--- Group By by Index
SELECT
    u.customerid,
    u.firstname,
    u.lastname,
    ROUND(SUM(i.total),2) AS total_invoice
FROM usa_customers AS u
JOIN invoice_y2010 AS i ON u.customerid = i.customerid
GROUP BY 1,2,3
ORDER BY 4 DESC -- descending high to low

---3.The total number of songs included in each genre, excluding Jazz and genres with more than 100 songs.

WITH genres_notjazz AS (
		SELECT
		   ar.name AS artist_name,
		   al.title,
		   tr.name AS track_name,
		   tr.milliseconds,
		   tr.bytes,
		   ge.name AS genre_name
		FROM artists ar 
		JOIN albums  al ON ar.artistid = al.artistid
		JOIN tracks  tr ON tr.albumid  = al.albumid
		JOIN genres  ge ON ge.genreid  = tr.genreid
		WHERE ge.name <> 'Jazz' -- OKAY
)

SELECT
   genre_name,
   COUNT(*) AS n_tracks
FROM genres_notjazz
GROUP BY genre_name
HAVING COUNT(*) > 100
ORDER BY n_tracks DESC






