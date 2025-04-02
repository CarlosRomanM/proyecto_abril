"""
Transformation.py

En esta sección, realizaremos la transformación de los datos.
"""

__author__ = "Carlos Román"
__version__ = "Python 3.13.2"
__email__ = "c.roman.monje@gmail.com"



"02_TRANSFORM"



# Función para transformar un dataset
def transform_data(dataset_name, data):
    print(f"\n--- Transformando dataset: {dataset_name} ---")
    try:
        # Reemplazar valores "[NONE]" por NaN
        data.replace("[NONE]", pd.NA, inplace=True)

        # Convertir columnas numéricas a tipo float (si aplica)
        numeric_columns = ["Total", "Coal", "Oil", "Gas", "Cement", "Flaring", "Other", "Per Capita"]
        for col in numeric_columns:
            if col in data.columns:
                data[col] = pd.to_numeric(data[col], errors="coerce")

        # Verificar y eliminar duplicados
        print(f"Duplicados antes de eliminar: {data.duplicated().sum()}")
        data.drop_duplicates(inplace=True)

        # Crear una nueva columna (opcional): Porcentaje de emisiones de carbón respecto al total
        if "Coal" in data.columns and "Total" in data.columns:
            data["Coal_Percentage"] = (data["Coal"] / data["Total"]) * 100

        # Filtrar datos relevantes (opcional): Por ejemplo, años recientes
        if "Year" in data.columns:
            data = data[data["Year"] >= 2000]
            print(f"Transformación completada para el dataset '{dataset_name}'.")
        return data
    except Exception as e:
        print(f"Error al transformar el dataset '{dataset_name}': {e}")
        return None

# Aplicar la transformación a todos los datasets cargados
transformed_data = {}
for dataset_name, data in extracted_data.items():
    if data is not None:
        transformed_data[dataset_name] = transform_data(dataset_name, data)

# Verificar los resultados de la transformación
for dataset_name, data in transformed_data.items():
    if data is not None:
        print(f"\n--- Dataset transformado: {dataset_name} ---")
        print(data.head())
        print(f"Dimensiones después de la transformación: {data.shape}")

if __name__ == "__main__":
    # Solo se ejecuta si este archivo es ejecutado directamente
    df = load_data("/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv")
    df = clean_data(df)
    print("Primeras filas del DataFrame limpio:")
    print(df.head())
