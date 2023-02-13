-- หาลูกค้าที่อยู่ใน USA และ หายอดรวมรายจ่ายในปี  2010
-- หาผลรวม revenue ในปี 2010 ของลูกค้าแต่ละคนที่อยู่ USA และ เรียงลูกค้าที่จ่ายเงินเยอะที่สุดถึงน้อยสุด
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

--- Group By จาก Index
SELECT
		u.customerid,
    u.firstname,
    u.lastname,
    ROUND(SUM(i.total),2) AS total_invoice
FROM usa_customers AS u
JOIN invoice_y2010 AS i ON u.customerid = i.customerid
GROUP BY 1,2,3
ORDER BY 4 DESC -- descending high to low



