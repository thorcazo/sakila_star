# 📌 Opcional: Insertar en MySQL
import mysql.connector


def insert_dimtime(dim_date):
    try:
        conn = mysql.connector.connect(
            host="localhost", user="root", password="1234", database="sakila"
        )
        cursor = conn.cursor()

        # Crear tabla si no existe
        create_table_query = """
        CREATE TABLE IF NOT EXISTS DimTime (
            date_key INT PRIMARY KEY,
            full_date DATE,
            year INT,
            quarter INT,
            quarter_name VARCHAR(5),
            month INT,
            month_name VARCHAR(15),
            week_of_year INT,
            day_of_week INT,
            day_name VARCHAR(15),
            day_of_month INT,
            is_weekend BOOLEAN,
            is_holiday BOOLEAN,
            is_last_day_of_month BOOLEAN,
            fiscal_year INT
        );
        """
        cursor.execute(create_table_query)
        conn.commit()

        # Insertar datos en la tabla DimTime
        insert_query = """
        INSERT INTO DimTime (date_key, full_date, year, quarter, quarter_name, month, month_name, 
                            week_of_year, day_of_week, day_name, day_of_month, is_weekend, 
                            is_holiday, is_last_day_of_month, fiscal_year)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.executemany(insert_query, dim_date.values.tolist())
        conn.commit()

        print("✅ Datos insertados en la tabla DimTime en MySQL")

    except mysql.connector.Error as e:
        print(f"⚠️ Error en MySQL: {e}")

    finally:
        cursor.close()
        conn.close()
