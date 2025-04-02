"""
extraction.py

Módulo para la carga y limpieza de datos en AgroSmart Decisions.
"""

__author__ = "Carlos Román"
__version__ = "Python 3.13.2"
__email__ = "c.roman.monje@gmail.com"


"01_EXTRACT/LOAD"


import os
import pandas as pd

# Crear la carpeta para los datos procesados si no existe
processed_path = "./data/processed/"
os.makedirs(processed_path, exist_ok=True)

# Cargar los datasets
try:
    # Dataset 1: GCB2022v27_MtCO2_flat_transformed.csv
    file_path_emissions = "/Users/kardiahq/Desktop/Project_abril/data/processed/GCB2022v27_MtCO2_flat_transformed.csv"
    df_emissions = pd.read_csv(file_path_emissions)
    print(f"Dataset de emisiones cargado correctamente: {file_path_emissions}")

    # Dataset 2: GCB2022v27_sources_flat_transformed.csv
    file_path_sources = "/Users/kardiahq/Desktop/Project_abril/data/processed/GCB2022v27_sources_flat_transformed.csv"
    df_sources = pd.read_csv(file_path_sources)
    print(f"Dataset de fuentes de emisiones cargado correctamente: {file_path_sources}")

    # Dataset 3: GCB2022v27_percapita_flat_transformed.csv
    file_path_percapita = "/Users/kardiahq/Desktop/Project_abril/data/processed/GCB2022v27_percapita_flat_transformed.csv"
    df_percapita = pd.read_csv(file_path_percapita)
    print(f"Dataset de emisiones per cápita cargado correctamente: {file_path_percapita}")

    # Dataset 4: efficiency_data.csv
    file_path_efficiency = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv"
    df_efficiency = pd.read_csv(file_path_efficiency)
    print(f"Dataset de eficiencia cargado correctamente: {file_path_efficiency}")

    # Dataset 5: market_researcher_dataset_transformed.csv
    file_path_market = "/Users/kardiahq/Desktop/Project_abril/data/processed/market_researcher_dataset_transformed.csv"
    df_market = pd.read_csv(file_path_market)
    print(f"Dataset de análisis de mercado cargado correctamente: {file_path_market}")

except FileNotFoundError as e:
    print(f"Error: No se encontró el archivo. {e}")
except Exception as e:
    print(f"Error al cargar los datasets: {e}")

if __name__ == "__main__":
    # Solo se ejecuta si este archivo es ejecutado directamente
    df = load_data("/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv")
    df = clean_data(df)
    print("Primeras filas del DataFrame limpio:")
    print(df.head())