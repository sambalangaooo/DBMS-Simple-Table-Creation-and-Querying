-- Balangao, Samantha A. (BSCpE 4-2)

-- Lookup table for Address Components
CREATE TABLE tbl_street (
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);

CREATE TABLE tbl_city (
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);

CREATE TABLE tbl_region (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);

CREATE TABLE tbl_country (
  id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(64) NOT NULL
);

-- Main tables
CREATE TABLE tbl_customers (
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  email VARCHAR(128) NOT NULL,
  phone_number CHAR(15) NOT NULL, -- ITU Standard format for phone numbers.
  street_id MEDIUMINT UNSIGNED,
  city_id MEDIUMINT UNSIGNED,
  region_id SMALLINT UNSIGNED,
  country_id TINYINT UNSIGNED,
  FOREIGN KEY (street_id) REFERENCES tbl_street(id),
  FOREIGN KEY (city_id) REFERENCES tbl_city(id),
  FOREIGN KEY (region_id) REFERENCES tbl_region(id),
  FOREIGN KEY (country_id) REFERENCES tbl_country(id)
);

CREATE TABLE tbl_products(
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(128) NOT NULL,
  description TEXT,
  price DECIMAL(8,2),
  stock_quantity SMALLINT,
  category CHAR(64)
);

CREATE TABLE tbl_orders(
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id MEDIUMINT UNSIGNED,
  order_date DATE,
  status ENUM("Pending", "Delivered", "Canceled"),
  total_amount DECIMAL(8,2),
  FOREIGN KEY (customer_id) REFERENCES tbl_customers(id)
);

CREATE TABLE tbl_order_details(
  id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id MEDIUMINT UNSIGNED,
  product_id MEDIUMINT UNSIGNED,
  quantity TINYINT(10) UNSIGNED,
  subtotal DECIMAL(8,2),
  FOREIGN KEY (order_id) REFERENCES tbl_orders(id),
  FOREIGN KEY (product_id) REFERENCES tbl_products(id)
);

-- INSERT
INSERT INTO tbl_country(id, name)
VALUES
  (1, "Philippines"),
  (2, "Monaco"),
  (3, "Spain"),
  (4, "Japan"),
  (5, "Italy");

INSERT INTO tbl_region(id, name)
VALUES
  (1, "NCR"),
  (2, "Monte Carlo"),
  (3, "Asturias"),
  (4, "Kanto"),
  (5, "Emilia-Romagna");

INSERT INTO tbl_city(id, name)
VALUES
  (1, "Manila"),
  (2, "Monte-Carlo"),
  (3, "Madrid"),
  (4, "Suzuka"),
  (5, "Maranello");

INSERT INTO tbl_street (id, name)
VALUES
(1, 'Pureza'),
(2, 'Larvotto'),
(3, 'Calle Madrigal'),
(4, 'Shibuya'),
(5, 'Milano Street');

INSERT INTO tbl_customers (id, first_name, last_name, email, phone_number, street_id, city_id, region_id, country_id)
VALUES
  (1, 'Alex', 'Albon', 'alexalbon@williamsph.com', '639171234567', 1, 1, 1, 1),
  (2, 'Charles', 'Leclerc', 'charleslec@ferrari.com', '37712345678', 2, 2, 2, 2),
  (3, 'Carlos', 'Sainz', 'carlossainz@williamsuk.com', '34911234567', 3, 3, 3, 3),
  (4, 'Yuki', 'Tsunoda', 'yukitsunoda@yahoo.com', '81801234567', 4, 4, 4, 4),
  (5, 'Max', 'Verstappen', 'maxver@gmail.com', '31612345678', 5, 5, 5, 5);

