# download file
workingdirectory <- "/Users/dou/Documents/R/datasciencecoursera/samsung"
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = paste(workingdirectory, "/samsung.zip", sep = ""), method = "curl")
# unzip
unzip(paste(workingdirectory,"/samsung.zip", sep = ""))

library(tidyr, dplyr)

# read activity labels and features. Appropriately labels the data set with descriptive variable names. 
activity_labels <- read.table(paste(workingdirectory, "/UCI HAR Dataset/activity_labels.txt", sep = ""), col.names = c("label", "activity"))
features <- read.table(paste(workingdirectory, "/UCI HAR Dataset/features.txt", sep = ""), col.names = c("colunm", "features"))
# read test data set
test_x <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/X_test.txt", sep = ""), col.names = features[, 2])
test_y <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/y_test.txt", sep = ""), col.names = "training")
subject_test <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/subject_test.txt", sep = ""), col.names = "subject")
test <- cbind(subject_test, test_y, test_x)
# read train data set. Appropriately labels the data set with descriptive variable names. 
train_x <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/X_train.txt", sep = ""), col.names = features[, 2])
train_y <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/y_train.txt", sep = ""), col.names = "training")
subject_train <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/subject_train.txt", sep = ""), col.names = "subject")
train <- cbind(subject_train, train_y, train_x)
# merge the test and the train sets to create one data set
samsung <- merge(test, train, all = TRUE)
samsung <- tibble(samsung)
# Extracts only the measurements on the mean and standard deviation for each measurement
samsung_mean_std <- select(samsung, subject, training, grep(".mean.", colnames(samsung), fixed = TRUE), grep("std", colnames(samsung), fixed = TRUE))
# Use descriptive activity names to name the activities in the data set
samsung_mean_std <- mutate(samsung_mean_std, training = activity_labels[samsung_mean_std$training, "activity"])
# From the data set in last step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
column <- colnames(samsung_new)[3:66]
samsung_new %>% 
        group_by(subject, training) %>%
        summarize(across(column, mean)) %>%
        write.table(file = paste(workingdirectory, "/cleandata.txt", sep = ""), row.names = FALSE)
