# prepare CCLaws map data
require(httr)
require(data.table)
library(readr)
library(countrycode)
require(dplyr)

# for JSON-LD Dataset
#devtools::install_github("ropenscilabs/datasauce")
library(datasauce)


################################################################################
# EMISSIONS
################################################################################

# Climate Watch
# Global Carbon Project

# Create general metadata structure
org <- datasauce::Organization(
  name = "ICOS Carbon Portal - Global Carbon Project, Lund University",
  url = "https://www.icos-cp.eu/GCP",
  contactPoint = datasauce::ContactPoint(
    email = "info@icos-cp.eu",
    contactType = "General enquiries"
  )
)
ds <- datasauce::Dataset(
  creator = org,
  isBasedOn = "https://doi.org/10.18160/GCP-2018",
  sameAs = "https://www.earth-syst-sci-data.net/10/2141/2018/",
  temporalCoverage = "2018",
  isAccessibleForFree = T,
  license = "http://creativecommons.org/licenses/by/4.0/",
  keywords = c("Carbon dioxide", "Fossil fuel", "Emissions")
)
g_desc <- "ICOS Carbon Portal Global Carbon Project’s Global Carbon Budget includes territorial, consumption, and transfer CO2 emissions data for 220 countries and territories. The data is updated annually. This dataset includes only CO2 emissions (instead of all GHGs). Data for emissions from land use, land use change and forestry, are reported separately at a global level and are not shown on Climate Watch. Emissions from bunker fuels are included in the world total but are not included in territorial emission totals. For details see “Methods” at http://www.globalcarbonatlas.org/en/CO2-emissions."

library(readr)
ghg <- read_csv("historical_emissions.csv")
ghg$iso3 <- countrycode::countrycode(ghg$Country, "country.name", "iso3c")
View(ghg)
out <- ghg[,c("iso3", "2018")]
out <- na.omit(out)
names(out) <- c("iso3", "emissions_total_fossil_fuels_and_cement_in_MtCO2e_2018")
write.csv(out,
          "emissions_total_fossil_fuels_and_cement_in_MtCO2e_2018.csv",
          row.names = F)
# export metadata
ds$name = "Carbon dioxide emissions from the use of fossil fuel and the manufacture of cement"
ds$description = paste("This dataset shows carbon dioxide emissions from the use of coal, oil and gas (combustion and industrial processes), the process of gas flaring and the manufacture of cement for the year 2018 grouped by country.", g_desc)
datasauce::write_jsonld(ds, "emissions_total_fossil_fuels_and_cement_in_MtCO2e_2018.jsonld")




################################################################################
# RISKS
################################################################################

# Global climate risk index 2019 (1998--2017, Germanwatch)



################################################################################
# Direct economic loss attributed to disasters relative to global GDP (%)
# United Nations Statistics Division SDG
# https://unstats.un.org/sdgs/indicators/database/
# https://unstats.un.org/sdgs/metadata/files/Metadata-01-05-02.pdf

# Create general metadata structure
org <- datasauce::Organization(
  name = "United Nations Statistics Division, Development Data and Outreach Branch",
  url = "https://unstats.un.org",
  contactPoint = datasauce::ContactPoint(
    faxNumber = "+1 (212) 963 9851",
    email = "statistics@un.org",
    contactType = "customer service"
  )
)
ds <- datasauce::Dataset(
  creator = org,
  isBasedOn = "https://unstats.un.org/sdgs/indicators/database/",
  sameAs = "https://unstats.un.org/sdgs/metadata/files/Metadata-01-05-02.pdf",
  temporalCoverage = "2005/2018",
  isAccessibleForFree = T,
  license = "https://creativecommons.org/licenses/by-sa/4.0/",
  keywords = c("United Nations Statistics Division", "SDG", "1.5.2", "GDP", "Disaster", "Cumulative")
)
g_desc <- "Direct economic loss is the monetary value of total or partial destruction of physical assets existing in the affected area. Direct economic loss is nearly equivalent to physical damage. Examples of physical assets that are the basis for calculating direct economic loss include homes, schools, hospitals, commercial and governmental buildings, transport, energy, telecommunications infrastructures and other infrastructure; business assets and industrial plants; production such as crops, livestock and production infrastructure. They may also encompass environmental assets and cultural heritage.Direct economic losses usually happen during the event or within the first few hours after the event and are often assessed soon after the event to estimate recovery cost and claim insurance payments. These are tangible and relatively easy to measure. The original time series data from the United Nations Statistics Division, Development Data and Outreach Branch SDG 1.5.2 between 2005 and 2018 were summed per country."

