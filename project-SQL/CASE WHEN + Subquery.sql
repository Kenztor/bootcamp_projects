-- หาจำนวนลูกค้าทั้งหมดที่อยู่ในแต่ละทวีป

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
