#First data set of stations
set1 <- structure(list(lon = centroids$x, lat = centroids$y), .Names = c("lon","lat"), row.names = c(NA, 4094L), class = "data.frame")

hospitals <- hospitals[-c(146:997), ]

#Second data set
set2 <- structure(list(lon = structure(hospitals$Longitude, .Dim = 145L), lat = structure(hospitals$Latitude, .Dim = 145L)), .Names = c("lon","lat"), row.names = c(NA, 145L), class = "data.frame")

install.packages("rgeos")
library(rgeos)
install.packages("sp")
library(sp)
install.packages("geosphere")
library(geosphere)

set1sp <- SpatialPoints(set1)
set2sp <- SpatialPoints(set2)
set1$nearest_in_set2 <- apply(gDistance(set2sp, set1sp, byid=TRUE), 1, which.min)

set3 <- structure(list(lon = centroids$x, lat = centroids$y), .Names = c("lon","lat"), row.names = c(NA, 4094L), class = "data.frame")
set4 <- structure(list(lon = set2[set1$nearest_in_set2,]$lon, lat = set2[set1$nearest_in_set2,]$lat), .Names = c("lon", "lat"), row.names = c(NA, 4094L), class = "data.frame")
distances <- apply(distm(set3, set4, fun = distHaversine), 1, )

set1$nearest_hospital <- distances
set1$black_denials_rate <- centroids$black_denials_rate
set1$black_pop_pct <- centroids$black_pop_pct
set1$tract <- centroids$NAME
set1$geoid <- centroids$GEO_ID
set1$white_pop <- centroids$white_population
set1$black_pop <- centroids$black_population
set1$white_loans <- centroids$white_loans
set1$black_loans <- centroids$black_loans

write.csv(set1, "Documents/distance_to_hospital.csv")
