# Sakila Modelo estrella - Tabla de Hechos

## Descripción
Este proyecto implementa un **modelo estrella** basado en la base de datos **Sakila**, con el objetivo de estructurar los datos para un análisis eficiente en un entorno de Big Data.

La tabla de **hechos** centraliza la información de los beneficios obtenidos por alquiler de películas, permitiendo analizar los datos a lo largo del tiempo, por categorías y por películas específicas.

## Tabla de Hechos: `Fact_Benefits`
La tabla `Fact_Benefits` almacena métricas agregadas sobre los alquileres de películas en Sakila, incluyendo:

- **date_key**: Fecha en la que se realizó la renta (relación con `Dim_Time`).
- **category_key**: Categoría de la película (relación con `Dim_Category`).
- **film_key**: Película alquilada (relación con `Dim_Film`).
- **total_rental**: Número total de veces que la película ha sido alquilada en una fecha y categoría específica.
- **total_revenue**: Beneficio total generado por los alquileres en la combinación de tiempo, categoría y película.

Esta estructura permite realizar análisis temporales, comparaciones entre categorías de películas y evaluar el rendimiento de cada film en términos de ingresos generados.

## Ubicación del Código
El código SQL utilizado para definir y poblar la tabla de hechos se encuentra en el directorio `sql/`, organizado de la siguiente manera:

- `1.tabla_dim_hechos.sql`: Creación de la tabla de hechos y sus relaciones con las dimensiones.
- `2.inserts_cargar_datos.sql`: Inserciones de datos desde la base de datos original de Sakila.
- `3.validaciones_consultas.sql`: Consultas para verificar la integridad y funcionalidad del modelo.

## Más Información
Para más detalles sobre la práctica y la documentación completa del modelo estrella, consulta el archivo:

📂 **`docs/documentacion.md`**

---
👩‍💻 Autor: **David Pastor**
✍️ Práctica realizada para: el **Curso de Especialización en Big Data**
🏫 Instituto: **Ingeniero de la Cierva (Murcia)**
📚 Asignatura: **Sistemas de Big Data**

