# Create random polygons embedded in a SpatialPolygonsDataFrame in lon/lat projection
random_polygons_df = function(n_pts, n_polys, seed = NA, mean_x, mean_y, sd_x, sd_y, lambda = NA){
  stopifnot(
    length(mean_x) == n_polys,
    length(mean_y) == n_polys,
    length(sd_x) == n_polys,
    length(sd_y) == n_polys
  )
  
  if (!is.na(seed)) set.seed(seed)
  
  Srl = vector(mode = "list", length = n_polys)
  for (i in 1:n_polys){
    if (!is.na(lambda)) m1 = matrix(rnorm(n = n_pts * 2), ncol = 2) else
      m1 = matrix(rpois(n = n_pts * 2, lambda = 30), ncol = 2)
    
    # Scale to the mean and sd
    m1[, 1] = sd_x[i] * m1[, 1] + mean_x[i]
    m1[, 2] = sd_y[i] * m1[, 2] + mean_y[i]
    
    ch1 = chull(m1)
    Srl[[i]] = Polygons(list(Polygon(m1[c(ch1, ch1[1]), ])), ID = i) # closed polygon
  }
  return(SpatialPolygonsDataFrame(Sr = SpatialPolygons(Srl, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")), data = data.frame(id = 1:n_polys)))
}

# Create a set of lon/lat gridlines
create_long_lat = function(xlim, ylim, n_lon, n_lat, buf = 0.1){
  
  n_pts = 1000
  
  buf_lon = buf * (xlim[2] - xlim[1])
  buf_lat = buf * (ylim[2] - ylim[1])
  
  buf_lon = xlim + c(-buf_lon, buf_lon)
  buf_lat = ylim + c(-buf_lat, buf_lat)
  
  x = seq(buf_lon[1], buf_lon[2], length.out = n_pts)
  y = seq(buf_lat[1], buf_lat[2], length.out = n_pts)
  
  lat = seq(buf_lat[1], buf_lat[2], length.out = n_lat)
  lon = seq(buf_lon[1], buf_lon[2], length.out = n_lon)
  
  suppressWarnings(
    {
      tally = 1
      lon_lat_list = list()
      for(i in 1:n_lat){
        lon_lat_list[[tally]] = Polygons(list(Polygon(cbind(c(x, rev(x)), rep(lat[i], 2 * n_pts)))), ID = tally)
        tally = tally + 1
      }
      for(i in 1:n_lon){
        lon_lat_list[[tally]] = Polygons(list(Polygon(cbind(rep(lon[i], 2 * n_pts), c(y, rev(y))))), ID = tally)
        tally = tally + 1
      }
    }
  )
  return( SpatialPolygonsDataFrame(SpatialPolygons(lon_lat_list, proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")), data = data.frame(id = 1:(tally - 1))))
}