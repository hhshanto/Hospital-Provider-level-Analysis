# load necessary libraries
library(readxl)
library(httr)

# list of URLs
urls <- c(
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02556/hosp-epis-stat-admi-prov-leve-08-09-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02567/hosp-epis-stat-admi-prov-leve-09-10-tab.xls'
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

# corresponding list of sheet numbers
sheets <- c(3, 2)
#provider_sheets <- c()

# corresponding list of dataset names
names <- c("data_08_09", "data_09_10")

# corresponding list of dataset names for the provider lists
provider_names <- c("provider_list_08_09", "provider_list_09_10")
#==============================================================================
for(i in seq_along(urls)) {
  # download the file into temporary file
  temp <- tempfile(fileext = ".xls")
  download.file(urls[i], temp, mode = "wb")
  
  # read the specified sheet of the excel file into a dataframe
  df <- read_excel(temp, sheet = sheets[i])
  
  # rename the first column to "ID"
  colnames(df)[1] <- "ID"
  
  # assign the dataframe to a variable with the specified name
  assign(names[i], df, envir = .GlobalEnv)
  
  # read the "SHA and Provider List" sheet into a dataframe
  provider_df <- read_excel(temp, sheet = "SHA and Provider List")
  
  # take only the first two columns
  provider_df <- provider_df[, 1:2]
  
  # rename the columns
  colnames(provider_df)[1] <- "ID"
  colnames(provider_df)[2] <- "Providers"
  
  # assign the provider dataframe to a variable with the specified name
  assign(provider_names[i], provider_df, envir = .GlobalEnv)
}

#==============================================================================
# Deleting the completely empty rows

for(name in names) {
  # get the dataframe from the name
  df <- get(name)
  
  # remove NA values
  df <- na.omit(df, cols = 1)
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
  
  rm(df) #removing local dataframe from environment for space
}


# Deleting the completely empty rows from provider list

for(name in provider_names) {
  # get the dataframe from the name
  df <- get(name)
  
  # remove NA values
  df <- na.omit(df)
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
}

#==============================================================================

# adding availability column in dataframes

for(name in names) {
  # get the dataframe from the name
  df <- get(name)
  
  # extract the last part of the name
  suffix <- gsub("data_", "", name)
  
  # create the new column name
  new_col_name <- paste0("availability_", suffix)
  
  # add the new column to the dataframe
  df[[new_col_name]] <- "1"
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
  
  rm(df) #removing local dataframe from environment for space
}

#==============================================================================
# Converting all character values to numeric and setting "*" = -1

for(name in names) {
  # get the dataframe from the name
  df <- get(name)
  
  # apply the function to each column of the dataframe, except the first one
  df[, -1] <- lapply(df[, -1], function(col) {
    # replace "*" with "-1"
    col[col == "*"] <- "-1"
    
    # convert the column to numeric type
    as.numeric(col)
  })
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
  rm(df) #removing local dataframe from environment for space
}

#==============================================================================





















