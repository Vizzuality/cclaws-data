# prepare CCLaws map data
require(httr)
require(data.table)
require(dplyr)

################################################################################
# RISKS
################################################################################

# Global climate risk index 2019 (1998--2017, Germanwatch)
# Direct disaster economic loss as a share of GDP, (2005--2018, OWID)



################################################################################
# Total number of internaly displaced persons due to weather hazards per country (IDMC)
# View data http://www.internal-displacement.org/database/displacement-data
# api https://api.idmcdb.org/api/disaster_data?ci=IDMCWSHSOLO009

# API response
u <- "https://api.idmcdb.org/api/disaster_data?ci=IDMCWSHSOLO009"
r <- httr::GET(url=u)
d <- httr::content(r)

# Select useful fields
get_vars <- function(l){
  return(
    #as.data.frame.list(
      l[c("iso3", "year", "hazard_category", "hazard_sub_category",
              "hazard_type", "hazard_sub_type", "new_displacements")]
     # )
    )
}

df <-data.table::rbindlist(lapply(d$results, get_vars))
View(df)
# Select only "weather related" and sum per iso3
out <- df %>%
  group_by(iso3) %>%
  filter(hazard_category == "Weather related") %>%
  summarise(tot_weather_idp = sum(new_displacements, na.rm=T))
View(out)
write.csv(out, "idmc_total_weather_idp_per_country_2008-2018.csv", row.names = F)
