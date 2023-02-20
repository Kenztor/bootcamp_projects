-- Restaurant Owners
-- 5 Tables
-- 1x Fact, 4x Dimension
-- 1 subquery/ with
CREATE TABLE orders (
  order_id int,
  customer_id varchar(20),
  store_id varchar(20),
  order_date date,
  menu_id int,
  service_type_id int,
  quantity int,
  price real,
  CONSTRAINT FK_customer_id FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id),
  CONSTRAINT FK_store_id FOREIGN KEY (store_id)
    REFERENCES stores (store_id),
  CONSTRAINT FK_menu_id FOREIGN KEY (menu_id)
    REFERENCES menu (menu_id),
  CONSTRAINT FK_service_type_id FOREIGN KEY (service_type_id)
    REFERENCES serviceType(service_type_id)
);

INSERT INTO orders VALUES
  (000001,'C001', 'STORE01', '2023-02-01', 001, 01, 2, 90),
  (000002,'C002', 'STORE01', '2023-02-01', 001, 02, 1, 90),
  (000003,'C003', 'STORE03', '2023-02-01', 002, 02, 2, 550),
  (000004,'C001', 'STORE02', '2023-02-05', 002, 03, 2, 550),
  (000005,'C002', 'STORE01', '2023-02-07', 004, 01, 1, 1000),
  (000005,'C004', 'STORE04', '2023-02-07', 005, 02, 1, 50),
  (000005,'C005', 'STORE05', '2023-02-07', 005, 03, 1, 50),
  (000006,'C001', 'STORE02', '2023-02-08', 003, 03, 1, 550);

CREATE TABLE customers (
  customer_id varchar(20) PRIMARY KEY,
  customer_firstname varchar(20),
  customer_lastname varchar(20),
  customer_gender varchar(20),
  customer_phone varchar(10) UNIQUE
);

INSERT INTO customers VALUES
  ('C001', 'Ken', 'Handerson', 'M', '022340120'),
  ('C002', 'Cody', 'Gakpo', 'M', '023990120'),
  ('C003', 'Mo', 'Salah', 'M', '022990450'),
  ('C004', 'Anna', 'Firmino', 'F', '0229240120'),
  ('C005', 'Jessica', 'Dias', 'F', '021290120');

CREATE TABLE menu (
  menu_id INT PRIMARY KEY,
  menu_name varchar(100), 
  menu_type varchar(100),
  menu_price INT
);

INSERT INTO menu VALUES
  (001, 'Fried chicken wings', 'STARTER', 90),
  (002, 'Thai green chicken curry', 'SOUP DISHES', 550),
  (003, 'Tom yam seafood', 'SOUP DISHES', 550),
  (004, 'Seabass with fish sauce dressing', 'FISH DISHES ', 1000),
  (005, 'Mango Sticky rice', 'DESSERT', 50),
  (006, 'Hawaiian', 'Pizza', 350),
  (007, 'Red Wine', 'DRINK', 400),
  (008, 'White Wine', 'DRINK', 200),
  (009, 'Sparkling Wine', 'DRINK', 200);

CREATE TABLE stores (
  store_id varchar(20) PRIMARY KEY, 
  store_region varchar(100)
);

INSERT INTO stores VALUES
  ('STORE01', 'E01'),
  ('STORE02', 'N01'),
  ('STORE03', 'S01'),
  ('STORE04', 'W01'),
  ('STORE05', 'N02');

CREATE TABLE serviceType (
  service_type_id int primary key, 
  service_type_des varchar(100)
);

INSERT INTO serviceType VALUES
  (01, 'dine-in'),
  (02, 'take-away'),
  (03, 'delivery');

  ---1.Total Spend in 2023?
  
SELECT
	 STRFTIME('%Y', order_date) AS year,
	 SUM(price) AS total_spend
FROM orders
WHERE  STRFTIME('%Y', order_date) = '2023';
  
---2.Top Spend in 2023 by Region?

WITH stores_y2023 AS	(
		SELECT 
  			od.order_date,
  			od.quantity,
  			od.price as price,
  			st.store_id, 
  			st.store_region as store_region
  		FROM orders od
  		JOIN stores st ON  od.store_id = st.store_id
  		WHERE STRFTIME('%Y', od.order_date) = '2023'  
)

SELECT
	store_region,
	SUM(price) as Total_Spend
FROM stores_y2023
GROUP BY store_region
order BY Total_Spend DESC;

---3.Which gender of the customer spends the most on our store?

SELECT 
	cu.customer_gender,
  SUM(od.price) as Total_Spend
FROM orders od
JOIN customers cu on od.customer_id = cu.customer_id
GROUP BY cu.customer_gender
order By  2 DESC;

---4.Which menu sells the best?

SELECT 
  m.menu_name,
  SUM(o.price)
FROM orders o
JOIN menu m ON o.menu_id = m.menu_id
GROUP BY m.menu_name
ORDER BY SUM(o.price) DESC;

---5.Which channels do customers spend the most?

SELECT 
  se.service_type_des,
  SUM(o.price)
FROM orders o
JOIN serviceType se ON o.service_type_id = se.service_type_id
GROUP BY se.service_type_des
ORDER BY SUM(o.price) DESC;




  






