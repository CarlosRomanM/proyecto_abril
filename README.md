# Proyecto I - EDA / ETL
Proyecto "La Huella Ambiental de la Producción de Alimentos: ¿Un Desafío Global?"

## INTRODUCCIÓN

Con la creciente esperanza de vida y el rápido aumento de la población mundial, cada vez es más difícil para la humanidad satisfacer sus necesidades nutricionales. La expansión ineficiente de la producción de alimentos está teniendo un impacto negativo notable en el planeta. La deforestación, el aumento de la ganadería intensiva y el uso excesivo de fertilizantes, todos relacionados con la producción de alimentos, son los principales factores causales detrás del aumento de las emisiones de gases de efecto invernadero. Los datos que utilizaremos provienen de la ONU para la Alimentación y la Agricultura (FAOSTAT), una fuente confiable que recopila información global sobre la producción de alimentos y los recursos necesarios para ella. Con base en estos datos, nos proponemos analizar cómo ha evolucionado la producción de alimentos y su relación con el aumento de las temperaturas. Este análisis contribuirá a aumentar la conciencia pública sobre el problema y fomentará un enfoque más reflexivo y responsable al tomar decisiones.


## Descripción

Este proyecto tiene como objetivo analizar los cambios de temperatura global a lo largo de los años, su impacto en la producción alimentaria y la eficiencia en el uso de recursos. A través de un enfoque basado en datos, se identifican patrones clave, se destacan los países más afectados y se proponen recomendaciones para mitigar los efectos del cambio climático y mejorar la sostenibilidad agrícola.


## Estructura del Proyecto

El proyecto está organizado en las siguientes etapas:

1. **Extracción, Transformación y Carga de Datos (ETL)**:
   - Limpieza y transformación de los datos de temperatura, producción alimentaria y eficiencia.
   - Archivos clave: `extraction.py`.

2. **Análisis Exploratorio de Datos (EDA)**:
   - Visualización de patrones y tendencias en los datos.
   - Archivos clave: `visualization.py`.

3. **Resultados y Conclusiones**:
   - Identificación de los países con mayor y menor aumento de temperatura.
   - Análisis de la relación entre temperatura, producción alimentaria y eficiencia.
   - Archivo clave: `Pro1_Abril.ipynb`.

4. **Visualizaciones**:
   - Gráficos generados para representar los resultados.
   - Carpeta: `visualizations/`.
     
5. **Dashboards**:
   - Gifs de los dashboards creados para el análisis de los datos.
   - - Carpeta: `dashboards/`.
     



### PREGUNTAS QUE QUEREMOS RESOLVER PARA ESTE PROYECTO


1. ¿Qué países destacan por ser más eficientes o menos eficientes en la satisfacción de sus necesidades alimentarias?
   
2. ¿Cuáles son los alimentos más consumidos, tanto a nivel global como por país, y cómo contribuyen al impacto ambiental en términos de emisiones de carbono?

   
3. ¿Cuál es la relación entre el aumento de la temperatura global y las tendencias de emisiones agrícolas?



### Conclusiones:

- Conclusiones individuales de cada una de las preguntas a resolver.
- Conclusión Final.




### DATASET

He realizado el conjunto de datos de Estadísticas Globales de Alimentación y Agricultura .
Aunque el conjunto de datos en Kaggle se encuentra bien estructurado, decidí realizar un preprocesamiento adicional para asegurarnos de que los datos sean consistentes y adecuados para nuestro análisis. 
En el proceso de extracción verifiqué que los datasets estubieran bien cargados, validando que los archivos no estubieran vacios y mostrando información básica sobre los datasets.
En el apartado de transformacíon de los datos, el proceso fue ordenado. Empezacé por eleminar duplicados, remplazar valores nulos y normalizar nombres en columnas ( eliminando espacios, nombres de columnas a minúsculas ). Seguidamente aplicamos funciones a columnas específicas,etc. Finalmente acabamos el proceso por el guardado de datos procesados y Garantizar que el script sea robusto y no se detenga ante problemas menores.
Debido a la amplia gama de información que contenía el conjunto de datos original en Kaggle, decidimos enfocarnos en los datos más relevantes para abordar nuestras preguntas de investigación.

**DATASETS EMPLEADOS**
- efficiency_data.csv
- Food_Production.csv
- Environment_Temperature_change_E_All_Data_NOFLAG.csv
- GCB2022v27_MtCO2_flat.csv


## Instalación

Sigue estos pasos para ejecutar el proyecto en tu máquina local:

1. Clona el repositorio:
   ```bash
   git clone https://github.com/CarlosRomanM/proyecto_abril.git

2. Navega al directorio del proyecto:
   cd proyecto_abril

3. Instala las dependencias necesarias:
   pip install -r requirements.txt

4. Ejecuta los scripts o notebooks según sea necesario.
   
Instrucciones para ejecutar el proyecto.

```markdown
   Ejecuta el archivo principal para procesar los datos:
   ```bash
   python src/main.py


## Visualizaciones

El proyecto incluye gráficos para ilustrar los resultados, como:
- **Top 10 años con mayor aumento de temperatura**.
- **Top 10 años con menor aumento de temperatura**.
- **Top 5 países con mayor aumento de temperatura**.
- **Top 10 países con menor aumento de temperatura**.

Los gráficos están disponibles en la carpeta `visualizations/`.


## Contacto

Si tienes preguntas o sugerencias, no dudes en contactarme:

- **Autor**: Carlos Román
- **Email**: c.roman.monje@gmail.com
- **GitHub**: [CarlosRomanM](https://github.com/CarlosRomanM)
--**Tableau**:https://public.tableau.com/app/profile/carlos.roman4629/viz/LaHuellaAmbientaldelaProduccindeAlimentosUnDesafoGlobal/Historia12?publish=yes






