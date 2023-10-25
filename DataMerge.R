#Reading Data
library(openxlsx)
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
for (name in names) {
  file_path <- paste0("DataReady/", name, ".xlsx")
  
  df <- read.xlsx(file_path)
  
  # Assign the dataframe to a variable in your global environment
  assign(name, df)
}


#==============================================================================
# Merging all the ready datasets

# Initialize the merged dataframe as the first dataframe
merged_df <- get(names[1])

# Loop through each remaining name
for (i in 2:length(names)) {
  # Get the dataframe from the name
  df <- get(names[i])
  
  # Merge the dataframes by 'ID'
  merged_df <- merge(merged_df, df, by = "ID", all = TRUE)
}

#==============================================================================
# Exporting the final merged data
library(openxlsx)
write.xlsx(merged_df, "MergedData/merged_df.xlsx")





