library(tidyverse)
library(tmap)
library(sf)
# load data
counties <- sf::read_sf("./data/CBW/County_Boundaries.shp") %>% sf::st_make_valid()
dams <- sf::read_sf("./data/CBW/Dam_or_Other_Blockage_Removed_2012_2017.shp") %>% sf::st_make_valid()
streams <- sf::read_sf("./data/CBW/Streams_Opened_by_Dam_Removal_2012_2017.shp") %>% sf::st_make_valid()
bmps <- read_csv("./data/CBW/BMPreport2016_landbmps.csv")
pa.counties <- counties %>% filter(STATEFP10 ==42)
pa.dams <- st_intersection(dams, pa.counties)
st_intersects(dams, pa.counties)
dams %>% st_intersects(x = ., y = pa.counties)
dams %>% st_intersects(x = pa.counties, y = .)
dams %>% st_intersects(x = ., y = pa.counties, sparse = F) #sparse False
# Disjoint
dams %>% st_disjoint(., pa.counties, sparse = F)
# Within
dams %>% st_within(., pa.counties, sparse = F)

c.tioga <- pa.counties %>% filter(NAME10 == "Tioga")
streams.tioga <- streams[c.tioga,]
streams.tioga %>% st_covered_by(., c.tioga)
tm_shape(c.tioga) + tm_polygons() + tm_shape(streams.tioga) + tm_lines(col = "blue")
streams.tioga %>% st_is_within_distance(., dams,1)
join1 <- st_join(pa.counties, dams, join = st_intersects)
join2 <- st_join(pa.counties, dams, join = st_disjoint)
join3 <- st_join(pa.counties, streams, join = st_touches)
tm_shape(join2) +tm_polygons()+ tm_shape(streams.tioga) + tm_lines(col = "blue")

# NHDs
nhds <- sf::read_sf("./data/nhdplus_loads.shp") %>% sf::st_make_valid()
glimpse(nhds)
tm_shape(nhds) + tm_polygons("Baseline_L", n = 10)
rpcs <- sf::read_sf("./data/gn_vt_rpcs.shp") %>% sf::st_make_valid()
glimpse(rpcs) 
tm_shape(rpcs) + tm_polygons(col = "INITIALS")
tm_shape(rpcs) + tm_borders(col = "red") +
  tm_shape(nhds) + tm_polygons(col = "Baseline_L", n = 7) +
  tm_shape(rpcs) + tm_borders(col = "red")

# do the join
nhd_rpcs <- st_join(nhds, rpcs, join = st_intersects)

# look at it/confirm it worked
glimpse(nhd_rpcs)

# plot it
tm_shape(nhd_rpcs) + tm_polygons(col = "RPC")

nhd_rpcs %>% 
  group_by(RPC) %>% 
  summarize(totalLoad = sum(Baseline_L))

nhd_rpcs %>% 
  group_by(RPC) %>% 
  summarize(totalLoad = sum(Baseline_L)) %>%
  tm_shape(.) + tm_polygons(col = "totalLoad") # <- this line is new

aggregate(x = nhds, by = rpcs, FUN = sum)
glimpse(nhds)

# fix the problem
nhds %>% dplyr::select(-SOURCEFC, -NHDPlus_Ca, -Tactical_B) %>%
  aggregate(x = ., by = rpcs, FUN = sum)

agg.rpcs <- nhds %>% dplyr::select(-SOURCEFC, -NHDPlus_Ca, -Tactical_B) %>%
  aggregate(x = ., by = rpcs, FUN = sum)
tm_shape(agg.rpcs) + tm_polygons(col = "Baseline_L")

nhd_rpcs %>% group_by(NHDPlus_ID) %>% summarise(count = n()) %>%
  arrange(desc(count))

# area-weighted interpolation
interp.loads <- nhds %>% dplyr::select(Baseline_L, geometry) %>% 
  st_interpolate_aw(., rpcs, extensive = T)

tm_shape(interp.loads) + tm_polygons(col = "Baseline_L")

comparison <- st_join(agg.rpcs, interp.loads, st_equals)

tmap_mode("view")

comparison %>% mutate(diff = Baseline_L.x - Baseline_L.y) %>%
  tm_shape(.) + tm_polygons(col = "diff") +
  tm_shape(nhds) + tm_borders(col = "blue")
