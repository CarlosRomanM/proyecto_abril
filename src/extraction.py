"""
extraction.py

Módulo para la carga, limpieza y transformación inicial de datos en AgroSmart Decisions.
"""

__author__ = "Carlos Román"
__version__ = "Python 3.13.2"
__email__ = "c.roman.monje@gmail.com"

import os
import pandas as pd

# Crear la carpeta para los datos procesados si no existe
processed_path = "./data/processed/"
os.makedirs(processed_path, exist_ok=True)

# Función para cargar un archivo CSV
def load_data(file_path):
    """
    Carga un archivo CSV y devuelve un DataFrame de pandas.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"El archivo {file_path} no existe.")
    
    df = pd.read_csv(file_path)
    if df.empty:
        raise ValueError(f"El archivo {file_path} está vacío.")
    
    print(f"Archivo {file_path} cargado correctamente con {df.shape[0]} filas y {df.shape[1]} columnas.")
    return df

# Función para limpiar los datos
def clean_data(df):
    """
    Realiza una limpieza básica de los datos:
    - Elimina filas duplicadas.
    - Rellena valores faltantes con un valor predeterminado.
    - Convierte nombres de columnas a minúsculas y elimina espacios.
    """
    print("Iniciando limpieza de datos...")
    df = df.drop_duplicates()  # Eliminar filas duplicadas
    df = df.fillna(0)  # Rellenar valores faltantes con 0
    df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")  # Normalizar nombres de columnas
    print("Limpieza de datos completada.")
    return df

# Función para realizar transformaciones iniciales
def transform_data(df, transformations):
    """
    Aplica transformaciones iniciales al DataFrame.
    - transformations: Diccionario con las transformaciones a aplicar.
    """
    print("Iniciando transformaciones iniciales...")
    for column, func in transformations.items():
        if column in df.columns:
            df[column] = df[column].apply(func)
            print(f"Transformación aplicada a la columna: {column}")
        else:
            print(f"Advertencia: La columna {column} no existe en el DataFrame.")
    print("Transformaciones iniciales completadas.")
    return df

# Cargar y procesar los datasets
try:
    # Dataset 1: efficiency_data.csv
    file_path_efficiency = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv"
    df_efficiency = load_data(file_path_efficiency)
    df_efficiency = clean_data(df_efficiency)

    # Transformar la columna "Area" (por ejemplo, convertir a mayúsculas)
    transformations_efficiency = {
        "area": lambda x: x.upper() if isinstance(x, str) else x
    }
    df_efficiency = transform_data(df_efficiency, transformations_efficiency)

    print("Columnas de efficiency_data:", df_efficiency.columns)

    # Dataset 2: Food_Production.csv
    file_path_food = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/Food_Production.csv"
    if os.path.exists(file_path_food):
        df_food = load_data(file_path_food)
        df_food = clean_data(df_food)
    else:
        print(f"Advertencia: El archivo {file_path_food} no existe. Continuando con los demás datasets.")

    # Dataset 3: Environment_Temperature_change_E_All_Data_NOFLAG.csv
    file_path_temperature = " /Users/kardiahq/Desktop/Project_abril/Agro_Smart/Environment_Temperature_change_E_All_Data_NOFLAG.csv"
    if os.path.exists(file_path_temperature):
        df_temperature = load_data(file_path_temperature)
        df_temperature = clean_data(df_temperature)

        # Transformar columnas de años en filas (si aplica)
        year_columns = [col for col in df_temperature.columns if col.startswith("y")]
        if year_columns:
            df_temperature_long = pd.melt(
                df_temperature,
                id_vars=["area"],  # Mantener las columnas que no son años
                value_vars=year_columns,  # Columnas de años
                var_name="year",  # Nueva columna para los años
                value_name="temperature_change"  # Nueva columna para los valores
            )
            df_temperature = df_temperature_long
    else:
        print(f"Advertencia: El archivo {file_path_temperature} no existe. Continuando con los demás datasets.")

    # Dataset 4: GCB2022v27_MtCO2_flat.csv
    file_path_emissions = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/GCB2022v27_MtCO2_flat.csv"
    if os.path.exists(file_path_emissions):
        df_emissions = load_data(file_path_emissions)
        df_emissions = clean_data(df_emissions)
    else:
        print(f"Advertencia: El archivo {file_path_emissions} no existe. Continuando con los demás datasets.")

    # Guardar los datos procesados
    df_efficiency.to_csv(os.path.join(processed_path, "efficiency_data_cleaned.csv"), index=False)
    if 'df_food' in locals():
        df_food.to_csv(os.path.join(processed_path, "Food_Production_cleaned.csv"), index=False)
    if 'df_temperature' in locals():
        df_temperature.to_csv(os.path.join(processed_path, "Environment_Temperature_change_cleaned.csv"), index=False)
    if 'df_emissions' in locals():
        df_emissions.to_csv(os.path.join(processed_path, "GCB2022v27_MtCO2_flat_cleaned.csv"), index=False)

    print("Todos los datasets han sido limpiados, transformados y guardados correctamente.")

except FileNotFoundError as e:
    print(f"Error: No se encontró el archivo. {e}")
except ValueError as e:
    print(f"Error en los datos: {e}")
except Exception as e:
    print(f"Error al procesar los datasets: {e}")

# Bloque para pruebas
if __name__ == "__main__":
    # Ejemplo de prueba con un archivo específico
    try:
        test_file_path = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv"
        if os.path.exists(test_file_path):
            df = load_data(test_file_path)
            df = clean_data(df)
            print("Primeras filas del DataFrame limpio y transformado:")
            print(df.head())
        else:
            print(f"El archivo de prueba {test_file_path} no existe.")
    except Exception as e:
        print(f"Error durante la prueba: {e}")