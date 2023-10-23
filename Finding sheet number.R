# load necessary libraries
library(readxl)
library(httr)

# list of URLs
urls <- c(
  'https://files.digital.nhs.uk/FD/697B3D/hosp-epis-stat-admi-prov-leve-2017-18-tab.xlsx',
  'https://files.digital.nhs.uk/AE/2CF944/hosp-epis-stat-admi-prov-leve-2018-19-tab.xlsx',
  'https://files.digital.nhs.uk/01/B9F273/hosp-epis-stat-admi-prov-leve-2019-20-tab%20v2.xlsx',
  'https://files.digital.nhs.uk/72/1ED61C/hosp-epis-stat-admi-prov-leve-2020-21-tab.xlsx',
  'https://files.digital.nhs.uk/7F/8E93CF/hosp-epis-stat-admi-pla-2021-22.xlsx'
)

# corresponding list of sheet numbers
sheets <- c(11,11,10,11,11)
#provider_sheets <- c()

# corresponding list of dataset names
names <- c("data_17_18",
           "data_18_19",
           "data_19_20",
           "data_20_21",
           "data_21_22"
)

# corresponding list of dataset names for the provider lists
provider_names <- c(
                    "provider_list__17_18",
                    "provider_list__18_19",
                    "provider_list__19_20",
                    "provider_list__20_21",
                    "provider_list__21_22"
)
#==============================================================================
library(readxl)

for(i in seq_along(urls)) {
  # download the file into temporary file
  temp <- tempfile(fileext = ".xlsx")
  download.file(urls[i], temp, mode = "wb")
  
  # get the list of sheet names
  sheets <- excel_sheets(temp)
  
  # print the sheet names with their numbers
  for(j in seq_along(sheets)) {
    print(paste("Sheet number: ", j, ", Sheet name: ", sheets[j]))
  }
  
}

