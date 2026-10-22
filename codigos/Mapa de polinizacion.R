# 1. Cargar las librerías necesarias
library(terra)
library(geodata)

# 2. Cargar los rasters desde tu carpeta de trabajo
archivos <- list.files(path = "C:/Users/walter.garcia/Documents/Polinizacion/Modelos", 
                       pattern = "\\.(asc|tif)$", 
                       full.names = TRUE)

# Cargar cada raster individualmente en una lista
lista_rasters <- lapply(archivos, rast)

# 3. Resamplear (alinear) todos los rasters tomando como referencia el primero
raster_ref <- lista_rasters[[1]]

lista_alineada <- lapply(lista_rasters, function(r) {
  if (!ext(r) == ext(raster_ref) || !all(res(r) == res(raster_ref))) {
    return(resample(r, raster_ref, method = "near"))
  } else {
    return(r)
  }
})

# 4. Apilar los 4 rasters en un solo objeto
rasters_stack <- rast(lista_alineada)

# --- Asignar los nombres limpios de las especies a cada capa ---
# Esto extrae el nombre del archivo sin la ruta ni la extensión
nombres_especies <- gsub("_10_MAXENT.*|\\.asc|\\.tif", "", basename(archivos))
names(rasters_stack) <- nombres_especies

# 5. Obtener el límite de Colombia
colombia <- gadm(country = "COL", level = 0, path = tempdir())

# Asegurar que las proyecciones (CRS) coincidan
if (crs(rasters_stack) != crs(colombia)) {
  colombia <- project(colombia, crs(rasters_stack))
}

# 6. Recortar (crop) y enmascarar (mask) TODAS las capas a la vez
stack_colombia_crop <- crop(rasters_stack, colombia)
stack_colombia_final <- mask(stack_colombia_crop, colombia)

# 7. Graficar las 4 especies por separado en una cuadrícula de 2x2
# Cambiar colores usando nombres o códigos hexadecimales
# El primer color es para '0' (Ausencia) y el segundo para '1' (Presencia)
plot(stack_colombia_final, 
     nc = 2, nr = 2, 
     col = c("#E0E0E0", "#2B83BA")) # Gris claro para 0, Azul intenso para 1



# A. Forzar el cierre de todos los dispositivos gráficos previos que hayan quedado abiertos
while (!is.null(dev.list())) dev.off()

# B. Definir la ruta del archivo
ruta_guardado <- "C:/Users/walter.garcia/Documents/Polinizacion/Modelos/Mapa_Eulaema_Colombia.png"

# C. Abrir el PNG ajustando ligeramente las dimensiones
png(filename = ruta_guardado, 
    width = 10, 
    height = 8, 
    units = "in", 
    res = 300)

# D. Generar el gráfico
plot(stack_colombia_final, 
     nc = 2, nr = 2, 
     col = c("gray90", "forestgreen"))

# E. Cerrar y guardar el archivo
dev.off()
