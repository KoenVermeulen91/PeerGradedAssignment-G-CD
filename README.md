# PeerGradedAssignment-G-CD
Peer Graded Assignment: Getting &amp; Cleaning Data Course Project (Coursera)

  By:     Koen Vermeulen
  Date:   12-11-2018
  
Overview

The data for this project was obtained using a Samsung Galaxy S smartphone using 30 subjects performing 6 different activities. The data is available at the UCI Machine Learning Repository.

This project uses the source data to create a tidy dataset containing the average of each source data variable for each activity and each subject.

The following files are in this repo:

- README.md, this file provides an overview of the project;
- TidyData.txt, the dataset with the tidy data with the mean for each variable for all activities and subjects;
- run_analysis.R, an R script that was used to create the tidy dataset;
- CodeBook.md, describes how the use the script.  

How the Script works

The tidy dataset is created by running run_analysis.R. The script walks through data collection, data merging and tidy data creation.

The following steps are taken:
Setting working directory
Opening libraries

1. Merges the training and the test sets to create one data set. 

Downloading file
Unzipping folder
read csv with activity codes and activity labels
read csv with feature-id & feature names (561)
vector with feature names (561)
Assembling test dataset
Assembling training dataset
Assembling final dataset (test & trainging combined)

2. Extracting only the measurements on the mean and standard deviation for each measurement.

Using only mean and std variables

3. Uses descriptive activity names to name the activities in the data set. ##

Using activity names instead of activity codes & reordering columns

4. Appropriately labels the data set with descriptive activity names. ##

Creating vector for new columnnames
Apply new columnnames

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Aggregate ad order data set
Write data set

R version 3.5.0 (2018-04-23), macOS Mojave (version 10.14.1)
The script requires the dplyr package (version 0.5.0).
