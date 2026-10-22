# ==============================================================================
# SCRIPT DE ESTIMACIÓN DE RANGO DE FORRAJEO CON POLLIMETRY
# ==============================================================================

# 1. Configuración de variables de entorno para Rtools/rstan en Windows
# ------------------------------------------------------------------------------
# Asegura que R identifique las herramientas C++ necesarias en tu sesión.
if (file.exists("~/.Renviron")) {
  readRenviron("~/.Renviron")
}

# 2. Carga de librerías necesarias
# ------------------------------------------------------------------------------
library(rstan)
library(pollimetry)

# Configuración opcional para acelerar cálculos con rstan
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# 3. Creación del conjunto de datos de entrada
# ------------------------------------------------------------------------------
# Importante:
# - 'ITD' en milímetros (mm),  intertegular distance (ITD).
# - 'species' con formato 'Genero_especie'.
# - 'sociality' opciones: "Highly Eusocial", "Primitively Eusocial", "Solitary".

ITD=c(2.7,3.3,4.3,3.2,1.5,3.3,2.2)
species=c("Apis_mellifera","Bombus_melaleucus","Bombus_atratus", "Thygater_sp", "Syrphidae", "Bombini", "Melipona_sp")
sociality=c("Highly Eusocial","Primitively Eusocial","Primitively Eusocial", "Solitary","Solitary","Primitively Eusocial", "Highly Eusocial")
example.data <- data.frame(ITD,species,sociality)

ITD=c(3.34,2.0,1.5,1.1,1.2,2.7,3.1)
species=c("Bombus rubicundus","Scaptotrigona_spp","Trigona_spinipes", "Plebeia_spp.", "Nannotrigona_spp.", "Peponapis_limitaris", "Melipona_eburnea")
sociality=c("Primitively Eusocial","Highly Eusocial","Highly Eusocial", "Highly Eusocial","Highly Eusocial","Solitary", "Highly Eusocial")
example.data <- data.frame(ITD,species,sociality)

ITD=c(1.2,1.4,2.9,4.4,2.8,2.7,4.0)
species=c("Partamona_spp.","Andrena_spp.","Anthophora_urbana", "Bombus hortulanus", "Centris_atripes", "Colletes_acutus", "Epicharis_spp")
sociality=c("Highly Eusocial","Solitary","Solitary", "Solitary","Solitary","Solitary", "Solitary")
example.data <- data.frame(ITD,species,sociality)

ITD=c(3.3,7.7,4.1,4.4,1.4,2.8,3.5)
species=c("Euglossa_spp","Eulaema_nigrita","Eulaema_cingulata", "Eulaema_polychroma", "Geotrigona_spp.", "Halictus_scabiosae", "Melipona_subnitida")
sociality=c("Solitary","Solitary","Solitary", "Solitary","Highly Eusocial","Highly Eusocial", "Solitary")
example.data <- data.frame(ITD,species,sociality)


ITD=c(1.07,7.93,7.0,7.5,2.4,1.9)
species=c("Tetragonisca_angustula","Xylocopa_frontalis","Xylocopa_lachnea", "Xylocopa_tranquebarica", "Trigona_silvestriana", "Trigona_williana")
sociality=c("Highly Eusocial","Solitary","Solitary", "Solitary","Highly Eusocial","Highly Eusocial")
example.data <- data.frame(ITD,species,sociality)

# 4. Cálculo del Rango de Forrajeo (Modelo Bayesisano Completo)
# ------------------------------------------------------------------------------
resultados <- foraging.range(example.data,random.effects = "full",
                             measure.type = "realized")

# 5. Visualizar los resultados en la consola
# ------------------------------------------------------------------------------
print(resultados)




a=unique(bee_sex$data$Species)
a

View(data.frame(Especie = a))
