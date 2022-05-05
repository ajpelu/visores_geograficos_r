library(tidyverse)
library(here)
library(raster)
library(sf)
library(leaflet)


sn <- st_read(here::here("data/sn_enp.shp"), quiet = TRUE)
sn <- st_transform(sn, 4326)

mapita <- leaflet() %>% 
  # Añadir capas 
  addTiles() %>% # Open Street map
  # Añadir otras capas 
  addMarkers(lng=-3.311572, lat=37.053434, popup="Mulhacen") %>% 
  addPolygons(data = sn,
            group= 'Natural Park',
            fillOpacity = 0, 
            color = "blue") 

mapita_final <-
  mapita %>% 
  addProviderTiles("Esri.WorldImagery", 
                   group = "Satellite (ESRI)") %>% 
  addWMSTiles("http://www.ign.es/wms-inspire/pnoa-ma?", 
              layers = 'OI.OrthoimageCoverage',
              options = WMSTileOptions(format = "image/png", transparent = TRUE),
              group = "PNOA") %>% 
  addLayersControl(position = 'bottomright',
                   baseGroups = c('Open Street Map','Satellite (ESRI)','PNOA'),
                   overlayGroups = c('Natural Park'))

mapita_final

library(htmlwidgets) # HTML Widgets for R
saveWidget(mapita_final, "index.html")