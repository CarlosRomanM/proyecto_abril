-- 1_Verificar la estructura de la tabla
PRAGMA table_info(GCB2022v27_MtCO2_flat);

-- 2_Contar valores nulos o vacíos en cada columna
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Country IS NULL OR Country = '' THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN `ISO 3166-1 alpha-3` IS NULL OR `ISO 3166-1 alpha-3` = '' THEN 1 ELSE 0 END) AS null_iso,
    SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN Total IS NULL OR Total = '' THEN 1 ELSE 0 END) AS null_total,
    SUM(CASE WHEN Coal IS NULL OR Coal = '' THEN 1 ELSE 0 END) AS null_coal,
    SUM(CASE WHEN Oil IS NULL OR Oil = '' THEN 1 ELSE 0 END) AS null_oil,
    SUM(CASE WHEN Gas IS NULL OR Gas = '' THEN 1 ELSE 0 END) AS null_gas,
    SUM(CASE WHEN Cement IS NULL OR Cement = '' THEN 1 ELSE 0 END) AS null_cement,
    SUM(CASE WHEN Flaring IS NULL OR Flaring = '' THEN 1 ELSE 0 END) AS null_flaring,
    SUM(CASE WHEN Other IS NULL OR Other = '' THEN 1 ELSE 0 END) AS null_other,
    SUM(CASE WHEN `Per Capita` IS NULL OR `Per Capita` = '' THEN 1 ELSE 0 END) AS null_per_capita
FROM GCB2022v27_MtCO2_flat;

/* Contamos los valores nulos (NULL) o vacíos ('') en cada columna.
Esto nos ayuda a decidir si eliminamos las filas con valores nulos o las reemplazamos con valores predeterminados.
*/

-- 3_Identificar valores no numéricos en columnas numéricas
SELECT *
FROM GCB2022v27_MtCO2_flat
WHERE NOT Total GLOB '[0-9]*'
   OR NOT Coal GLOB '[0-9]*'
   OR NOT Oil GLOB '[0-9]*'
   OR NOT Gas GLOB '[0-9]*'
   OR NOT Cement GLOB '[0-9]*'
   OR NOT Flaring GLOB '[0-9]*'
   OR NOT Other GLOB '[0-9]*'
   OR NOT `Per Capita` GLOB '[0-9]*';

/* Buscamos filas donde las columnas numéricas contengan valores no válidos (por ejemplo, texto o caracteres especiales).
   Esto nos ayuda a identificar datos que necesitan ser limpiados.
*/

-- 4_Reemplazar valores no numéricos con NULL
UPDATE GCB2022v27_MtCO2_flat
SET Total = NULL WHERE NOT Total GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Coal = NULL WHERE NOT Coal GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Oil = NULL WHERE NOT Oil GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Gas = NULL WHERE NOT Gas GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Cement = NULL WHERE NOT Cement GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Flaring = NULL WHERE NOT Flaring GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET Other = NULL WHERE NOT Other GLOB '[0-9]*';
UPDATE GCB2022v27_MtCO2_flat
SET `Per Capita` = NULL WHERE NOT `Per Capita` GLOB '[0-9]*';

/* Limpiamos las columnas numéricas reemplazando los valores no válidos con NULL.
Esto asegura que las columnas contengan solo datos numéricos válidos.
*/

-- 6_Reemplazar valores nulos con 0 en columnas numéricas
UPDATE GCB2022v27_MtCO2_flat
SET Total = 0 WHERE Total IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Coal = 0 WHERE Coal IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Oil = 0 WHERE Oil IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Gas = 0 WHERE Gas IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Cement = 0 WHERE Cement IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Flaring = 0 WHERE Flaring IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET Other = 0 WHERE Other IS NULL;
UPDATE GCB2022v27_MtCO2_flat
SET `Per Capita` = 0 WHERE `Per Capita` IS NULL;

-- 7_Verificar los datos finales
SELECT *
FROM GCB2022v27_MtCO2_flat
LIMIT 500;

