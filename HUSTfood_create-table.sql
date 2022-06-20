DROP DATABASE hustfood
CREATE DATABASE hustfood
USE hustfood
--Restaurants and customers
CREATE TABLE customer (
  id INT PRIMARY KEY,
  customer_name VARCHAR(255),
  address NVARCHAR(255),
  contact_phone CHAR(10),
  email VARCHAR(255),
  password VARCHAR(255)
)
CREATE TABLE restaurant (
  id INT PRIMARY KEY,
  address NVARCHAR(255)
)


--Menu
CREATE TABLE offer(
  id INT PRIMARY KEY,
  data_active_from date DEFAULT GETDATE(),
  time_active_from time DEFAULT GETDATE(),
  data_active_to date DEFAULT GETDATE(),
  time_active_to time DEFAULT GETDATE(),
  offer_price DECIMAL(12,2)
)
CREATE TABLE category(
  id INT PRIMARY KEY,
  category_name VARCHAR(255)
)
CREATE TABLE menu_item(
  id INT PRIMARY KEY,
  item_name VARCHAR(255),
  category_id INT FOREIGN KEY REFERENCES category(id),
  description text,
  ingredients text,
  recipe text,
  price decimal(12,2),
  active BIT
)
CREATE TABLE in_offer(
  id INT PRIMARY KEY,
  offer_id INT FOREIGN KEY REFERENCES offer(id),
  menu_item_id INT FOREIGN KEY REFERENCES menu_item(id)
)




--Orders
CREATE TABLE status_catalog(
  id INT PRIMARY KEY,
  status_name VARCHAR(255)
)
CREATE TABLE order_status(
  id INT PRIMARY KEY,
  placed_order_id INT FOREIGN KEY REFERENCES placed_order(id),
  status_catalog_id INT FOREIGN KEY REFERENCES,
  ts TIMESTAMP
)
CREATE TABLE placed_order(
  id INT PRIMARY KEY,
  restaurant_id INT FOREIGN KEY REFERENCES restaurant(id),
  order_time TIMESTAMP,
  estimated_dilevery_time TIMESTAMP,
  food_ready TIMESTAMP,
  actual_delivery_time TIMESTAMP,
  delivery_address VARCHAR(255),
  customer_id INT FOREIGN KEY REFERENCES customer(id),
  price DECIMAL(12,2),
  discount DECIMAL(12,2),
  final_price DECIMAL(12,2),
  comment TEXT,
  ts TIMESTAMP
)
CREATE TABLE comment(
  id INT PRIMARY KEY,
  placed_order_id INT FOREIGN KEY REFERENCES,
  customer_id INT FOREIGN KEY REFERENCES customer(id), --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  comment_text TEXT,
  ts TIMESTAMP,
  is_complaint BIT,
  is_praise BIT
)
CREATE TABLE in_order(
  id INT PRIMARY KEY,
  place_order_id INT FOREIGN KEY REFERENCES,
  offer_id INT FOREIGN KEY REFERENCES,
  menu_item_id INT FOREIGN KEY REFERENCES,
  quantity INT,
  item_price DECIMAL(12,2),
  price DECIMAL(12,2),
  comment text
)