INSERT INTO
    Dim_Time (
        date_key,
        full_date,
        year,
        quarter,
        month,
        month_number,
        week_of_year,
        day_of_week,
        is_weekend,
        is_holiday
    )
SELECT DISTINCT
    DATE_FORMAT(rental_date, '%Y%m%d') AS date_key,
    DATE(rental_date) AS full_date,
    YEAR(rental_date) AS year,
    CONCAT('Q', QUARTER(rental_date)) AS quarter,
    MONTHNAME(rental_date) AS month,
    MONTH(rental_date) AS month_number,
    WEEKOFYEAR(rental_date) AS week_of_year,
    DAYNAME(rental_date) AS day_of_week,
    CASE
        WHEN DAYOFWEEK(rental_date) IN (1, 7) THEN 1
        ELSE 0
    END AS is_weekend,
    0 AS is_holiday
FROM sakila.rental
GROUP BY
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_number,
    week_of_year,
    day_of_week,
    is_weekend;

-- poblar la dimension categoria
INSERT INTO
    Dim_Category (category_name)
SELECT DISTINCT
    name
FROM sakila.category;

-- poblar la dimension pelicula
INSERT INTO
    Dim_Film (
        film_title,
        release_year,
        rental_rate,
        length
    )
SELECT DISTINCT
    f.title,
    f.release_year,
    f.rental_rate,
    f.length
FROM sakila.film f;

INSERT INTO
    Fact_Benefits (
        date_key,
        category_key,
        film_key,
        total_rental,
        total_revenue
    )
SELECT
    dt.date_key,
    dcat.category_key,
    dfilm.film_key,
    COUNT(*) AS total_rental,
    SUM(p.amount) AS total_revenue
FROM
    sakila.rental r
    JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
    JOIN sakila.film f ON i.film_id = f.film_id
    JOIN sakila.film_category fc ON f.film_id = fc.film_id
    JOIN sakila.category c ON fc.category_id = c.category_id
    JOIN sakila.payment p ON r.rental_id = p.rental_id
    JOIN Dim_Time dt ON dt.full_date = DATE(r.rental_date)
    JOIN Dim_Category dcat ON dcat.category_name = c.name
    JOIN Dim_Film dfilm ON dfilm.film_title = f.title -
GROUP BY
    dt.date_key,
    dcat.category_key,
    dfilm.film_key;

-- MODIFICACIONES

-- POBLANDO Dim_Customer
INSERT INTO
    Dim_Customer (
        customer_id,
        customer_name,
        email,
        address,
        city,
        country
    )
SELECT c.customer_id, CONCAT(
        c.first_name, ' ', c.last_name
    ) AS customer_name, c.email, a.address, ci.city, co.country
FROM
    sakila.customer c
    JOIN sakila.store s ON s.store_id = c.store_id
    JOIN sakila.address a ON a.address_id = c.address_id
    JOIN sakila.city ci ON ci.city_id = a.city_id
    JOIN sakila.country co ON co.country_id = ci.country_id;

-- Una vez que tenemos poblada la tabla Dim_Customer, podemos de nuevo pobla la tabla Fact_Benefits
INSERT INTO
    Fact_Benefits (
        date_key,
        category_key,
        film_key,
        customer_key,
        total_rental,
        total_revenue
    )
SELECT
    dt.date_key,
    dcat.category_key,
    dfilm.film_key,
    dc.customer_key,
    COUNT(*) AS total_rental,
    SUM(p.amount) AS total_revenue
FROM
    sakila.rental r
    JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
    JOIN sakila.film f ON i.film_id = f.film_id
    JOIN sakila.film_category fc ON f.film_id = fc.film_id
    JOIN sakila.category c ON fc.category_id = c.category_id
    JOIN sakila.payment p ON r.rental_id = p.rental_id
    JOIN Dim_Time dt ON dt.full_date = DATE(r.rental_date)
    JOIN Dim_Category dcat ON dcat.category_name = c.name
    JOIN Dim_Film dfilm ON dfilm.film_title = f.title
    JOIN Dim_Customer dc ON dc.customer_id = r.customer_id
GROUP BY
    dt.date_key,
    dcat.category_key,
    dfilm.film_key,
    dc.customer_key;