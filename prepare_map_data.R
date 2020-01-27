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
# Global emmissions by country including land use change

# Create general metadata structure
org <- datasauce::Organization(
  name = "World Resources Institute",
  url = "http://cait.wri.org/historical/",
  contactPoint = datasauce::ContactPoint(
    email = "jfriedrich@wri.org",
    contactType = "Dataset enquiries"
  )
)
ds <- datasauce::Dataset(
  creator = org,
  sameAs = "https://www.climatewatchdata.org/ghg-emissions",
  temporalCoverage = "2016",
  isAccessibleForFree = T,
  license = "http://creativecommons.org/licenses/by/4.0/",
  keywords = c("Carbon dioxide", "Fossil fuel", "Emissions", "Land-Use change and forestry")
)
g_desc <- "As of December 2019, CAIT Historical Emission data contains sector-level greenhouse gas (GHG) emissions data for 185 countries and the European Union (EU) for the period 1990-2016, including emissions of the six major GHGs from most major sources and sinks. See http://cait.wri.org/docs/CAIT2.0_CountryGHG_Methods.pdf for details regarding data source and methodology. Cautions: CAIT data are derived from several sources. Any use of the Land-Use Change and Forestry or Agriculture indicator should be cited as FAO 2019, FAOSTAT Emissions Database. Any use of CO2 emissions from fuel combustion data should be cited as CO2 Emissions from Fuel Combustion, OECD/IEA, 2018."

library(readr)
ghg <- read_csv("raw_data/cait_historical_emissions_ghgs_with_lucf.csv")
ghg$iso3 <- countrycode::countrycode(ghg$Country, "country.name", "iso3c")
View(ghg)
out <- ghg[,c("iso3", "2016")]
out <- na.omit(out)
names(out) <- c("iso3", "emissions_total_fossil_fuels_and_cement_including LUCF_in_MtCO2e_2016")
write.csv(out,
          "prep_data/emissions_total_fossil_fuels_and_cement_including LUCF_in_MtCO2e_2016.csv",
          row.names = F)
# export metadata
ds$name = "CAIT Country Greenhouse Gas Emissions Data (2016)"
ds$description = paste("This dataset shows total green house gas emissions from the use of coal, oil and gas (combustion and industrial processes), the process of gas flaring and the manufacture of cement, land-use changes, and forestry for the year 2016 grouped by country.", g_desc)
datasauce::write_jsonld(ds, "prep_data/emissions_total_fossil_fuels_and_cement_including LUCF_in_MtCO2e_2016.jsonld")




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