# Load data
gdp <- readr::read_csv("20191204164800512_edward.morris@vizzuality.com_data.csv")
View(gdp)
# convert UN codes to iso3; note Kosovo missing from iso3c
gdp$iso3 <- countrycode::countrycode(gdp$GeoAreaCode, "un", "iso3c")
# export cumalitive_direct_economic_loss_disasters_relative_to_gdp_percent per iso3
out <- gdp %>%
  filter(Indicator == "1.5.2") %>%
  filter(SeriesDescription == "Direct economic loss attributed to disasters relative to GDP (%)") %>%
  group_by(iso3) %>%
  summarise(
    cumalitive_direct_economic_loss_disasters_relative_to_gdp_percent=sum(Value, na.rm=T),
    time_interval=paste(c(min(TimePeriod), max(TimePeriod)), collapse = "--"))
View(out)
summary(out)
write.csv(out,
          "cumalitive_direct_economic_loss_disasters_relative_to_gdp_percent_2005--2018.csv",
          row.names = F)
# export metadata
ds$name = "Cumulative direct economic loss attributed to disasters relative to global GDP (%)"
ds$keywords = c("United Nations Statistics Division", "SDG", "1.5.2", "GDP", "Disaster", "Cumulative")
ds$description = paste("This dataset measures the cumalitive ratio of direct economic loss attributed to disasters in relation to global GDP grouped per country between 2005 and 2018.", g_desc)
datasauce::write_jsonld(ds, "cumalitive_direct_economic_loss_disasters_relative_to_gdp_percent_2005--2018.jsonld")

# export cumalitive_direct_economic_loss_disasters_in_current_us_dollars per iso3
out <- gdp %>%
  filter(Indicator == "1.5.2") %>%
  filter(SeriesDescription == "Direct economic loss attributed to disasters (current United States dollars)") %>%
  group_by(iso3) %>%
  summarise(
    cumalitive_direct_economic_loss_disasters_in_current_us_dollars=sum(Value, na.rm=T),
    time_interval=paste(c(min(TimePeriod), max(TimePeriod)), collapse = "--"))
View(out)
summary(out)
write.csv(out,
          "cumalitive_direct_economic_loss_disasters_in_current_us_dollars_2005--2018.csv",
          row.names = F)
# export metadata
ds$name = "Cumulative direct economic loss attributed to disasters as current US dollars"
ds$keywords = c("United Nations Statistics Division", "SDG", "1.5.2", "current US dollars", "Disaster", "Cumulative")
ds$description = paste("This dataset measures the cumulative direct economic loss attributed to disasters as current US dollars grouped per country between 2005 and 2018.", g_desc)
datasauce::write_jsonld(ds, "cumalitive_direct_economic_loss_disasters_in_current_us_dollars_2005--2018.jsonld")

################################################################################
# Total number of internaly displaced persons due to weather hazards per country (IDMC)
# View data http://www.internal-displacement.org/database/displacement-data
# api https://api.idmcdb.org/api/disaster_data?ci=IDMCWSHSOLO009

# Create general metadata structure
org <- datasauce::Organization(
  name = "Global Internal Displacement Database (GIDD), Internal Displacement Monitoring Center (IDMC)",
  url = "http://www.internal-displacement.org",
  contactPoint = datasauce::ContactPoint(
    telephone = "+41 22 552 3600",
    email = "data@idmc.ch",
    contactType = "Data/database inquiries"
  )
)
ds <- datasauce::Dataset(
  creator = org,
  isBasedOn = "http://www.internal-displacement.org/database/displacement-data",
  sameAs = "http://www.internal-displacement.org/sites/gidd/idmc-conflict-dataset-codebook-2017-05-22.pdf",
  temporalCoverage = "2008-01-01/2018-12-02",
  isAccessibleForFree = T,
  license = "https://creativecommons.org/licenses/by-sa/4.0/",
  keywords = c("Society", "Disasters", "Natural Disasters", "Internally Displaced", "Displaced People", "Migration")
)
g_desc <- "This dataset tracks the number of people who have been internally displaced due to natural disasters worldwide each year. “Internal displacement” refers to the forced movement of people within the country that they live in. Millions of people are forced to flee their homes each year due to conflict, violence, development projects, disasters, and climate change and remain displaced within their countries of residence. Internally displaced persons (IDPs) can include both citizens and other habitual residents of the country, such as stateless persons. IDPs from weather hazards may have been displaced by the following types of events; Meteorological - storms, extreme temperatures, severe winter condition, Hydrological - flooding, wet mass movement, wave action, and Climatological - wildfires, drought. Some of the typical needs and protection risks that arise in internal displacement include family separation, loss of documentation, loss of property, and further exposure to the risk of continued displacement.This dataset is produced by the Internal Displacement Monitoring Centre (IDMC) with the aim of informing policy and operational decisions in order to reduce the risk of future displacement and improve the lives of IDPs worldwide. Cumalitive sums of IDPs were calculated by aggregating all recorded events by country between 2008 and 2018. Note data may not be available for all countries during the whole time interval."

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
write.csv(out, "cumalitive_weather_idp_per_country_2008--2018.csv", row.names = F)
# export metadata
ds$name = "Cumalitive number of persons iternally displaced due to weather hazards grouped by country"
datasauce::write_jsonld(ds, "cumalitive_weather_idp_per_country_2008--2018.jsonld")
