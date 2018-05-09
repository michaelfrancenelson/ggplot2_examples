require(sp)
require(ggplot2)
require(ggpolypath)

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

bbox(spdf)[1, ]

# base plot ---------------------------
aea = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=7.5 +lon_0=0 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
plot(lon_lat_spdf)
plot(spdf, add = T)
plot(spTransform(lon_lat_spdf, CRS(aea)))
plot(spTransform(spdf, CRS(aea)), add = T)



# ggplot -----------------------------

# the polygons in two projections
p1a = geom_polygon(data = spdf, aes(x = long, y = lat, group = group, fill = id), alpha = 0.5)
p1b = geom_polygon(data = spTransform(spdf, CRS(aea)), aes(x = long, y = lat, group = group, fill = id), alpha = 0.5)


# gridlines in two projections
l1a = geom_path(data = lon_lat_spdf, aes(long, lat, group = group), color = "white")
l1b = geom_path(data = spTransform(lon_lat_spdf, CRS(aea)), aes(long, lat, group = group), color = "white")

# No axes or legend, no bakground gridlines
t1 = theme(legend.position = "none", 
           axis.title = element_blank(), 
           axis.text = element_blank(), 
           axis.ticks = element_blank(),
           panel.grid.major = element_blank(), 
           panel.grid.minor = element_blank())


ggplot() + t1 + l1a + p1a
ggplot() + t1 + l1b + p1b


# With polypath -----------------------------------------------------------

pp1a = geom_polypath(data = spdf, aes(x = long, y = lat, group = group, fill = id, color = id), alpha = 0.2)
pp1b = geom_polypath(data = spTransform(spdf, CRS(aea)), aes(x = long, y = lat, group = group, fill = id, color = id), alpha = 0.2)

ggplot() + t1 + l1a + pp1a
ggplot() + t1 + l1b + pp1b


# Equal scale for coords --------------------------------------------------

c1 = coord_equal()
ggplot() + t1 + l1a + pp1a + c1
ggplot() + t1 + l1b + pp1b + c1

