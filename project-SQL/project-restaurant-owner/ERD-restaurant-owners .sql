CREATE TABLE `orders` (
  `order_id` int PRIMARY KEY,
  `customer_id` varchar(20),
  `store_id` varchar(20),
  `order_date` date,
  `menu_id` int,
  `service_type_id` int,
  `quantity` int,
  `price` real
);

CREATE TABLE `customers` (
  `customer_id` varchar(20) PRIMARY KEY,
  `customer_firstname` varchar(20),
  `customer_lastname` varchar(20),
  `customer_gender` varchar(20),
  `customer_phone` varchar(10) UNIQUE
);

CREATE TABLE `menu` (
  `menu_id` INT PRIMARY KEY,
  `menu_name` varchar(100),
  `menu_type` varchar(100),
  `menu_price` INT
);

CREATE TABLE `stores` (
  `store_id` varchar(20) PRIMARY KEY,
  `store_region` varchar(100)
);

CREATE TABLE `serviceType` (
  `service_type_id` int PRIMARY KEY,
  `service_type_des` varchar(100)
);

ALTER TABLE `orders` ADD CONSTRAINT `a_relationship` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`);

ALTER TABLE `orders` ADD CONSTRAINT `a_relationship` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`);

ALTER TABLE `orders` ADD CONSTRAINT `a_relationship` FOREIGN KEY (`store_id`) REFERENCES `stores` (`store_id`);

ALTER TABLE `orders` ADD CONSTRAINT `a_relationship` FOREIGN KEY (`service_type_id`) REFERENCES `serviceType` (`service_type_id`);
