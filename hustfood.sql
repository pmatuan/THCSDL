DROP DATABASE HUST
CREATE DATABASE HUST
USE HUST
CREATE TABLE customer (
    customer_id INT NOT NULL PRIMARY KEY,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    email_id VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    landmark NVARCHAR(255) NOT NULL
)

CREATE TABLE menu (
    menu_id INT NOT NULL PRIMARY KEY,
    menu_name VARCHAR(255) NOT NULL,
    price INT NOT NULL
)

CREATE TABLE orders (
    order_id INT NOT NULL PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customer(customer_id),
    menu_id INT FOREIGN KEY REFERENCES menu(menu_id),
    quantity INT NOT NULL DEFAULT '1',
    order_status VARCHAR(255) NOT NULL CHECK(order_status IN ('ADDED_TO_CART','CONFIRMED','PAYMENT_CONFIRMED','DELIVERED')),
    time_orders time DEFAULT GETDATE(),
    date_orders date DEFAULT GETDATE()
)