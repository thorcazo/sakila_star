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
    rental_rate DECIMAL(4,2),
    length INT
);




-- creacion de TABLA DE HECHOS
CREATE TABLE Fact_Benefits (
    fact_id INT PRIMARY KEY AUTO_INCREMENT,
    date_key INT,
    category_key INT,
    film_key INT,
    total_rental INT,
    total_revenue DECIMAL(10,2),
    FOREIGN KEY (date_key) REFERENCES Dim_Time(date_key),
    FOREIGN KEY (category_key) REFERENCES Dim_Category(category_key),
    FOREIGN KEY (film_key) REFERENCES Dim_Film(film_key)
);
