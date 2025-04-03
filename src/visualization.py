"03_VISUALIZATION"

"""
Visualization.py

Este archivo contiene funciones para generar gráficos basados en los datos transformados del proyecto.
"""

__author__ = "Carlos Román"
__version__ = "Python 3.13.2"
__email__ = "c.roman.monje@gmail.com"

# Importar librerías necesarias
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Configuración global para los gráficos
sns.set(style="whitegrid", palette="muted", font_scale=1.2)

def plot_bar(data, x, y, title, xlabel, ylabel, rotation=0):
    """
    Genera un gráfico de barras.
    """
    plt.figure(figsize=(10, 6))
    sns.barplot(data=data, x=x, y=y)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.xticks(rotation=rotation)
    plt.tight_layout()
    plt.show()

def plot_line(data, x, y, title, xlabel, ylabel):
    """
    Genera un gráfico de líneas.
    """
    plt.figure(figsize=(10, 6))
    sns.lineplot(data=data, x=x, y=y, marker="o")
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.grid()
    plt.tight_layout()
    plt.show()

def plot_scatter(data, x, y, title, xlabel, ylabel):
    """
    Genera un gráfico de dispersión.
    """
    plt.figure(figsize=(10, 6))
    sns.scatterplot(data=data, x=x, y=y)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.grid()
    plt.tight_layout()
    plt.show()

def plot_heatmap(data, title):
    """
    Genera un mapa de calor basado en una matriz de correlación.
    """
    plt.figure(figsize=(10, 8))
    sns.heatmap(data.corr(), annot=True, cmap="coolwarm", fmt=".2f")
    plt.title(title)
    plt.tight_layout()
    plt.show()

def plot_histogram(data, column, title, xlabel, ylabel, bins=10):
    """
    Genera un histograma para una columna específica.
    """
    plt.figure(figsize=(10, 6))
    sns.histplot(data[column], bins=bins, kde=True)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.tight_layout()
    plt.show()

# Bloque para pruebas
if __name__ == "__main__":
    try:
        # Rutas de los datasets transformados
        efficiency_path = "/Users/kardiahq/Desktop/Project_abril/data/processed/eficiencia_alimentaria_transformed.csv"
        temperature_path = "/Users/kardiahq/Desktop/Project_abril/data/processed/temperatura_global_transformed.csv"

        # Cargar datasets
        df_efficiency = pd.read_csv(efficiency_path)
        df_temperature = pd.read_csv(temperature_path)

        # Verificar las columnas de los DataFrames
        print(f"Columnas en df_efficiency: {df_efficiency.columns}")
        print(f"Columnas en df_temperature: {df_temperature.columns}")

        # Renombrar columnas para que coincidan con las esperadas
        df_efficiency.rename(columns={"Area": "Country", "Efficiency": "Efficiency_Metrics"}, inplace=True)

        # Transformar df_temperature: Convertir columnas de años en filas
        year_columns = [col for col in df_temperature.columns if col.startswith("Y")]
        df_temperature_long = pd.melt(
            df_temperature,
            id_vars=["Area"],  # Mantener las columnas que no son años
            value_vars=year_columns,  # Columnas de años
            var_name="Year",  # Nueva columna para los años
            value_name="Temperature_Change"  # Nueva columna para los valores
        )

        # Limpiar la columna "Year" para eliminar el prefijo "Y"
        df_temperature_long["Year"] = df_temperature_long["Year"].str.lstrip("Y").astype(int)

        # Renombrar "Area" a "Country" para que coincida con df_efficiency
        df_temperature_long.rename(columns={"Area": "Country"}, inplace=True)

        # Verificar si las columnas esperadas están presentes en df_efficiency
        required_columns_efficiency = ["Country", "Efficiency_Metrics"]
        missing_columns_efficiency = [col for col in required_columns_efficiency if col not in df_efficiency.columns]

        if missing_columns_efficiency:
            raise ValueError(f"Las siguientes columnas faltan en df_efficiency: {missing_columns_efficiency}")

        # Verificar si las columnas esperadas están presentes en df_temperature_long
        required_columns_temperature = ["Year", "Temperature_Change", "Country"]
        missing_columns_temperature = [col for col in required_columns_temperature if col not in df_temperature_long.columns]

        if missing_columns_temperature:
            raise ValueError(f"Las siguientes columnas faltan en df_temperature: {missing_columns_temperature}")

        # Gráfico de barras: Eficiencia alimentaria por país
        plot_bar(
            data=df_efficiency.nlargest(10, "Efficiency_Metrics"),  # Mostrar solo los 10 países con mayor eficiencia
            x="Country",
            y="Efficiency_Metrics",
            title="Eficiencia Alimentaria por País (Top 10)",
            xlabel="País",
            ylabel="Eficiencia",
            rotation=90  # Rotar las etiquetas del eje X 90 grados
        )

        # Gráfico de líneas: Tendencias de temperatura global
        plot_line(
            data=df_temperature_long,
            x="Year",
            y="Temperature_Change",
            title="Tendencias de Anomalías de Temperatura Global",
            xlabel="Año",
            ylabel="Cambio de Temperatura (°C)"
        )

        # Gráfico de dispersión: Relación entre eficiencia alimentaria y temperatura global
        combined_data = pd.merge(df_efficiency, df_temperature_long, on="Country", how="inner")
        plot_scatter(
            data=combined_data,
            x="Efficiency_Metrics",
            y="Temperature_Change",
            title="Relación entre Eficiencia Alimentaria y Cambio de Temperatura",
            xlabel="Eficiencia Alimentaria",
            ylabel="Cambio de Temperatura (°C)"
        )

        # Mapa de calor: Correlación entre variables
        plot_heatmap(
            data=combined_data,
            title="Mapa de Calor: Correlación entre Variables"
        )

    except FileNotFoundError as e:
        print(f"Error: No se encontró el archivo. {e}")
    except ValueError as e:
        print(f"Error en los datos: {e}")
    except Exception as e:
        print(f"Error al generar los gráficos: {e}")