# Cumalitive CO2
# Create general metadata structure
org <- datasauce::Organization(
  name = "Our World In Data - Global Change Data Lab, Oxford University",
  url = "https://ourworldindata.org",
  contactPoint = datasauce::ContactPoint(
    email = "info@ourworldindata.org",
    contactType = "General enquiries"
  )
)
ds <- datasauce::Dataset(
  creator = org,
  isBasedOn = "https://ourworldindata.org/grapher/cumulative-co-emissions",
  sameAs = "https://ourworldindata.org/grapher/cumulative-co-emissions",
  temporalCoverage = "1751/2017",
  isAccessibleForFree = T,
  license = "http://creativecommons.org/licenses/by/4.0/",
  keywords = c("Carbon dioxide", "Fossil fuel", "Emissions", "Cumalitive")
)
g_desc <- "Cumulative carbon dioxide (CO₂) emissions have been calculated by Our World in Data based on annual CO₂ emissions published by the Global Carbon Project (GCP) and Carbon Dioxide Information Analysis Centre (CDIAC). By summing the annual emissions to a given year we have calculated the cumulative total. This is given as the share of global cumulative emissions by dividing each country or region's cumulative emissions by the cumulative world emissions for that given year. Data has been converted by Our World in Data from tonnes of carbon to tonnes of carbon dioxide (CO₂) using a conversion factor of 3.664. Our World in Data have renamed the category 'bunker fuels' as 'International transport' which includes emissions from international aviation and shipping. We have renamed this category for clarity. Historical data for Australia in CDIAC from 1820 until 1860 reports negative CO2 emissions. In this dataset, pre-1860 data for Australia has been removed. Data from pre-1959 is sourced from the archived Carbon Dioxide Information Analysis Centre (CDIAC). Reference: Tom Boden and Bob Andres (Oak Ridge National Laboratory); Gregg Marland (Appalachian State University). Available at: http://cdiac.ornl.gov/. Data from 1959 onwards is sourced from the Global Carbon Project (2018). Full reference of the Global Carbon Budget (2018): Corinne Le Quéré, Robbie M. Andrew, Pierre Friedlingstein, Stephen Sitch, Judith Hauck, Julia Pongratz, Penelope A. Pickers, Jan Ivar Korsbakken, Glen P. Peters, Josep G. Canadell, Almut Arneth, Vivek K. Arora, Leticia Barbero, Ana Bastos, Laurent Bopp, Frédéric Chevallier, Louise P. Chini, Philippe Ciais, Scott C. Doney, Thanos Gkritzalis, Daniel S. Goll, Ian Harris, Vanessa Haverd, Forrest M. Hoffman, Mario Hoppema, Richard A. Houghton, George Hurtt, Tatiana Ilyina, Atul K. Jain, Truls Johannesen, Chris D. Jones, Etsushi Kato, Ralph F. Keeling, Kees Klein Goldewijk, Peter Landschützer, Nathalie Lefèvre, Sebastian Lienert, Zhu Liu, Danica Lombardozzi, Nicolas Metzl, David R. Munro, Julia E. M. S. Nabel, Shin-ichiro Nakaoka, Craig Neill, Are Olsen, Tsueno Ono, Prabir Patra, Anna Peregon, Wouter Peters, Philippe Peylin, Benjamin Pfeil, Denis Pierrot, Benjamin Poulter, Gregor Rehder, Laure Resplandy, Eddy Robertson, Matthias Rocher, Christian Rödenbeck, Ute Schuster, Jörg Schwinger, Roland Séférian, Ingunn Skjelvan, Tobias Steinhoff, Adrienne Sutton, Pieter P. Tans, Hanqin Tian, Bronte Tilbrook, Francesco N Tubiello, Ingrid T. van der Laan-Luijkx, Guido R. van der Werf, Nicolas Viovy, Anthony P. Walker, Andrew J. Wiltshire, Rebecca Wright, Sönke Zaehle, Bo Zheng: Global Carbon Budget 2018, Earth Syst. Sci. Data, 2018b. https://doi.org/10.5194/essd-10-2141-2018."


cco <- read_csv("raw_data/cumulative-co-emissions.csv")
View(cco)
names(cco) <- c("name", "iso3", "year", "cumulative_emissions_total_fossil_fuels_and_cement_in_MtCO2e_2017")
out <- cco %>% filter(year==2017)
View(out)
out$cumulative_emissions_total_fossil_fuels_and_cement_in_MtCO2e_2017 <- out$cumulative_emissions_total_fossil_fuels_and_cement_in_MtCO2e_2017/10^6
View(out)
write.csv(out,
          "prep_data/cumulative_emissions_total_fossil_fuels_and_cement_in_MtCO2e_2017.csv",
          row.names = F)
# export metadata
ds$name = "Carbon dioxide emissions from the use of fossil fuel and the manufacture of cement"
ds$description = paste("This dataset shows cumulative carbon dioxide (CO₂) emissions grouped by country; the total quantity of CO₂ emissions emitted from 1751 until 2017, measured in megatonnes. This is based on territorial emissions, which do not account for emissions embedded in traded goods.", g_desc)
datasauce::write_jsonld(ds, "prep_data/cumulative_emissions_total_fossil_fuels_and_cement_in_MtCO2e_2017.jsonld")




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
