-- 1. Using CONCAT
SELECT first_name, last_name, CONCAT(first_name, ' ', last_name) AS full_name
FROM tbl_customers;

-- 2. Using LOWER()
SELECT * FROM tbl_products;
SELECT LOWER(name) from tbl_products;

-- 3. Using UPPER()
SELECT * FROM tbl_products;
SELECT UPPER(category) FROM tbl_products;

-- 4. Using LENGTH()
SELECT * FROM tbl_customers;
SELECT email, LENGTH(email) AS email_length
FROM tbl_customers;

-- 5. Using SUBSTRING()
SELECT * FROM tbl_customers;
SELECT id, SUBSTRING(email, 1, 9) AS email_prefix
FROM tbl_customers
WHERE id = 1;

-- 6. Using REPLACE()
SELECT * FROM tbl_customers;
SELECT id, REPLACE(email, 'williamsuk.com', 'williamsglobal.it') AS new_email
FROM tbl_customers
WHERE id = 3;

-- 7. Using LEFT()
SELECT * FROM tbl_customers;
SELECT id, phone_number, LEFT(phone_number, 2) AS country_code
FROM tbl_customers;

-- 8. USING RIGHT()
SELECT * FROM tbl_customers;
SELECT id, first_name, last_name, RIGHT(phone_number, 4) AS last_digits
FROM tbl_customers;

-- 9. Using LOCATE()
SELECT * FROM tbl_customers;
SELECT id, first_name, last_name, email, LOCATE('@', email) AS sign_position
FROM tbl_customers;

--10. Using INSTR()
SELECT * FROM tbl_customers;
SELECT id, first_name, last_name, email, INSTR(email, '.com') AS domain_position
FROM tbl_customers;

--11. Using LPAD
SELECT * FROM tbl_orders;
SELECT id AS original_id, order_date, status, LPAD(id, 5, '0') AS formatted_id
FROM tbl_orders;

-- Using some functions in a query
SELECT
  id, first_name, last_name, email,
  UPPER(CONCAT(first_name, ' ', last_name)) AS full_name,
  SUBSTR(email, 1, LOCATE('@', email) - 1) AS email_username,
  LENGTH(email) AS email_length
FROM tbl_customers
WHERE id IN (2, 3);