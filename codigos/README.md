# Módulos de Análisis R y Procesamiento de Datos

Este directorio contiene los scripts de R dedicados al procesamiento de datos taxonómicos, análisis de redes de interacción planta-polinizador y modelamiento espacial del servicio ecosistémico de polinización.

---

##  Descripción de los Archivos

### 1. `Grafo de relaciones.R`
Este script genera las redes e interacciones bipartitas entre cultivos agrícolas y sus especies polinizadoras a partir del archivo de entrada `Abejas_cultivos.csv`.
- **Funcionalidad Básica**: Construye un grafo no dirigido (`igraph` y `ggraph`) diferenciando nodos entre *Plantas* (verde) y *Polinizadores* (naranja) y escalando su tamaño según el grado de conectividad. Exporta el resultado como `grafo_polinizadores_fondo_blanco.png`.
- **Análisis por Distancia**: Incorpora la variable de distancia de vuelo/forrajeo mapeándola en el grosor y color de las aristas (*edges*). Exporta el resultado en `grafo_polinizadores_distancia_distancia.png`.

### 2. `Identificacion de registros SIB.R`
Realiza el cruce de datos taxonómicos del proyecto con la base de datos masiva de biodiversidad del **SiB Colombia / GBIF** (`dwc_co_2024T2.txt`).
- **Procesamiento Taxonómico**: Limpia y separa taxones complejos (ej. nombres con barras `/` o géneros identificados a nivel de `spp.` / `sp.`).
- **Consulta Eficiente**: Utiliza la base de datos de alto rendimiento **DuckDB** para consultar los conteos globales de registros por especie, género o familia tanto para plantas como para polinizadores.
- **Salida**: Genera la tabla consolidada `Abejas_cultivos_con_registros.csv` con los conteos de ocurrencia agregados (`registros_Planta` y `registros_Polinizador`).

### 3. `Mapa de polinizacion.R`
Se encarga del procesamiento geoespacial de los Modelos de Distribución de Especies (SDM) generados en MaxEnt para polinizadores clave (ej. género *Eulaema*).
- **Procesamiento Raster**: Carga, resamplea y alinea las capas raster de presencia/ausencia (`.asc` / `.tif`) usando la librería `terra`.
- **Ajuste Geográfico**: Descarga los límites administrativos de Colombia mediante `geodata` (GADM level 0) para recortar (*crop*) y enmascarar (*mask*) las capas al territorio nacional.
- **Salida Visual**: Genera y guarda un mapa multicapa de presencia/ausencia en formato PNG (`Mapa_Eulaema_Colombia.png`) a 300 DPI.

---

##  Requisitos y Dependencias

Para ejecutar estos scripts se requiere **R (versión 4.0 o superior)** y la instalación de los siguientes paquetes:

```R
install.packages(c(
  "dplyr",
  "stringr",
  "igraph",
  "ggraph",
  "ggplot2",
  "ggrepel",
  "duckdb",
  "terra",
  "geodata"
))
