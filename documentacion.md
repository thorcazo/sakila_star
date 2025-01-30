# Tabla de hecho: beneficio obtenido por categoría de película y por cada staff (empleado)
En esta tabla de hechos se intenta obtener los beneficios obtenidos por cada empleado separando las categorías para saber qué categorías se han obtenido más beneficio por cada establecimiento

### Qué granularidad tiene?

Se espera para esta tabla de hechos una **granularidad alta** ya que se establece información por cada categoría de película sin mucha más información sobre fechas y precios individuales 

## Investigación las tablas necesarias

Para obtener los datos que necesitamos, tenemos que comenzar a investigar donde se encuentran los datos que necesitamos. En este caso para saber el beneficio de cada **venta/alquiler** necesitamos `payment.amount`  como principal columna de la base de datos. 

He creado este SELECT para ver el resultado: 

```sql
SELECT SUM(p.amount) AS total, c.category_id, c.name AS category_name, s.staff_id
FROM
    payment p
    JOIN staff s ON p.staff_id = s.staff_id
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
GROUP BY
    c.category_id,
    s.staff_id;
```

Según los datos obtenidos vemos que la categoría `Family` es la que más beneficio se ha obtenido de el **staff Mike**, **jon** del otro Staff, **tiene el mismo resultado** en la categoría de mas beneficio.

![Code_W8qm9VzU2z.png](attachment:81519811-cb01-4546-b706-0ea85ff506c8:Code_W8qm9VzU2z.png)

## Comenzando a crear las tablas de dimensiones

Después de realizar la prueba de los datos importantes vamos a crear las tablas de dimensiones necesarias para después realizar la tabla de hechos. Necesitamos en este caso las siguientes tablas dimensionales

- dim_staff: Saber informacion del empleado
- dim_category: Saber el tipo de pelicula genera más ingresos
- dim_store: Conocer la sucursal que genera los ingresos
- dim_date: Nos permitirá ver los ingresos a lo largo del tiempo

---