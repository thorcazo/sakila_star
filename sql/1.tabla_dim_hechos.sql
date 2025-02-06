CREATE TABLE Dim_Time (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    quarter VARCHAR(5),
    month VARCHAR(15),
    month_number INT,
    week_of_year INT,
    day_of_week VARCHAR(15),
    is_weekend BOOLEAN,
    is_holiday BOOLEAN
);

CREATE TABLE Dim_Category (
    category_key INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Dim_Film (
    film_key INT PRIMARY KEY AUTO_INCREMENT,
    film_title VARCHAR(255) NOT NULL,
    release_year YEAR,
    rental_rate DECIMAL(4, 2),
    length INT
);

-- creacion de TABLA DE HECHOS
CREATE TABLE Fact_Benefits (
    fact_id INT PRIMARY KEY AUTO_INCREMENT,
    date_key INT,
    category_key INT,
    film_key INT,
    total_rental INT,
    total_revenue DECIMAL(10, 2),
    FOREIGN KEY (date_key) REFERENCES Dim_Time (date_key),
    FOREIGN KEY (category_key) REFERENCES Dim_Category (category_key),
    FOREIGN KEY (film_key) REFERENCES Dim_Film (film_key)
);

-- MODIFICACIONES

-- Comprobando los datos que necesito
-- Uniendo la tabla customer con rental para la tabla Dim_Customer
-- namecustomer, address, city, country, email, rental_id ...

-- PRUEBAS DE CONSULTA PARA VERIFICAR LOS DATOS
SELECT
    CONCAT(first_name, " ", last_name) as customer_name,
    email,
    address,
    city,
    country,
    rental_id,
    film_id
from
    sakila.customer
    join sakila.store on sakila.store.store_id = sakila.customer.store_id
    join sakila.address on sakila.address.address_id = sakila.customer.address_id
    join sakila.city on sakila.city.city_id = sakila.address.city_id
    join sakila.country on sakila.country.country_id = sakila.city.country_id
    join sakila.rental on sakila.rental.customer_id = sakila.customer.customer_id
    join sakila.inventory on sakila.inventory.inventory_id = sakila.rental.inventory_id

-- CREANDO TABLA Dim_Customer
CREATE TABLE Dim_Customer (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    customer_name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100)
);


-- MODIFICACIONES en Fact_Benefits para agregar la llave foranea de la tabla Dim_Customer
ALTER TABLE Fact_Benefits
ADD COLUMN customer_key INT AFTER film_key;

ALTER TABLE Fact_Benefits
ADD CONSTRAINT fk_customer FOREIGN KEY (customer_key) REFERENCES Dim_Customer (customer_key);




-- Dim_Store

-- Crear la tabla Dim_Store
CREATE TABLE Dim_Store (
    store_key INT PRIMARY KEY AUTO_INCREMENT,  -- Clave surrogate
    store_id INT,                               -- Identificador natural de la tienda
    address_name VARCHAR(255),
    city_name VARCHAR(100),
    country_name VARCHAR(100),
    manager_name VARCHAR(255)
);

-- Alteramos Fact_Benefits para agregar la llave foranea de la tabla Dim_Store
ALTER TABLE Fact_Benefits 
    ADD COLUMN store_key INT AFTER customer_key;

ALTER TABLE Fact_Benefits 
    ADD CONSTRAINT fk_store FOREIGN KEY (store_key) REFERENCES Dim_Store(store_key);



