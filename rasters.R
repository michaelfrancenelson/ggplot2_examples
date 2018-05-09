require(raster)
require(rasterVis)


# Create a random polygon
poly_spdf = random_polygons_df(n_pts = 15, n_polys = 1, seed = 2, mean_x = 0, mean_y = 1, sd_x = 1, sd_y = 1)

# Create a raster under the polygon
rast1 = raster(buffer(as(extent(poly_spdf), "SpatialPolygons"), 2), nrow = 200, ncol = 200)

# Make up some data
rast1[] = rexp(prod(dim(rast1)), 3)
rast1 = crop(rast1 + focal(focal(focal(rast1, diag(5) + 0.2), diag(7)), matrix(1, 3, 3)), extent(poly_spdf))

image(rast1)
plot(poly_spdf, add = T)

# Create a mask
rast2 = mask(rast1, poly_spdf)

# use gplot() and geom_raster() for raster objects
g1 = gplot(rast1) + geom_raster(aes(fill = value)) + coord_equal()
g2 = gplot(rast2) + geom_raster(aes(fill = value)) + coord_equal()

g1
g2


g_poly = geom_path(data = poly_spdf, aes(long, lat, group = group))

# Create a color gradient that keeps the NA cells transparent
g_gr = 
  scale_fill_gradient(
    high = "yellow",
    low = "red",
    limits = range(rast1[]),
    na.value = "transparent", 
    breaks = c(0, 0.5, 1), 
    name = "MPB\nsurvival\n\n ")
g_gr1 = 
  scale_fill_gradientn(
    # colors = heat.colors(10),
    colors = rainbow(10),
    na.value = "transparent", 
    limits = range(rast1[]), 
    breaks = c(0, 0.5, 1), 
    name = "MPB\nsurvival\n\n ")
g_gr2 = 
  scale_fill_gradientn(
    colors = terrain.colors(10),
    na.value = "transparent", 
    name = "MPB\nsurvival\n\n ",
    limits = range(rast1[]))

g1 + g_gr + g_poly
g1 + g_gr1 + g_poly
g2 + g_gr2 + g_poly
