devtools::install_github("ropenscilabs/datasauce")
library(datasauce)

cp <- datasauce::ContactPoint(
  faxNumber = "+1 (212) 963 9851",
  email = "statistics@un.org",
  contactType = "customer service",
  name = "United Nations Statistics Division, Development Data and Outreach Branch")
datasauce::Dataset(
  name = "Cumulative direct economic loss attributed to disasters relative to global GDP (%)",
  isBasedOn = "https://unstats.un.org/sdgs/indicators/database/",
  sameAs = "https://unstats.un.org/sdgs/metadata/files/Metadata-01-05-02.pdf",
  temporalCoverage = "2005/2018",
  isAccessibleForFree = T,
  keywords = c("United Nations Statistics Division", "SDG", "1.5.2", "GDP", "Disaster", "Cumulative"),
  description = "This dataset "
  
)

"name":"NCDC Storm Events Database",
"description":"Storm Data is provided by the National Weather Service (NWS) and contain statistics on...",
"url":"https://catalog.data.gov/dataset/ncdc-storm-events-database",
"sameAs":"https://gis.ncdc.noaa.gov/geoportal/catalog/search/resource/details.page?id=gov.noaa.ncdc:C00510",
"identifier": ["https://doi.org/10.1000/182",
               "https://identifiers.org/ark:/12345/fk1234"],
"keywords":[
  "ATMOSPHERE > ATMOSPHERIC PHENOMENA > CYCLONES",
  "ATMOSPHERE > ATMOSPHERIC PHENOMENA > DROUGHT",
  "ATMOSPHERE > ATMOSPHERIC PHENOMENA > FOG",
  "ATMOSPHERE > ATMOSPHERIC PHENOMENA > FREEZE"
  ],
"creator":{
  "@type":"Organization",
  "url": "https://www.ncei.noaa.gov/",
  "name":"OC/NOAA/NESDIS/NCEI > National Centers for Environmental Information, NESDIS, NOAA, U.S. Department of Commerce",
  "contactPoint":{
    "@type":"ContactPoint",
    "contactType": "customer service",
    "telephone":"+1-828-271-4800",
    "email":"ncei.orders@noaa.gov"
  }
},
"includedInDataCatalog":{
  "@type":"DataCatalog",
  "name":"data.gov"
},
"distribution":[
  {
    "@type":"DataDownload",
    "encodingFormat":"CSV",
    "contentUrl":"http://www.ncdc.noaa.gov/stormevents/ftp.jsp"
  },
  {
    "@type":"DataDownload",
    "encodingFormat":"XML",
    "contentUrl":"http://gis.ncdc.noaa.gov/all-records/catalog/search/resource/details.page?id=gov.noaa.ncdc:C00510"
  }
  ],
"temporalCoverage":"1950-01-01/2013-12-18",
"spatialCoverage":{
  "@type":"Place",
  "geo":{
    "@type":"GeoShape",
    "box":"18.0 -65.0 72.0 172.0"
  }
}
}