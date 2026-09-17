## The goal is to prepare tidy data that can be used for later analysis
## This script is going to: 
## 1-merge the training and the test set to create one dataset 
## 2-extract the measurements we need 
## 3-decode with description 
## 4-label the data set 
## 5-create a tidy dataset 

library(dplyr)

if (!file.exists(file.path(mainDir, "output"))){
  dir.create(file.path(mainDir, "output"))    
}


mainDir <- getwd()

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file  <- file.path(mainDir, "UCI_HAR_Dataset.zip")
data_dir  <- file.path(mainDir, "UCI HAR Dataset")

## ------------------------------------
## download the file if doesn't exists 
## ------------------------------------

if(!file.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    download.file(data_url, destfile = zip_file, mode = "wb")
  }
  unzip(zip_file)
}

## ----------------------------------
## read the components 
## ----------------------------------

features <- read.table(file.path(data_dir, "features.txt"),
                       stringsAsFactors = FALSE,
                       col.names = c("id", "feature_name"))


activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"),
                              stringsAsFactors = FALSE,
                              col.names = c("activity_id", "activity_name"))

## training data 

x_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"),
                            col.names = "activity_id")
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"),
                            col.names = "subject")

## test data 

x_test       <- read.table(file.path(data_dir, "test", "X_test.txt"))
y_test       <- read.table(file.path(data_dir, "test", "y_test.txt"),
                           col.names = "activity_id")
subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"),
                           col.names = "subject")

## ----------------------------
## merge test and training data 
## ----------------------------

colnames(x_train) <- features$feature_name
colnames(x_test)  <- features$feature_name

train_data <- cbind(subject_train, y_train, x_train)
test_data  <- cbind(subject_test,  y_test,  x_test)

merged_data <- rbind(train_data, test_data)

## --------------------------
## extract mean and standard deviation 
## ---------------------------

keep_cols <- grepl("subject|activity_id|mean\\(\\)|std\\(\\)", colnames(merged_data))
merged_data <- merged_data[, keep_cols]

## --------------------------------
## use descriptive activity name 
## to label the activity 
## -------------------------------

merged_data <- merge(merged_data, activity_labels, by = "activity_id")

## activity_id is no longer needed once we have the descriptive name
merged_data$activity_id <- NULL


## ---------------------------------
## label the data set with descriptive variables 
## ---------------------------------

names(merged_data) <- gsub("^t", "time", names(merged_data))
names(merged_data) <- gsub("^f", "frequency", names(merged_data))
names(merged_data) <- gsub("Acc", "Accelerometer", names(merged_data))
names(merged_data) <- gsub("Gyro", "Gyroscope", names(merged_data))
names(merged_data) <- gsub("Mag", "Magnitude", names(merged_data))
names(merged_data) <- gsub("BodyBody", "Body", names(merged_data))
names(merged_data) <- gsub("\\(\\)", "", names(merged_data))
names(merged_data) <- gsub("-mean-", "Mean", names(merged_data))
names(merged_data) <- gsub("-std-",  "Std",  names(merged_data))
names(merged_data) <- gsub("-mean", "Mean", names(merged_data))
names(merged_data) <- gsub("-std",  "Std",  names(merged_data))
names(merged_data) <- gsub("-", "", names(merged_data))
names(merged_data) <- gsub("^activity_name$", "activity", names(merged_data))

## -----------------------------------
## create the tidy data set 
## ----------------------------------

tidy_data <- merged_data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  arrange(subject, activity)

write.table(tidy_data, file = "output/tidy_data.txt", row.name = FALSE, quote = FALSE)

