DROP DATABASE hustfood
CREATE DATABASE hustfood
USE hustfood


--Restaurants and customers
CREATE TABLE customer (
   id int  NOT NULL,
   customer_name varchar(255)  NOT NULL,
   building varchar(255)  NOT NULL,
   phone_number char(10)  NOT NULL,
   email varchar(255)  NOT NULL,
   password varchar(255)  NOT NULL,
   CONSTRAINT customer_pk PRIMARY KEY (id)
);
CREATE TABLE restaurant (
   id int  NOT NULL,
   address varchar(255)  NOT NULL,
   CONSTRAINT restaurant_pk PRIMARY KEY (id)
);


--Menus
CREATE TABLE offer (
   id int  NOT NULL,
   date_active_from date  NULL,
   time_active_from time  NULL,
   date_active_to date  NULL,
   time_active_to time  NULL,
   offer_price int  NOT NULL,
   CONSTRAINT offer_pk PRIMARY KEY (id)
);

CREATE TABLE in_offer (
   id int  NOT NULL,
   offer_id int  NOT NULL,
   menu_item_id int  NOT NULL,
   CONSTRAINT in_offer_ak_1 UNIQUE (offer_id, menu_item_id),
   CONSTRAINT in_offer_pk PRIMARY KEY (id)
);

CREATE TABLE menu_item (
   id int  NOT NULL,
   item_name varchar(255)  NOT NULL,
   category_id int  NOT NULL,
   description text  NOT NULL,
   ingredients text  NOT NULL,
   recipe text  NOT NULL,
   price int  NOT NULL,
   active BIT  NOT NULL,
   CONSTRAINT menu_item_pk PRIMARY KEY (id)
);

CREATE TABLE category (
   id int  NOT NULL,
   category_name varchar(255)  NOT NULL,
   CONSTRAINT category_ak_1 UNIQUE (category_name),
   CONSTRAINT category_pk PRIMARY KEY (id)
);


--Orders
CREATE TABLE status_catalog (
   id int  NOT NULL,
   status_name varchar(255)  NOT NULL CHECK(status_name IN ('ADDED_TO_CART','CONFIRMED','PAYMENT_CONFIRMED','DELIVERED')),
   CONSTRAINT status_catalog_ak_1 UNIQUE (status_name),
   CONSTRAINT status_catalog_pk PRIMARY KEY (id)
);

CREATE TABLE order_status (
   id int  NOT NULL,
   placed_order_id int  NOT NULL,
   status_catalog_id int  NOT NULL,
   time_order time DEFAULT GETDATE(),
   CONSTRAINT order_status_pk PRIMARY KEY (id)
);
CREATE TABLE placed_order (
   id int  NOT NULL,
   restaurant_id int  NOT NULL,
   order_time time DEFAULT GETDATE(),
   estimated_delivery_time time DEFAULT GETDATE(),
   food_ready time DEFAULT GETDATE(),
   delivery_address varchar(255)  NOT NULL,
   customer_id int  NULL,
   price int  NOT NULL,
   discount int  NOT NULL,
   final_price int  NOT NULL,
   comment text  NULL,
   delivered BIT DEFAULT 0,
   CONSTRAINT placed_order_pk PRIMARY KEY (id)
);

CREATE TABLE comment (
   id int  NOT NULL,
   placed_order_id int  NOT NULL,
   customer_id int  NOT NULL,
   comment_text text  NOT NULL,
   is_complaint BIT  NOT NULL,
   is_praise BIT  NOT NULL,
   CONSTRAINT comment_pk PRIMARY KEY (id)
);
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CREATE TABLE customer_order (
   id int  NOT NULL,
   customer_name varchar(255)  NOT NULL,
   building varchar(255)  NOT NULL,
   phone_number char(10)  NOT NULL,
   email varchar(255)  NOT NULL,
   password varchar(255)  NOT NULL,
   CONSTRAINT customer_order_pk PRIMARY KEY (id)
);

CREATE TABLE in_order (
   id int  NOT NULL,
   placed_order_id int  NOT NULL,
   offer_id int  NULL,
   menu_item_id int  NULL,
   quantity int  NOT NULL,
   item_price int  NOT NULL,
   price int  NOT NULL,
   comment text  NULL,
   CONSTRAINT in_order_pk PRIMARY KEY (id)
);


--Update Key
ALTER TABLE placed_order ADD CONSTRAINT order_customer
FOREIGN KEY (customer_id)
REFERENCES customer (id)
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE placed_order ADD CONSTRAINT order_restaurant
FOREIGN KEY (restaurant_id)
REFERENCES restaurant (id)
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE order_status ADD CONSTRAINT order_status_status_catalog
FOREIGN KEY (status_catalog_id)
REFERENCES status_catalog (id)
ON UPDATE CASCADE ON DELETE CASCADE


ALTER TABLE order_status ADD CONSTRAINT order_status_order
FOREIGN KEY (placed_order_id)
REFERENCES placed_order (id) 
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE comment ADD CONSTRAINT comment_placed_order
FOREIGN KEY (placed_order_id)
REFERENCES placed_order (id) 
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE comment ADD CONSTRAINT comment_customerorder
FOREIGN KEY (customer_id)
REFERENCES customer_order (id)
ON UPDATE CASCADE ON DELETE CASCADE


ALTER TABLE in_order ADD CONSTRAINT in_order_order
FOREIGN KEY (placed_order_id)
REFERENCES placed_order (id) 
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE in_order ADD CONSTRAINT in_order_offer
FOREIGN KEY (offer_id)
REFERENCES offer (id)
ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE in_offer ADD CONSTRAINT in_offer_offer
FOREIGN KEY (offer_id)
REFERENCES offer (id)
ON UPDATE CASCADE ON DELETE CASCADE


ALTER TABLE in_offer ADD CONSTRAINT in_offer_menu_item
FOREIGN KEY (menu_item_id)
REFERENCES menu_item (id)  
ON UPDATE CASCADE ON DELETE CASCADE


ALTER TABLE in_order ADD CONSTRAINT in_order_menu_item
FOREIGN KEY (menu_item_id)
REFERENCES menu_item (id)
ON UPDATE CASCADE ON DELETE CASCADE


ALTER TABLE menu_item ADD CONSTRAINT menu_item_category
FOREIGN KEY (category_id)
REFERENCES category (id)
ON UPDATE CASCADE ON DELETE CASCADE