-- 8_Identificar los rangos de años con valores vacíos por país
SELECT 
    Country,
    Year,
    SUM(CASE WHEN Coal IS NULL OR Coal = '' THEN 1 ELSE 0 END) AS empty_coal,
    SUM(CASE WHEN Oil IS NULL OR Oil = '' THEN 1 ELSE 0 END) AS empty_oil,
    SUM(CASE WHEN Gas IS NULL OR Gas = '' THEN 1 ELSE 0 END) AS empty_gas,
    SUM(CASE WHEN Cement IS NULL OR Cement = '' THEN 1 ELSE 0 END) AS empty_cement,
    SUM(CASE WHEN Flaring IS NULL OR Flaring = '' THEN 1 ELSE 0 END) AS empty_flaring,
    SUM(CASE WHEN Other IS NULL OR Other = '' THEN 1 ELSE 0 END) AS empty_other,
    SUM(CASE WHEN `Per Capita` IS NULL OR `Per Capita` = '' THEN 1 ELSE 0 END) AS empty_per_capita
FROM GCB2022v27_MtCO2_flat
GROUP BY Country, Year
ORDER BY Country, Year;

-- 9_Eliminar filas donde todas las columnas relevantes están vacías
DELETE FROM GCB2022v27_MtCO2_flat
WHERE (Coal IS NULL OR Coal = '')
  AND (Oil IS NULL OR Oil = '')
  AND (Gas IS NULL OR Gas = '')
  AND (Cement IS NULL OR Cement = '')
  AND (Flaring IS NULL OR Flaring = '')
  AND (Other IS NULL OR Other = '')
  AND (`Per Capita` IS NULL OR `Per Capita` = '');



-- 10_Eliminar filas de años irrelevantes (1750-1948)
DELETE FROM GCB2022v27_MtCO2_flat
WHERE Year BETWEEN 1750 AND 1948;

-- 11_Verificar los datos después de la limpieza
SELECT *
FROM GCB2022v27_MtCO2_flat
LIMIT 20000;

/* Tenía un conflico en el dataset, ya que me daba problemas porque habia muchas columnas sin valor. 
   He solucioando este conflico sustituyendo estos valores por "0" y eliminando l as que estaban 
   completamente vacías. Una vez, solucionado esto. Me gustaría crear algunas columnas con diferentes 
   operaciones, para que la tabla sea mas funcional ,completa en su análisis y haré diferentes consultas
   para poder profundizar con mas exactitud en el dataset .
*/

-- 12_Crear columnas para el porcentaje de emisiones por Elemento
UPDATE GCB2022v27_MtCO2_flat
SET Coal = (Coal * 100.0) / Total,
    Oil = (Oil * 100.0) / Total,
    Gas = (Gas * 100.0) / Total,
    Cement = (Cement * 100.0) / Total,
    Flaring = (Flaring * 100.0) / Total,
    Other = (Other * 100.0) / Total
WHERE Total > 0;

-- Top 10 países con mayores emisiones totales en 2020
SELECT 
    Country,
    Total
FROM GCB2022v27_MtCO2_flat
WHERE Year = 2020
ORDER BY Total DESC
LIMIT 20;

-- 13_Obtener la lista de países únicos
SELECT DISTINCT Country
FROM GCB2022v27_MtCO2_flat
ORDER BY Country;

-- 14_Contar el número total de países únicos
SELECT COUNT(DISTINCT Country) AS total_countries
FROM GCB2022v27_MtCO2_flat;

-- 15_Crear la tabla de regiones
CREATE TABLE Regions (
    Country TEXT,
    Region TEXT
);

-- 16_Insertar países y sus regiones

