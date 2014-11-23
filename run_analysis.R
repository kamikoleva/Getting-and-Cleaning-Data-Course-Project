############################################################################################################################
## S T E P   0: PREPARE FOR WORK 
# Set working directory in the home directory
setwd("~/")
# Check the dta avilability and download if needed
if(!file.exists("UCI HAR Dataset")) {
  
  print("Downloading Data")
  DataSourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(DataSourceURL, destfile = "Dataset.zip", mode = "wb")
  
  print("Unzipping Data!")
  unzip("Dataset.zip")
  print("Unzipping Data Done!")
}

# Set working directory
setwd("~/UCI HAR Dataset")

# Prepare all packages for work

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

############################################################################################################################
## S T E P   1: MERGING TRAINING AND TESTING SETS
# X_TrainAndTest_DataSet Merging
TempDataSet1 <- read.table("train/X_train.txt")
TempDataSet2 <- read.table("test/X_test.txt")
X_TrainAndTest_DataSet <- rbind(TempDataSet1, TempDataSet2)

# Y_TrainAndTest_DataSet Merging
TempDataSet1 <- read.table("train/y_train.txt")
TempDataSet2 <- read.table("test/y_test.txt")
Y_TrainAndTest_DataSet <- rbind(TempDataSet1, TempDataSet2)
# Name the column in the Y_TrainAndTest_DataSet
names(Y_TrainAndTest_DataSet) <- "Activity"

# Subject_TrainAndTest_DataSet Merging
TempDataSet1 <- read.table("train/subject_train.txt")
TempDataSet2 <- read.table("test/subject_test.txt")
Subject_TrainAndTest_DataSet <- rbind(TempDataSet1, TempDataSet2)
# Name the column in the S_TrainAndTest_DataSet
names(Subject_TrainAndTest_DataSet) <- "Subject"

# Delete temp variables
rm(TempDataSet1,TempDataSet2)

# Display massage
print("Merging Data Sets Done!")

############################################################################################################################
## S T E P   2: MEASURMENTS MEAN AND STANDART DEVIATION EXTRACTION

# Load the features list from file
Features_Full_List <- read.table("features.txt")

# Extract Features containg only mean anfd st.dev. 
Extraction_Features <- grep("-mean\\(\\)|-std\\(\\)", Features_Full_List[, 2])

# Remove all unwanted columns from X_TrainAndTest_DataSet
X_TrainAndTest_DataSet <- X_TrainAndTest_DataSet[, Extraction_Features]

# Rename properly the columns
names(X_TrainAndTest_DataSet) <- Features_Full_List[Extraction_Features, 2]

# Remove "()" from the column names
names(X_TrainAndTest_DataSet) <- gsub("\\(|\\)", "", names(X_TrainAndTest_DataSet))

# Display massage
print("Extraction Of Mean And Standart Deviation Measurments Done!")

############################################################################################################################
## S T E P   3: RENAME ACTIVITIES IN THE DATA SET WITH THEIR DESCRIPTIVE NAMES

# Load the Activity Legend Table from  file 
Activity_Legend <- read.table("activity_labels.txt")

# Rename the Activity Legend
names(Activity_Legend) <- c("Activity_ID", "Activity_Label")

# Subsitute numbers with discrption in the Y_TrainAndTest_DataSet
Y_TrainAndTest_DataSet[, 1] <- Activity_Legend[ Y_TrainAndTest_DataSet[, 1], "Activity_Label"]

# Display massage
print("Substitution With Descriptive Names Done!")


###########################################################################################################################
## S T E P   4: CREATE TIDY DATA SET WITH AVERAGE FOR EACH VARIABLE, ACTIVITY AND SUBJECT
# Merege all Data frames in one
Full_Data_Set <- cbind(Subject_TrainAndTest_DataSet, 
                       Y_TrainAndTest_DataSet, 
                       X_TrainAndTest_DataSet)

# Melt the data by subject and activity
Melted_Full_Data_Set = melt(Full_Data_Set, 
                            id = names(Full_Data_Set)[1:2], 
                            measure.vars = names(Full_Data_Set)[-(1:2)])

# Reshape and compute average for each subject and activity
Final_Tidy_Data_Set   = dcast(Melted_Full_Data_Set, 
                              Subject + Activity ~ variable, 
                              mean)

# Export the final data set
write.table(Final_Tidy_Data_Set, file = "./tidy_data.txt", row.name = F)

# Display massage
print("Reshaped, Cleaned And Precomputed Data Set Export Done! Find the file in UCI HAR Dataset Folder!")

# # Set working directory in the home directory
setwd("~/")