INSERT INTO tbl_products (id, name, description, price, stock_quantity, category) -- Assuming that prices are in PH peso
VALUES
  (1, 'Pirelli Soft Tire Mug', 'Coffee mug shaped like the C4 soft tire.', 2300.99, 300, 'Accessories'),
  (2, 'Ferrari Windbreaker', 'Official Oracle Red Bull Racing team cap.', 4500.00, 200, 'Apparel'),
  (3, 'Williams T-Shirt', 'Williams T-shirt for Men.', 5000.00, 50, 'Apparel'),
  (4, 'Toro Rosso Jacket', 'AlphaTauri/Visa Cash App Team Winter Jacket.', 5000.00, 50, 'Apparel'),
  (5, 'Emilia-Romagna Track Print', 'Minimalist A3 print of the Emilia-Romagna Circuit for the Italian Grand Prix.', 3550.00, 100, 'Prints');

INSERT INTO tbl_orders (id, customer_id, order_date, status, total_amount)
VALUES
  (1, 1, '2025-10-10', 'Delivered', 5000.00),
  (2, 2, '2025-10-10', 'Pending', 8050.00), -- 4500.00 + 3550.00
  (3, 3, '2025-10-11', 'Delivered', 4601.98), -- 2 * 2300.99
  (4, 4, '2025-10-12', 'Canceled', 5000.00),
  (5, 5, '2025-10-13', 'Pending', 4500.00);

  INSERT INTO tbl_order_details (id, order_id, product_id, quantity, subtotal)
VALUES
  (1, 1, 3, 1, 5000.00),  -- Alex: 1 Williams T-shirt
  (2, 2, 5, 1, 3550.00),  -- Charles: 1 Emilia-Romagna Print
  (3, 3, 1, 2, 4601.98),  -- Carlos: 2 Pirelli Mugs
  (4, 4, 4, 1, 5000.00),  -- Yuki: 1 Toro Rosso Jacket
  (5, 5, 2, 1, 4500.00);  -- Max: 1 Ferrari Windbreaker

-- EDIT/UPDATE
UPDATE tbl_products
SET price = 2500.00
WHERE id=1; -- This only updates the future prices but not the ones existing. Let us try to update them.

UPDATE tbl_order_details
SET subtotal = 5000.00
WHERE product_id = 1; -- this updates the subtotal for the order details.

UPDATE tbl_orders
SET total_amount = 5000.00
where id=3;

-- DELETE
-- Since tbl_order_details depends on tbl_orders, we must delete first from here.
DELETE FROM tbl_order_details
WHERE order_id = 4;

DELETE FROM tbl_orders
WHERE id =4; -- We now remove Yuki's cancelled order from the orders table.

-- SELECT Statements
--1.
SELECT
  category,
  total_sales,
  RANK() OVER(ORDER BY total_sales DESC) AS sales_rank
FROM(
  SELECT
    p.category,
    SUM(od.subtotal) AS total_sales
  FROM tbl_order_details od
  JOIN tbl_products p ON od.product_id = p.id
  GROUP BY p.category
) AS category_sales;

-- 2.
SELECT
  c.first_name,
  c.last_name,
  COUNT(o.id) AS order_count
FROM
  tbl_customers c
JOIN
  tbl_orders o ON c.id = o.customer_id
GROUP BY
  c.id, c.first_name, c.last_name
ORDER BY
  order_count DESC;

--3.
SELECT
  first_name,
  last_name
FROM
  tbl_customers
WHERE id IN(
  SELECT DISTINCT o.customer_id
  FROM tbl_orders o
  JOIN tbl_order_details od ON o.id = od.order_id
  JOIN tbl_products p ON od.product_id = p.id
  WHERE p.category = "Apparel"
);

--4.
SELECT
  c.first_name,
  c.last_name,
  s.name AS street,
  cy.name AS city,
  r.name AS region,
  cr.name AS country
FROM
  tbl_customers c
JOIN tbl_street s ON c.street_id = s.id
JOIN tbl_city cy ON c.city_id = cy.id
JOIN tbl_region r ON c.region_id = r.id
JOIN tbl_country cr ON c.country_id = cr.id
WHERE
  c.id = 4;

-- 5.
SELECT
  c.first_name,
  c.last_name,
  SUM(o.total_amount) AS total_spent
FROM tbl_customers c
JOIN
  tbl_orders o ON c.id = o.customer_id
GROUP BY
  c.id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 5000.00
ORDER BY
  total_spent DESC;