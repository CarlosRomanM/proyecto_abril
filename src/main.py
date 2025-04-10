# filepath: src/main.py

from extraction import load_data, clean_data, transform_data
from visualization import plot_bar, plot_line, plot_scatter, plot_heatmap

def main():
    print("Iniciando el pipeline del proyecto...")

    # Paso 1: Extraer, transformar y cargar datos (ETL)
    print("Ejecutando ETL...")
    try:
        # Ruta del archivo de datos
        file_path = "/Users/kardiahq/Desktop/Project_abril/Agro_Smart/efficiency_data.csv"

        # Extraer y limpiar datos
        raw_data = load_data(file_path)  # Cargar datos
        processed_data = clean_data(raw_data)  # Limpiar datos

        # Transformar datos (ejemplo: convertir columna "area" a mayúsculas)
        transformations = {"area": lambda x: x.upper() if isinstance(x, str) else x}
        processed_data = transform_data(processed_data, transformations)

        print("Datos procesados correctamente.")
    except Exception as e:
        print(f"Error durante el proceso ETL: {e}")
        return

    # Paso 2: Generar gráficos y análisis exploratorio
    print("Generando gráficos y análisis exploratorio...")
    try:
        # Gráfico de barras: Top 10 países por eficiencia
        plot_bar(
            data=processed_data.nlargest(10, "efficiency_metrics"),  # Ajusta el nombre de la columna según tus datos
            x="area",  # Ajusta el nombre de la columna según tus datos
            y="efficiency_metrics",  # Ajusta el nombre de la columna según tus datos
            title="Eficiencia Alimentaria por País (Top 10)",
            xlabel="País",
            ylabel="Eficiencia",
            rotation=90
        )

        # Gráfico de líneas: Tendencias de temperatura global (si tienes datos de temperatura)
        # Aquí puedes integrar otro dataset si es necesario.

        # Gráfico de dispersión: Relación entre eficiencia y otra métrica (si aplica)
        # Aquí puedes integrar otro dataset si es necesario.

        # Mapa de calor: Correlación entre variables
        plot_heatmap(
            data=processed_data,
            title="Mapa de Calor: Correlación entre Variables"
        )

    except Exception as e:
        print(f"Error al generar gráficos: {e}")
        return

    print("Pipeline completado.")

# Punto de entrada del script
if __name__ == "__main__":
    main()