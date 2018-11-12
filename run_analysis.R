### RUN_ANALYSIS ###

# Setting working directory
setwd("~/Downloads/Data_Science_Specialization/Tests/Tests_R/PGA-G&C_D")

# Opening libraries
library(plyr)
library(dplyr)
library(tidyr)

## 1. Merges the training and the test sets to create one data set. ##

# Downloading file
if (!file.exists("Data")) {dir.create("Data")}
download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip", 
              "Data/Dataset.zip")#zip dataset
# Unzipping folder
unzip("Data/Dataset.zip", exdir="./Data")

# read csv with activity codes and activity labels
ActivityLabels <- read.csv("Data/UCI HAR Dataset/activity_labels.txt", header = F, col.names = c("activitycode", "activitylabel"), sep = " ")
ActivityLabels <- tbl_df(ActivityLabels)

# read csv with feature-id & feature names (561)
Features <- read.table("Data/UCI HAR Dataset/features.txt", 
                       header = F, sep = " ", col.names = c("featureid", "feature"))

# vector with feature names (561)
features <- as.vector(Features$feature)

# Assembling test dataset
TestSubject <- read.csv("Data/UCI HAR Dataset/test/subject_test.txt", header = F, col.names = "subject")
TestActivityLabel <- read.csv("Data/UCI HAR Dataset/test/Y_test.txt", header = F, col.names = "activitylabel")
TestFeatures <- read.table("Data/UCI HAR Dataset/test/X_test.txt", 
                     header = F, col.names = features, skipNul = T)

Test <- bind_cols(TestSubject, TestActivityLabel)
Test <- bind_cols(Test, TestFeatures)

# Assembling training dataset
TrainSubject <- read.csv("Data/UCI HAR Dataset/train/subject_train.txt", header = F, col.names = "subject")
TrainActivityLabel <- read.csv("Data/UCI HAR Dataset/train/Y_train.txt", header = F, col.names = "activitylabel")
TrainFeatures <- read.table("Data/UCI HAR Dataset/train/X_train.txt", 
                           header = F, col.names = features, skipNul = T)

Train <- bind_cols(TrainSubject, TrainActivityLabel)
Train <- bind_cols(Train, TrainFeatures)

# Assembling final dataset (test & trainging combined)
Merged <- rbind.data.frame(Train, Test)
Merged <- tbl_df(Merged)

## 2. Extracting only the measurements on the mean and standard deviation for each measurement. ##

# Using only mean and std variables
MeanStd <- (grepl("subject" , colnames(Merged)) | 
                    grepl("activitylabel" , colnames(Merged)) | 
                    grepl("mean" , colnames(Merged)) | 
                    grepl("Mean" , colnames(Merged)) | 
                    grepl("std" , colnames(Merged)))

Merged_MeanStd <- Merged[ , MeanStd]

## 3. Uses descriptive activity names to name the activities in the data set. ##

# Using activity names instead of activity codes & reordering columns
Merged_MeanStd <- merge(Merged_MeanStd, ActivityLabels, by.x = "activitylabel", by.y = "activitycode")
Merged_MeanStd <- select(Merged_MeanStd, 2, 89, 3:88)

## 4. Appropriately labels the data set with descriptive activity names. ##

# Creating vector for new columnnames
ColNames <- names(Merged_MeanStd)
ColNames <- gsub("\\.", "", ColNames)
ColNames <- gsub("subject", "SubjectID", ColNames)
ColNames <- gsub("activitylabely", "Activity", ColNames)
ColNames <- gsub("^t", "Time", ColNames)
ColNames <- gsub("^f", "Frequency", ColNames)
ColNames <- gsub("^angle", "Angle", ColNames)
ColNames <- gsub("Acc", "Accelerometer", ColNames)
ColNames <- gsub("Gyro", "Gyrometer", ColNames)
ColNames <- gsub("mean", "Mean", ColNames)
ColNames <- gsub("std", "Std", ColNames)
ColNames <- gsub("Mag", "Magnitude", ColNames)
ColNames <- gsub("gravity", "Gravity", ColNames)
ColNames <- gsub("BodyBody", "Body", ColNames)
ColNames <- gsub("tBody", "TimeBody", ColNames)

# Apply new columnnames
names(Merged_MeanStd) <- ColNames

## 5. Creates a second, independent tidy data set with the average of each variable for each activity 
## and each subject. 

# Aggregate ad order data set
Merged_TidyData <- aggregate(. ~SubjectID + Activity, Merged_MeanStd, mean)
Merged_TidyData <- Merged_TidyData[order(Merged_TidyData$SubjectID, Merged_TidyData$Activity),]

# write data set
write.table(Merged_TidyData, "TidyData.txt", row.name=FALSE)

##############################
