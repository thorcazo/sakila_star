import pandas as pd
from datetime import datetime, timedelta

from insert_data_dimtime import insert_dimtime

# 📌 Parámetros: rango de fechas
start_date = "2000-01-01"  # Fecha de inicio
end_date = "2030-12-31"  # Fecha de fin

# 📌 Generar rango de fechas
dates = pd.date_range(start=start_date, end=end_date)

# 📌 Crear DataFrame base
dim_date = pd.DataFrame(
    {
        "full_date": dates,  # Fecha completa (YYYY-MM-DD)
        "date_key": dates.strftime("%Y%m%d").astype(int),  # Clave de fecha (AAAAMMDD)
        "year": dates.year,  # Año
        "quarter": dates.quarter,  # Trimestre (1-4)
        "month": dates.month,  # Número del mes (1-12)
        "month_name": dates.strftime("%B"),  # Nombre del mes (January, February, ...)
        "week_of_year": dates.isocalendar().week,  # Semana del año (1-52)
        "day_of_week": dates.dayofweek + 1,  # Día de la semana (1=Monday, 7=Sunday)
        "day_name": dates.strftime("%A"),  # Nombre del día (Monday, Tuesday, ...)
        "day_of_month": dates.day,  # Día del mes (1-31)
        "is_weekend": dates.weekday.isin([5, 6]).astype(
            int
        ),  # 1 si es fin de semana, 0 si no
        "is_holiday": 0,  # Inicialmente, ningún día es festivo
    }
)

# 📌 Agregar columna para el trimestre con formato "Qx"
dim_date["quarter_name"] = "Q" + dim_date["quarter"].astype(str)

# 📌 Marcar el último día del mes
dim_date["is_last_day_of_month"] = (
    dim_date["full_date"] + pd.offsets.MonthEnd(0) == dim_date["full_date"]
).astype(int)

# 📌 Agregar columna para el año fiscal (Ejemplo: año fiscal comienza en julio)
dim_date["fiscal_year"] = dim_date["year"]
dim_date.loc[dim_date["month"] >= 7, "fiscal_year"] += 1  # Año fiscal avanza en julio

# 📌 Opcional: marcar días festivos (puedes personalizar este calendario)
holidays = [
    "2000-01-01",
    "2000-12-25",
    "2025-01-01",
    "2025-12-25",
]  # Ajustar según necesidades
dim_date["is_holiday"] = (
    dim_date["full_date"].isin(pd.to_datetime(holidays)).astype(int)
)

# 📌 Guardar como CSV (para futuras referencias)
dim_date.to_csv("dim_date.csv", index=False)
print("✅ Dimensión Fecha guardada en 'dim_date.csv'")


# 📌 Opcional: Insertar en MySQ
# insert_dimtime(dim_date)
