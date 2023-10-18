# load necessary libraries
library(readxl)
library(httr)

# list of URLs
urls <- c(
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02556/hosp-epis-stat-admi-prov-leve-08-09-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub02xxx/pub02567/hosp-epis-stat-admi-prov-leve-09-10-tab.xls',
  'https://files.digital.nhs.uk/publicationimport/pub08xxx/pub08288/hosp-epis-stat-admi-prov-leve-11-12-tab.xls',
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
  'https://files.digital.nhs.uk/7F/8E93CF/hosp-epis-stat-admi-pla-2021-22.xlsx'
)

# corresponding list of sheet numbers
sheets <- c(3,2,3,2,3,2,3,3,4,11,11,10,11,11)
#provider_sheets <- c()

# corresponding list of dataset names
names <- c("data_08_09", 
           "data_09_10",
           "data_10_11", 
           "data_11_12", 
           "data_12_13", 
           "data_13_14",
           "data_14_15",
           "data_15_16",
           "data_16_17",
           "data_17_18",
           "data_18_19",
           "data_19_20",
           "data_20_21",
           "data_21_22"
)

# corresponding list of dataset names for the provider lists
provider_names <- c("provider_list_08_09", 
                    "provider_list_09_10",
                    "provider_list_10_11",
                    "provider_list_11_12",
                    "provider_list_12_13",
                    "provider_list__13_14",
                    "provider_list__14_15",
                    "provider_list__15_16",
                    "provider_list__16_17",
                    "provider_list__17_18",
                    "provider_list__18_19",
                    "provider_list__19_20",
                    "provider_list__20_21",
                    "provider_list__21_22"
)
#==============================================================================
for(i in seq_along(urls)) {
  # download the file into temporary file
  if (i <= 4) {
    temp <- tempfile(fileext = ".xls")
  } else {
    temp <- tempfile(fileext = ".xlsx")
  }
  
  download.file(urls[i], temp, mode = "wb")
  
  # read the specified sheet of the excel file into a dataframe
  df <- read_excel(temp, sheet = sheets[i])
  print(paste("sheet number", sheets[i]))
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


#==============================================================================
# Deleting the completely empty rows

for(name in names) {
  # get the dataframe from the name
  df <- get(name)
  
  # remove NA values
  df <- df[!(is.na(df$ID) | apply(is.na(df[,-c(1:2)]), 1, all)), ]
  
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
  
  # add the new column to the dataframe
  df["Availability"] <- 1
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
  
  rm(df) #removing local dataframe from environment for space
}

#==============================================================================
# Converting all character values to numeric and setting "*" = NA

for(name in names) {
  # get the dataframe from the name
  df <- get(name)
  
  # apply the function to each column of the dataframe, except the first one
  df[, -1] <- lapply(df[, -1], function(col) {
    # replace "*" with "NA"
    col[col == "*"] <- NA
    
    # convert the column to numeric type
    as.numeric(col)
  })
  
  # assign the result back to the original dataframe
  assign(name, df, envir = .GlobalEnv)
  rm(df) #removing local dataframe from environment for space
}

#==============================================================================
# Adding the providers column inmain dataframe.
# loop over the list of dataframe names
for(i in seq_along(names)) {
  # get the dataframes from the names
  df <- get(names[i])
  provider_df <- get(provider_names[i])
  
  # merge the dataframes on the "ID" column
  merged_df <- merge(df, provider_df, by = "ID", all.x = TRUE)
  
  # reorder the columns
  cols <- c("ID", setdiff(names(merged_df), "ID"))
  merged_df <- merged_df[, cols]
  
  # assign the result back to the original dataframe
  assign(names[i], merged_df, envir = .GlobalEnv)
}
#==============================================================================
#Bringing the Providers infront of ID column

# loop over the list of dataframe names
for(i in seq_along(names)) {
  # get the dataframe from the name
  df <- get(names[i])
  
  # get the column names
  cols <- colnames(df)
  
  # create a new order for the columns
  new_order <- c(cols[1], cols[length(cols)], cols[2:(length(cols)-1)])
  
  # reorder the columns
  df <- df[, new_order]
  
  # assign the result back to the original dataframe
  assign(names[i], df, envir = .GlobalEnv)
}

#==============================================================================

#Changing the column names according the years

# loop over the list of dataframe names
for(i in seq_along(names)) {
  # get the dataframe from the name
  df <- get(names[i])
  
  # get the suffix from the dataframe name
  suffix <- gsub("data", "", names[i])
  
  # get the column names
  cols <- colnames(df)
  
  # append the suffix to each column name, except for the first one
  cols[-1] <- paste0(cols[-1], suffix)
  
  # assign the new column names to the dataframe
  colnames(df) <- cols
  
  # assign the result back to the original dataframe
  assign(names[i], df, envir = .GlobalEnv)
}

#==============================================================================

