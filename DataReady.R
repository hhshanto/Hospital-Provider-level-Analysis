# Getting url_sets
library(readxl)

# List of URLs
urls <- c(
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02556/hosp-epis-stat-admi-prov-leve-08-09-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02567/hosp-epis-stat-admi-prov-leve-09-10-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02570/hosp-epis-stat-admi-prov-leve-10-11-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub08xxx/pub08288/hosp-epis-stat-admi-prov-leve-11-12-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub12xxx/pub12566/hosp-epis-stat-admi-prov-leve-2012-13-tab.xlsx',
  'https://files.digital.nhs.uk/publicationimport/pub16xxx/pub16719/hosp-epis-stat-admi-prov-leve-2013-14-tab.xlsx',
  'https://files.digital.nhs.uk/publicationimport/pub19xxx/pub19124/hosp-epis-stat-admi-prov-leve-2014-15-tab.xlsx',
  'https://files.digital.nhs.uk/publicationimport/pub22xxx/pub22378/hosp-epis-stat-admi-prov-leve-2015-16-tab.xlsx',
  'https://files.digital.nhs.uk/publication/7/a/hosp-epis-stat-admi-prov-leve-2016-17-tab.xlsx',
  'https://files.digital.nhs.uk/FD/697B3D/hosp-epis-stat-admi-prov-leve-2017-18-tab.xlsx',
  'https://files.digital.nhs.uk/AE/2CF944/hosp-epis-stat-admi-prov-leve-2018-19-tab.xlsx',
  'https://files.digital.nhs.uk/01/B9F273/hosp-epis-stat-admi-prov-leve-2019-20-tab%20v2.xlsx',
  'https://files.digital.nhs.uk/72/1ED61C/hosp-epis-stat-admi-prov-leve-2020-21-tab.xlsx',
  'https://files.digital.nhs.uk/7F/8E93CF/hosp-epis-stat-admi-pla-2021-22.xlsx',
)

# List of years
years <- c('08_09', '09_10', '10_11', '11_12', '12_13', '13_14', '14_15', '15_16', '16_17', '17_18', '18_19', '19_20', '20_21', '21_22')

# List of rows to skip
skip_rows <- c(9, 11, 11, 10, 9, 9, 8, 11, 11, 15)

# Loop over the URLs
for (i in seq_along(urls)) {
  # Download the file
  temp_file <- tempfile()
  download.file(urls[i], temp_file, mode = 'wb')
  
  # Read the Excel file and assign it to a variable with the corresponding year
  assign(paste0('data_', years[i]), read_excel(temp_file, skip = skip_rows[i]))
}

# =========================================================================================
#necessary packages
library(readxl)
library(purrr)

# List of URLs
urls <- c(
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02556/hosp-epis-stat-admi-prov-leve-08-09-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02567/hosp-epis-stat-admi-prov-leve-09-10-tab.xls',
  # 'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02570/hosp-epis-stat-admi-prov-leve-10-11-tab.xls',
  # 'https://files.digital.nhs.uk/publicationimport/pub08xxx/pub08288/hosp-epis-stat-admi-prov-leve-11-12-tab.xls',
  # 'https://files.digital.nhs.uk/publicationimport/pub12xxx/pub12566/hosp-epis-stat-admi-prov-leve-2012-13-tab.xlsx',
  # 'https://files.digital.nhs.uk/publicationimport/pub16xxx/pub16719/hosp-epis-stat-admi-prov-leve-2013-14-tab.xlsx',
  # 'https://files.digital.nhs.uk/publicationimport/pub19xxx/pub19124/hosp-epis-stat-admi-prov-leve-2014-15-tab.xlsx',
  # 'https://files.digital.nhs.uk/publicationimport/pub22xxx/pub22378/hosp-epis-stat-admi-prov-leve-2015-16-tab.xlsx',
  # 'https://files.digital.nhs.uk/publication/7/a/hosp-epis-stat-admi-prov-leve-2016-17-tab.xlsx',
  # 'https://files.digital.nhs.uk/FD/697B3D/hosp-epis-stat-admi-prov-leve-2017-18-tab.xlsx',
  # 'https://files.digital.nhs.uk/AE/2CF944/hosp-epis-stat-admi-prov-leve-2018-19-tab.xlsx',
  # 'https://files.digital.nhs.uk/01/B9F273/hosp-epis-stat-admi-prov-leve-2019-20-tab%20v2.xlsx',
  # 'https://files.digital.nhs.uk/72/1ED61C/hosp-epis-stat-admi-prov-leve-2020-21-tab.xlsx',
  # 'https://files.digital.nhs.uk/7F/8E93CF/hosp-epis-stat-admi-pla-2021-22.xlsx',
)

# List of years
# years <- c('08_09', '09_10', '10_11', '11_12', '12_13', '13_14', '14_15', '15_16', '16_17', '17_18', '18_19', '19_20', '20_21', '21_22')
years <- c('08_09', '09_10')

# List of sheet numbers or names
sheets <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14) # replace with your actual sheet numbers or names

# Download the Excel files and read the specified sheet from each file
data_list <- map2(urls, sheets, ~ read_excel(.x, sheet = .y))

# Assign the data frames to variables in the global environment
list2env(setNames(data_list, paste0("data_", years)), envir = .GlobalEnv)







