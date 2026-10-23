# Servicio Ecosistémico de Polinizadores

Este repositorio forma parte de la iniciativa de monitoreo y análisis del **Instituto Humboldt Colombia** para la evaluación y modelamiento del servicio ecosistémico de polinización en cultivos de importancia agrícola e ecológica.

---

##  Descripción del Proyecto

El objetivo principal es estructurar, analizar y modelar las interacciones entre especies de plantas cultivadas y sus polinizadores (con énfasis en abejas e insectos nativos) en Colombia. A través de este análisis, se evalúa la conectividad ecológica, la distancia potencial de forrajeo de los polinizadores y los patrones de distribución geográfica en el territorio nacional.

---

##  Contenido y Metodología

El proyecto se estructura en cuatro componentes analíticos principales:

1. **Redes de Interacción Planta-Polinizador**
   - Mapeo de relaciones entre cultivos (ej. agraz, aguacate, café, maracuyá, gulupa, tomate, azafrán, etc.) y especies polinizadoras (*Apis mellifera*, *Melipona spp.*, *Xylocopa spp.*, *Bombus spp.*, *Eulaema spp.*, entre otros).
   - Matriz taxonómica basada en datos de la *Iniciativa Colombiana de Polinizadores (Capítulo Abejas - ICPA)*.

2. **Estimación y Cálculo de Distancias de Forrajeo**
   - Estimación de rangos típicos y máximos de vuelo (*Realized typical range* / *Realized maximum range*) basados en métricas morfológicas como la distancia intertegular (ITD - *Intertegular Distance*) y rasgos de socialidad, siguiendo metodologías estandarizadas (Kendall et al., 2022).

3. **Análisis de Redes Bipartitas y Ponderadas**
   - Modelamiento gráfico del grado de conexión, grosor de interacción y distancias para identificar especies clave/clave de soporte en agroecosistemas.

4. **Modelos de Distribución de Especies (SDM)**
   - Mapas de presencia y idoneidad de hábitat a nivel nacional para especies clave de polinizadores (ej. especies del género *Eulaema*).

---

##  Estructura del Repositorio
├── Capas/
│   ├── Capas_Vectoriales/         # Archivos GeoJSON y Shapefiles (Agricultura Familiar, Limites)
│   └── Capas_Raster/              # Coberturas e imágenes GeoTIFF (Hansen treecover2000, lossyear)
├── bases/                         # Matrices taxonómicas y datos de interacción de la ICPA
├── calculo_de_area/               # Scripts para el cálculo de coberturas y buffers de polinización
├── codigos/                       # Scripts y notebooks de análisis (Python / R / GEE)
└── README.md                      # Documentación principal del repositorio
