import pandas as pd


def visualizar_datos(file_dataset):
    return pd.read_csv(file_dataset)

print(visualizar_datos("dim_date.csv").head(10))
