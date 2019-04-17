# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                     LIBRARIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(raster)
library(sf)
library(magrittr)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                       DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
load('./data/rawData/shippingStL.RData')


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    FORMAT DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Modify projection
# We use the Lambert projection as a default, which allows us to work in meters
# rather than in degrees
prj <- "+proj=lcc +lat_1=46 +lat_2=60 +lat_0=44 +lon_0=-68.5 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
shipping <- projectRaster(shipping, crs = prj)


# We also work with polygons rather than rasters, so we need to transform raster
# cells to polygons. Data could be left as rasters, but we elected to work with
# a hexagonal grid and so have decided to convert everything in polygons.
# Transform raster to polygon
shipping <- rasterToPolygons(shipping)

# Transform to sf object
shipping <- st_as_sf(shipping)

# Select only features with values > 0
id0 <- shipping$shipping > 0
shipping <- shipping[id0, ]


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  EXPORT DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Export object as .RData
save(shipping, file = './data/rawData/shipping.RData')
