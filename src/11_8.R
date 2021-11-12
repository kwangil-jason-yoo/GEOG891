library(tidyverse)
library(leaflet)
m <- leaflet()
m
m <- leaflet() %>% addTiles()
m
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng = -96.703090, lat = 40.819288, popup="The Burnett Hall GIS Lab")
m
# start with a data frame
df <- data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)

# then add the data frame to a leaflet map
m2 <- leaflet(df) %>% addTiles()
m2$x

m2 %>% addCircleMarkers(radius = ~size, color = ~color, fill = F)
m2 %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))

m <- leaflet() %>% setView(lng = -96.703090, lat = 40.81928, zoom = 14)
m %>% addTiles()

# third party tiles using addProvider() function

m %>% addProviderTiles(providers$Stamen.Toner)
m %>% addProviderTiles(providers$CartoDB.Positron)
m %>% addProviderTiles(providers$CartoDB.DarkMatter)
m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)
m %>% addProviderTiles(providers$Stamen.TonerLite)

parks <- sf::read_sf("./data/State_Park_Locations.shp")
mp <- leaflet(data = parks) %>% setView(lng = -96.703090, lat = 40.81928, zoom = 10)
mp %>% addTiles() %>% 
  addMarkers(popup = ~AreaName, label = ~AreaName)


streams <- sf::read_sf("./data/Streams_303_d_.shp")
ms <- leaflet(data = streams) %>% 
  setView(lng = -96.703090, lat = 40.81928, zoom = 10) %>% 
  addTiles() %>%
  addPolylines(., color = "blue", 
               popup = ~paste0(Waterbody_, " - ", Impairment))
ms

mu_bound <- sf::read_sf("./data/Municipal_Boundaries.shp")
mb <- leaflet(data = mu_bound) %>%
  setView(lng = -96.703090, lat = 40.81928, zoom = 10) %>%
  addTiles() %>%
  addPolylines(., color = "red", popup = ~NAME)
mb

m.both <- leaflet() %>%
  setView(lng = -96.703090, lat = 40.81928, zoom = 8) %>% 
  addProviderTiles(providers$Thunderforest.Outdoors) %>%
  addMarkers(data = parks, popup = ~AreaName, label = ~AreaName) %>% 
  addPolylines(data = streams, color = "blue", 
               popup = ~paste0(Waterbody_, " - ", Impairment)) %>%
  addPolylines(data = mu_bound, color = "darkblue", popup = ~NAME) %>%
  addPolygons(data = mu_bound, fillColor = "red")
m.both
