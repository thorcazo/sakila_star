-- Beneficios totales por categoría y mes
SELECT c.category_name, t.year, t.month, SUM(fb.total_revenue) AS total_revenue
FROM
    Fact_Benefits fb
    JOIN Dim_Time t ON fb.date_key = t.date_key
    JOIN Dim_Category c ON fb.category_key = c.category_key
GROUP BY
    c.category_name,
    t.year,
    t.month
ORDER BY t.year, t.month, c.category_name;

-- Películas más alquiladas por año
SELECT t.year, f.film_title, SUM(fb.total_rental) AS total_rentals
FROM
    Fact_Benefits fb
    JOIN Dim_Time t ON fb.date_key = t.date_key
    JOIN Dim_Film f ON fb.film_key = f.film_key
GROUP BY
    t.year,
    f.film_title
ORDER BY t.year, total_rentals DESC;

-- Beneficios generados por trimestre
SELECT t.year, t.quarter, SUM(fb.total_revenue) AS revenue_per_quarter
FROM Fact_Benefits fb
    JOIN Dim_Time t ON fb.date_key = t.date_key
    -- WHERE t.year = 2005  
GROUP BY
    t.year,
    t.quarter
ORDER BY t.quarter;

-- Comparación de ingresos entre días laborables y fines de semana
SELECT
    CASE
        WHEN t.is_weekend = 1 THEN 'Fin de Semana'
        ELSE 'Día de Semana'
    END AS day_type,
    SUM(fb.total_revenue) AS total_revenue
FROM Fact_Benefits fb
    JOIN Dim_Time t ON fb.date_key = t.date_key
GROUP BY
    day_type;

-- Beneficios obtenidos en días festivos

SELECT
    -- t.full_date,  
    SUM(fb.total_revenue) AS total_revenue
FROM Fact_Benefits fb
    JOIN Dim_Time t ON fb.date_key = t.date_key
WHERE
    t.is_holiday = 1
    -- GROUP BY t.full_date  
ORDER BY t.full_date;

-- NUEVAS CONSULTAS con la Dim_Customer

select * from `Fact_Benefits`

-- Los clientes que mas han alquilado peliculas
select
    fb.customer_key,
    customer_name,
    count(*) as total_rental,
    full_date
from
    `Fact_Benefits` fb
    join `Dim_Customer` dc on fb.customer_key = dc.customer_key
    join `Dim_Time` dt on fb.date_key = dt.date_key
    -- where customer_name = 'KEN PREWITT'
group by
    customer_key,
    full_date
order by total_rental desc

SELECT
    st.store_id,
    ad.address as address_name,
    country.country as country_name,
    ct.city as city_name,
    country.country as country_name,
    CONCAT(
        staff.first_name,
        " ",
        staff.last_name
    ) as manager_name
FROM
    sakila.store st
    JOIN sakila.address ad ON st.address_id = ad.address_id
    JOIN sakila.city ct ON ad.city_id = ct.city_id
    JOIN sakila.country country ON ct.country_id = country.country_id
    JOIN sakila.staff staff ON st.manager_staff_id = staff.staff_id