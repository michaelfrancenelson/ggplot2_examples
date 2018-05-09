require(sp)
require(ggplot2)
require(ggpolypath)

source("helper_functions.R")

# Some resources:
#   http://zevross.com/blog/2014/07/16/mapping-in-r-using-the-ggplot2-package/
#   http://zevross.com/blog/2015/03/30/map-and-analyze-raster-data-in-r/  


# Create data -------------------------------------------------------------

n_pts = 100
n_polys = 10
seed = 1
mean_x = rnorm(n_polys, mean = 0, sd = 3)
mean_y = rnorm(n_polys, mean = 0)
sd_x = rnorm(n_polys, sd = 0.5)
sd_y = rnorm(n_polys, sd = 0.65)
seed = 1

spdf = random_polygons_df(n_pts, n_polys, seed = 1, mean_x, mean_y, sd_x, sd_y)
spdf = random_polygons_df(n_pts, n_polys, seed = 1, mean_x, mean_y, sd_x, sd_y, lambda = 100)
lon_lat_spdf = create_long_lat(bbox(spdf)[1, ], bbox(spdf)[2, ], 5, 5, buf = 0.1)

# No axes or legend, no bakground gridlines
t1 = theme(legend.position = "none", 
           axis.title = element_blank(), 
           axis.text = element_blank(), 
           axis.ticks = element_blank(),
           panel.grid.major = element_blank(), 
           panel.grid.minor = element_blank())



# base plot ---------------------------
aea = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=7.5 +lon_0=0 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
plot(lon_lat_spdf)
plot(spdf, add = T)
plot(spTransform(lon_lat_spdf, CRS(aea)))
plot(spTransform(spdf, CRS(aea)), add = T)






# Long/lat gridlines ------------------------------------------------------

# gridlines in two projections
l1a = geom_path(
  data = lon_lat_spdf, 
  aes(long, lat, group = group), 
  color = "white")
l1b = geom_path(
  data = spTransform(lon_lat_spdf, CRS(aea)),
  aes(long, lat, group = group), 
  color = "white")

# with geom_polygon() -----------------------------

# geom_poly() avoids the noticeable gap at the first and last coords that appears with geom_path() 
# when plotting thick boundaries.

# the polygons in two projections
p1a = geom_polygon(
  data = spdf, 
  aes(x = long, y = lat, group = group, fill = id),
  size = 4,
  alpha = 0.2)
p1b = geom_polygon(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, fill = id), 
  alpha = 0.5)

# use fill = NA outside the aesthetic for unfillled polys
p1c = geom_polygon(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, color = id), 
  fill = NA,
  size = 8,
  alpha = 1)

ggplot() + t1 + l1a + p1a
ggplot() + t1 + l1b + p1b
ggplot() + t1 + l1b + p1c


# With polypath -----------------------------------------------------------

pp1a = geom_polypath(
  data = spdf, 
  aes(x = long, y = lat, group = group, fill = id, color = id), 
  alpha = 0.2, 
  size = 0.5)
pp1b = geom_polypath(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, fill = id, color = id), 
  alpha = 0.12, 
  size = 5)

# Use alpha = 0 for unfilled polys
pp1c = geom_polypath(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, fill = id, color = id), 
  alpha = 0.0, 
  size = 5)

# fill = NA does not work
pp1d = geom_polypath(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, color = id), 
  alpha = 0.0, 
  fill = NA,
  size = 5)

ggplot() + t1 + l1a + pp1a
ggplot() + t1 + l1b + pp1b
ggplot() + t1 + l1b + pp1c
ggplot() + t1 + l1b + pp1d


# With geom_path() --------------------------------------------------------
pth1a = geom_path(
  data = spdf, 
  aes(x = long, y = lat, group = group, color = id),
  alpha = 1, 
  size = 0.75)

# The line ends are jagged at the first/last polygon coordinate junction when using thick lines
pth1b = geom_path(
  data = spTransform(spdf, CRS(aea)), 
  aes(x = long, y = lat, group = group, color = id), 
  size = 5, 
  alpha = 0.4)

ggplot() + t1 + pth1a
ggplot() + t1 + pth1b



# Equal scale for coords --------------------------------------------------

c1 = coord_equal()
ggplot() + t1 + l1a + pp1a + c1
ggplot() + t1 + l1b + pp1b + c1

geom_li