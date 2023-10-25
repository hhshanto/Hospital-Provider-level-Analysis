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
# Data Merge
# Merge the first two dataframes by 'ID'
merged_df_of_first_two <- merge(data_08_09, data_09_10, by = "ID", all = TRUE)

#==============================================================================
# Checking the common and unique column in first two datasets
# # Get the 'ID' values of each dataframe
# id_08_09 <- data_08_09$ID
# id_09_10 <- data_09_10$ID
# 
# # Find the 'ID' values that are common to both
# common_ids <- intersect(id_08_09, id_09_10)
# 
# # Find the 'ID' values that are unique to data_08_09
# unique_ids_08_09 <- setdiff(id_08_09, id_09_10)
# 
# # Find the 'ID' values that are unique to data_09_10
# unique_ids_09_10 <- setdiff(id_09_10, id_08_09)
# 
# # Get the number of common and unique 'ID' values
# num_common_ids <- length(common_ids)
# num_unique_ids_08_09 <- length(unique_ids_08_09)
# num_unique_ids_09_10 <- length(unique_ids_09_10)
# 
# # Print the numbers
# print(paste("Number of 'ID' values common to both: ", num_common_ids))
# print(paste("Number of 'ID' values unique to data_08_09: ", num_unique_ids_08_09))
# print(paste("Number of 'ID' values unique to data_09_10: ", num_unique_ids_09_10))

#==============================================================================
# Merging all the ready datasets

# Initialize the merged dataframe as the first dataframe
merged_df <- get(names[1])

# Loop through each remaining name
for (i in 2:length(names)) {
  # Get the dataframe from the name
  df <- get(names[i])
  
  # Merge the dataframes by 'ID'
  MergedData <- merge(merged_df, df, by = "ID", all = TRUE)
}

#==============================================================================
# Exporting the final merged data

library(openxlsx)
write.xlsx(MergedData, "MergedData/MergedData.xlsx")
  