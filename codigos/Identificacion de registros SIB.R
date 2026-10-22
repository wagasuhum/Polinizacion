library(duckdb)
library(dplyr)

# 1. Cargar el archivo CSV
excel_data <- read.csv("Abejas_cultivos.csv", sep = ";")

# 2. Extraer y separar nombres (manejando barras '/' como en Bixa urucurana / Bixa orellana)
extraer_nombres <- function(vec) {
  vec <- vec[!is.na(vec) & vec != ""]
  # Separar valores por la barra /
  unlista <- unlist(strsplit(as.character(vec), "\\s*/\\s*"))
  return(trimws(unlista))
}

plantas <- extraer_nombres(excel_data$Nombre_Cientifico)
polinizadores <- extraer_nombres(excel_data$Especies_polinizadoras)

# Combinar ambas listas de forma única
nombres_unicos <- unique(c(plantas, polinizadores))
nombres_unicos <- nombres_unicos[nombres_unicos != ""]

# 3. Conectar a DuckDB en disco para procesar
con <- dbConnect(duckdb(), dbdir = "temp_db.duckdb")

contar_especie <- function(nombre) {
  if (is.na(nombre) || nombre == "" || nombre == "NA") return(0)
  
  # Si el nombre viene compuesto por '/', tomar el primer nombre para la búsqueda
  nombre_eval <- unlist(strsplit(nombre, "\\s*/\\s*"))[1]
  nombre_limpio <- trimws(gsub("spp\\.|sp\\.", "", nombre_eval))
  
  if (grepl("spp\\.|sp\\.", nombre_eval)) {
    q <- sprintf("
      SELECT COUNT(*) 
      FROM read_csv_auto('C:/Users/walter.garcia/Downloads/dwc_co_2024T2/dwc_co_2024T2.txt', delim = '\t', ignore_errors = true)
      WHERE genus = '%s'
    ", nombre_limpio)
  } else {
    q <- sprintf("
      SELECT COUNT(*) 
      FROM read_csv_auto('C:/Users/walter.garcia/Downloads/dwc_co_2024T2/dwc_co_2024T2.txt', delim = '\t', ignore_errors = true)
      WHERE scientificName LIKE '%s%%' 
         OR family = '%s'
    ", nombre_limpio, nombre_limpio)
  }
  
  res <- dbGetQuery(con, q)
  return(as.numeric(res[1,1]))
}

# 4. Obtener el conteo para todos los taxones (Plantas y Polinizadores)
df_conteos <- data.frame(
  nombre_original = nombres_unicos,
  n_registros = sapply(nombres_unicos, contar_especie)
)

dbDisconnect(con, shutdown = TRUE)
if (file.exists("temp_db.duckdb")) file.remove("temp_db.duckdb")

# 5. Cruzar correctamente con las columnas de tu tabla
# Para 'Nombre_Cientifico' (Plantas):
excel_data <- excel_data %>%
  left_join(df_conteos, by = c("Nombre_Cientifico" = "nombre_original")) %>%
  rename(registros_Planta = n_registros)

# Para 'Especies_polinizadoras' (Polinizadores):
excel_data <- excel_data %>%
  left_join(df_conteos, by = c("Especies_polinizadoras" = "nombre_original")) %>%
  rename(registros_Polinizador = n_registros)

# Reemplazar NAs por 0
excel_data$registros_Planta[is.na(excel_data$registros_Planta)] <- 0
excel_data$registros_Polinizador[is.na(excel_data$registros_Polinizador)] <- 0

# 6. Guardar la tabla final
write.csv2(excel_data, "Abejas_cultivos_con_registros.csv", row.names = FALSE)
print("¡Completado! Ahora se incluyen los conteos de ambas columnas.")
