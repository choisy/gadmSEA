# general parameters:
# the tolerance parameter to simplify the maps:
tolerance <- .03
# the countries for which we want the maps:
countries <- c("china", "india", "indonesia", "laos", "malaysia", "philippines",
               "taiwan", "thailand", "vietnam", "myanmar", "cambodia",
               "papuanewguinea", "bhutan", "nepal", "singapore", "srilanka",
               "pakistan", "japan", "korea", "north korea", "russia", "bangladesh")

# ------------------------------------------------------------------------------

# the hash table with countries names and codes:
hash <- countrycode::countrycode_data

# gives the index of one country in the hash table:
getcountry <- function(country)
  which(sapply(hash$country.name.en.regex, grep, country, perl = TRUE) > 0)

# retrieves the codes for the countries we want:
countrycodes <- hash[sapply(countries, getcountry), "iso3c"]
sea_countries <- lapply(countrycodes,
         function(x) raster::getData("GADM", path = "data-raw", country = x, level = 0))

countries <- gsub(" ", "", countries)
names(sea_countries) <- countries

# simplifying the maps:
library(maptools) # for "thinnedSpatialPoly" (need to load it to make "rgeos" available)
sea_countries <- lapply(sea_countries, thinnedSpatialPoly, tolerance)

# saving the maps to \data folder:
eply::evals(paste0("with(sea_countries, devtools::use_data(",
                   paste(countries, collapse = ", "),
                   ", overwrite = TRUE))"))
