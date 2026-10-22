# 1. Cargar librerías necesarias
library(dplyr)
library(stringr)
library(igraph)
library(ggraph)
library(ggplot2)
library(ggrepel)

# 2. Cargar los datos desde el archivo CSV
datos <- read.csv("Abejas_cultivos.csv", sep = ";")

# 3. Procesar y limpiar las interacciones
interacciones <- datos %>%
  transmute(
    planta = str_squish(as.character(Nombre_Comun)),
    polinizador = str_squish(as.character(`Especies_polinizadoras`)),
    grupo = str_squish(as.character(`Grupo_de_Polinizador`))
  ) %>%
  filter(
    !is.na(planta),
    !is.na(polinizador),
    planta != "",
    polinizador != ""
  ) %>%
  distinct(planta, polinizador, .keep_all = TRUE)

# 4. Crear la tabla de nodos con sus atributos (Planta / Polinizador)
nodos <- bind_rows(
  interacciones %>%
    distinct(name = planta) %>%
    mutate(tipo = "Planta"),
  
  interacciones %>%
    distinct(name = polinizador) %>%
    mutate(tipo = "Polinizador")
) %>%
  distinct(name, .keep_all = TRUE)

# 5. Crear la tabla de aristas (conexiones)
aristas <- interacciones %>%
  select(
    from = planta,
    to = polinizador
  )

# 6. CREAR EL OBJETO DEL GRAFO (¡Esto era lo que faltaba!)
g <- graph_from_data_frame(d = aristas, vertices = nodos, directed = FALSE)

# Definir el tipo para análisis bipartitos en igraph (opcional pero útil)
V(g)$type <- V(g)$tipo == "Polinizador"

# 7. Configurar la visualización del grafo con ggraph
set.seed(123)

p <- ggraph(g, layout = "fr") +
  
  # Aristas (conexiones) con un gris suave
  geom_edge_link(
    color = "gray70",
    alpha = 0.4,
    linewidth = 0.4
  ) +
  
  # Nodos con bordes negros para contraste en fondo blanco
  geom_node_point(
    aes(
      fill = tipo,
      size = degree(g)
    ),
    shape = 21,
    color = "black",
    alpha = 0.9
  ) +
  
  # Etiquetas de los nombres en color negro
  geom_node_text(
    aes(label = name),
    repel = TRUE,
    size = 3,
    color = "black",
    alpha = 0.9
  ) +
  
  # Colores personalizados para plantas y polinizadores
  scale_fill_manual(
    values = c(
      "Planta" = "#2E7D32",
      "Polinizador" = "#E67E22"
    ),
    name = "Tipo: "
  ) +
  
  # Escala de tamaño basada en el número de conexiones (grado)
  scale_size_continuous(
    range = c(3, 8),
    name = "Conexiones: "
  ) +
  
  # Tema visual limpio con fondo blanco
  theme_void() + 
  theme(
    plot.background = element_rect(fill = "white", color = "white"),
    panel.background = element_rect(fill = "white", color = NA),
    legend.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(color = "black"),
    legend.title = element_text(color = "black", face = "bold"),
    legend.position = "bottom",
    legend.box = "horizontal",
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )

# 8. Guardar la imagen final con fondo blanco nítido
ggsave("grafo_polinizadores_fondo_blanco.png", plot = p, width = 11, height = 10, dpi = 300, bg = "white")



# con distancias ----------------------------------------------------------

# 1. Cargar librerías necesarias
library(dplyr)
library(stringr)
library(igraph)
library(ggraph)
library(ggplot2)
library(ggrepel)

# 2. Cargar los datos desde el archivo CSV
datos <- read.csv("Abejas_cultivos.csv", sep = ";")

# 3. Procesar, limpiar y convertir la distancia a numérico
interacciones <- datos %>%
  transmute(
    planta = str_squish(as.character(Nombre_Comun)),
    polinizador = str_squish(as.character(`Especies_polinizadoras`)),
    grupo = str_squish(as.character(`Grupo_de_Polinizador`)),
    # Convertimos la distancia cambiando la coma por punto y pasándola a número
    distancia = as.numeric(gsub(",", ".", as.character(Distancia)))
  ) %>%
  filter(
    !is.na(planta),
    !is.na(polinizador),
    planta != "",
    polinizador != ""
  ) %>%
  distinct(planta, polinizador, .keep_all = TRUE)

# 4. Crear la tabla de nodos con sus atributos
nodos <- bind_rows(
  interacciones %>%
    distinct(name = planta) %>%
    mutate(tipo = "Planta"),
  
  interacciones %>%
    distinct(name = polinizador) %>%
    mutate(tipo = "Polinizador")
) %>%
  distinct(name, .keep_all = TRUE)

# 5. Crear la tabla de aristas incluyendo la columna distancia
aristas <- interacciones %>%
  select(
    from = planta,
    to = polinizador,
    distancia
  )

# 6. Crear el objeto del grafo con igraph
g <- graph_from_data_frame(d = aristas, vertices = nodos, directed = FALSE)

# Definir el tipo para análisis bipartitos
V(g)$type <- V(g)$tipo == "Polinizador"

# 7. Configurar la visualización del grafo con ggraph
set.seed(123)

# 7. Configurar la visualización del grafo con ggraph
set.seed(123)

p <- ggraph(g, layout = "fr") +
  
  # LAS LÍNEAS CAMBIAN DE GROSOR Y COLOR SEGÚN LA DISTANCIA
  geom_edge_link(
    aes(
      edge_width = distancia, 
      edge_color = distancia
    ),
    alpha = 0.8 # Mayor opacidad para que se distingan bien
  ) +
  
  # Controlamos el grosor mínimo y máximo de las líneas
  scale_edge_width_continuous(
    range = c(0.4, 2.5), # Líneas más gruesas
    name = "Distancia (Grosor)"
  ) +
  
  # Creamos un degradado de color (desde un gris claro hasta un azul oscuro o verde)
  scale_edge_color_gradient(
    low = "gray80", 
    high = "#1F618D", # Un azul elegante (puedes cambiarlo por el color que prefieras)
    name = "Distancia (Color)"
  ) +
  
  # Nodos con bordes negros para contraste en fondo blanco
  geom_node_point(
    aes(
      fill = tipo,
      size = degree(g)
    ),
    shape = 21,
    color = "black",
    alpha = 0.9
  ) +
  
  # Etiquetas de los nombres en color negro
  geom_node_text(
    aes(label = name),
    repel = TRUE,
    size = 3,
    color = "black",
    alpha = 0.9
  ) +
  
  # Colores personalizados para plantas y polinizadores
  scale_fill_manual(
    values = c(
      "Planta" = "#2E7D32",
      "Polinizador" = "#E67E22"
    ),
    name = "Tipo: "
  ) +
  
  # Escala de tamaño basada en el número de conexiones (grado)
  scale_size_continuous(
    range = c(3, 8),
    name = "Conexiones: "
  ) +
  
  # Tema visual limpio con fondo blanco
  theme_void() + 
  theme(
    plot.background = element_rect(fill = "white", color = "white"),
    panel.background = element_rect(fill = "white", color = NA),
    legend.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(color = "black"),
    legend.title = element_text(color = "black", face = "bold"),
    legend.position = "bottom",
    legend.box = "horizontal",
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )
# 8. Guardar la imagen final
ggsave("grafo_polinizadores_distancia_distancia.png", plot = p, width = 11, height = 10, dpi = 300, bg = "white")