INSERT INTO Regions (Country, Region) VALUES ('Afghanistan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Albania', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Algeria', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Andorra', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Angola', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Anguilla', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Antarctica', 'Other');
INSERT INTO Regions (Country, Region) VALUES ('Antigua and Barbuda', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Argentina', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Armenia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Aruba', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Australia', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Austria', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Azerbaijan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Bahamas', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Bahrain', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Bangladesh', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Barbados', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Belarus', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Belgium', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Belize', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Benin', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Bermuda', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Bhutan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Bolivia', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Bonaire, Saint Eustatius and Saba', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Bosnia and Herzegovina', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Botswana', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Brazil', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('British Virgin Islands', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Brunei Darussalam', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Bulgaria', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Burkina Faso', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Burundi', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Cambodia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Cameroon', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Canada', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Cape Verde', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Central African Republic', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Chad', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Chile', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('China', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Christmas Island', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Colombia', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Comoros', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Congo', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Cook Islands', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Costa Rica', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Croatia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Cuba', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Curaçao', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Cyprus', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Czech Republic', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Côte d''Ivoire', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Democratic Republic of the Congo', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Denmark', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Djibouti', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Dominica', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Dominican Republic', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Ecuador', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Egypt', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('El Salvador', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Equatorial Guinea', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Eritrea', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Estonia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Ethiopia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Faeroe Islands', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Fiji', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Finland', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('France', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('French Guiana', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('French Polynesia', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Gabon', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Gambia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Georgia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Germany', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Ghana', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Greece', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Greenland', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Grenada', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Guadeloupe', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Guatemala', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Guinea', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Guinea-Bissau', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Guyana', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Haiti', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Honduras', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Hong Kong', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Hungary', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Iceland', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('India', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Indonesia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Iran', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Iraq', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Ireland', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Israel', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Italy', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Jamaica', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Japan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Jordan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Kazakhstan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Kenya', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Kiribati', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Kosovo', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Kuwait', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Kyrgyzstan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Laos', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Latvia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Lebanon', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Lesotho', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Liberia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Libya', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Liechtenstein', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Lithuania', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Luxembourg', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Macao', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Madagascar', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Malawi', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Malaysia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Maldives', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Mali', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Malta', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Marshall Islands', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Martinique', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Mauritania', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Mauritius', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Mayotte', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Mexico', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Micronesia (Federated States of)', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Moldova', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Mongolia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Montenegro', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Montserrat', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Morocco', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Mozambique', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Myanmar', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Namibia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Nauru', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Nepal', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Netherlands', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('New Caledonia', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('New Zealand', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Nicaragua', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Niger', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Nigeria', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Niue', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('North Korea', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('North Macedonia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Norway', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Occupied Palestinian Territory', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Oman', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Pakistan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Palau', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Panama', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Papua New Guinea', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Paraguay', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Peru', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Philippines', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Poland', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Portugal', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Puerto Rico', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Qatar', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Romania', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Russia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Rwanda', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Saint Kitts and Nevis', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Saint Lucia', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Saint Vincent and the Grenadines', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Samoa', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Saudi Arabia', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Senegal', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Serbia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Seychelles', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Sierra Leone', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Singapore', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Slovakia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Slovenia', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Solomon Islands', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Somalia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('South Africa', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('South Korea', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('South Sudan', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Spain', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Sri Lanka', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Sudan', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Suriname', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Sweden', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Switzerland', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Syria', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Taiwan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Tajikistan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Tanzania', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Thailand', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Timor-Leste', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Togo', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Tonga', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Trinidad and Tobago', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Tunisia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Turkey', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Turkmenistan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Tuvalu', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('USA', 'North America');
INSERT INTO Regions (Country, Region) VALUES ('Uganda', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Ukraine', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('United Arab Emirates', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('United Kingdom', 'Europe');
INSERT INTO Regions (Country, Region) VALUES ('Uruguay', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Uzbekistan', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Vanuatu', 'Oceania');
INSERT INTO Regions (Country, Region) VALUES ('Venezuela', 'South America');
INSERT INTO Regions (Country, Region) VALUES ('Viet Nam', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Yemen', 'Asia');
INSERT INTO Regions (Country, Region) VALUES ('Zambia', 'Africa');
INSERT INTO Regions (Country, Region) VALUES ('Zimbabwe', 'Africa');

-- 17_Verificar la tabla de regiones
SELECT * 
FROM Regions
ORDER BY Region, Country;


-- 18_Unir las tablas y calcular emisiones totales por región
SELECT 
    r.Region,
    SUM(f.Total) AS TotalEmissions
FROM GCB2022v27_MtCO2_flat f
JOIN Regions r ON f.Country = r.Country
GROUP BY r.Region
ORDER BY TotalEmissions DESC;

* Despues de la creación de una nueva tabla para añadir el continente al cual pertenece cada uno de los países de la tabla, 
he podido obserbar que sería mejor poder tener un menor rango de fechas para un mejor análisis mas concreto y actualizado.
*/



-- Verificar los datos antes de eliminar
SELECT DISTINCT Year
FROM GCB2022v27_MtCO2_flat
ORDER BY Year;

-- Eliminar los años entre 1948 y 1990
DELETE FROM GCB2022v27_MtCO2_flat
WHERE Year BETWEEN 1948 AND 1990;

-- Verificar los datos después de eliminar
SELECT DISTINCT Year
FROM GCB2022v27_MtCO2_flat
ORDER BY Year;

-- Verificar los datos de un país específico
SELECT *
FROM GCB2022v27_MtCO2_flat
WHERE Country = 'Afghanistan'
ORDER BY Year;

-- Crear una tabla pivotada con los años como columnas
CREATE TABLE GCB2022v27_MtCO2_pivoted AS
SELECT 
    Country,
    MAX(CASE WHEN Year = 1991 THEN Total END) AS "1991",
    MAX(CASE WHEN Year = 1992 THEN Total END) AS "1992",
    MAX(CASE WHEN Year = 1993 THEN Total END) AS "1993",
    MAX(CASE WHEN Year = 1994 THEN Total END) AS "1994",
    MAX(CASE WHEN Year = 1995 THEN Total END) AS "1995",
    MAX(CASE WHEN Year = 1996 THEN Total END) AS "1996",
    MAX(CASE WHEN Year = 1997 THEN Total END) AS "1997",
    MAX(CASE WHEN Year = 1998 THEN Total END) AS "1998",
    MAX(CASE WHEN Year = 1999 THEN Total END) AS "1999",
    MAX(CASE WHEN Year = 2000 THEN Total END) AS "2000",
    MAX(CASE WHEN Year = 2001 THEN Total END) AS "2001",
    MAX(CASE WHEN Year = 2002 THEN Total END) AS "2002",
    MAX(CASE WHEN Year = 2003 THEN Total END) AS "2003",
    MAX(CASE WHEN Year = 2004 THEN Total END) AS "2004",
    MAX(CASE WHEN Year = 2005 THEN Total END) AS "2005",
    MAX(CASE WHEN Year = 2006 THEN Total END) AS "2006",
    MAX(CASE WHEN Year = 2007 THEN Total END) AS "2007",
    MAX(CASE WHEN Year = 2008 THEN Total END) AS "2008",
    MAX(CASE WHEN Year = 2009 THEN Total END) AS "2009",
    MAX(CASE WHEN Year = 2010 THEN Total END) AS "2010",
    MAX(CASE WHEN Year = 2011 THEN Total END) AS "2011",
    MAX(CASE WHEN Year = 2012 THEN Total END) AS "2012",
    MAX(CASE WHEN Year = 2013 THEN Total END) AS "2013",
    MAX(CASE WHEN Year = 2014 THEN Total END) AS "2014",
    MAX(CASE WHEN Year = 2015 THEN Total END) AS "2015",
    MAX(CASE WHEN Year = 2016 THEN Total END) AS "2016",
    MAX(CASE WHEN Year = 2017 THEN Total END) AS "2017",
    MAX(CASE WHEN Year = 2018 THEN Total END) AS "2018",
    MAX(CASE WHEN Year = 2019 THEN Total END) AS "2019",
    MAX(CASE WHEN Year = 2020 THEN Total END) AS "2020",
    MAX(CASE WHEN Year = 2021 THEN Total END) AS "2021"
FROM GCB2022v27_MtCO2_flat
GROUP BY Country;


-- Verificar la tabla pivotada
SELECT *
FROM GCB2022v27_MtCO2_pivoted
LIMIT 10;

SELECT *
FROM GCB2022v27_MtCO2_pivoted;