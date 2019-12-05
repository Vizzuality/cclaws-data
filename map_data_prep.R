library(readr)
library(countrycode)
library(dplyr)

#@name Direct economic loss attributed to disasters relative to GDP (%)
#@source United Nations Statistics Division SDG
#@link https://unstats.un.org/sdgs/indicators/database/
#@url_metadata https://unstats.un.org/sdgs/metadata/files/Metadata-01-05-02.pdf
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