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


---3.



