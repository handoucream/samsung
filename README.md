# Samsung Project

## This is a computer assignment for Getting and Cleaning Data course. The project contains data from the accelerometers from the Samsung Galaxy S smartphone. The assignment is to create a R code to tidy-up the data set.

## The Github repo includes the following files:

### - "LICENSE"

### - "README.md"

### - "cleandata.txt" : the final cleaned tidy data set

### - "run-analysis.R" : the code for conducting the clean up on original data set

## The original data set could be downloaded from url :

### <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

## A full description of the data set is available at the site where the data was obtained:

### <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## The requirement of the data processing is as follow:

### 1. Merges the training and the test sets to create one data set.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

### 3. Uses descriptive activity names to name the activities in the data set

### 4. Appropriately labels the data set with descriptive variable names.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## The script

### Step 1: get the data and unzip the file

```         
workingdirectory <- "/Users/dou/Documents/R/datasciencecoursera/samsung"
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = paste(workingdirectory, "/samsung.zip", sep = ""), method = "curl")
unzip(paste(workingdirectory,"/samsung.zip", sep = ""))
```

### Step 2: read and label data with appropriate variant names

```         
activity_labels <- read.table(paste(workingdirectory, "/UCI HAR Dataset/activity_labels.txt", sep = ""), col.names = c("label", "activity"))
features <- read.table(paste(workingdirectory, "/UCI HAR Dataset/features.txt", sep = ""), col.names = c("colunm", "features"))

test_x <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/X_test.txt", sep = ""), col.names = features[, 2])
test_y <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/y_test.txt", sep = ""), col.names = "training")
subject_test <- read.table(paste(workingdirectory, "/UCI HAR Dataset/test/subject_test.txt", sep = ""), col.names = "subject")
test <- cbind(subject_test, test_y, test_x)

train_x <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/X_train.txt", sep = ""), col.names = features[, 2])
train_y <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/y_train.txt", sep = ""), col.names = "training")
subject_train <- read.table(paste(workingdirectory, "/UCI HAR Dataset/train/subject_train.txt", sep = ""), col.names = "subject")
train <- cbind(subject_train, train_y, train_x)
```

### Step 3: merge the test and the train sets

```         
samsung <- merge(test, train, all = TRUE)
samsung <- tibble(samsung)
```

### Step 4: Extracts only the measurements on the mean and standard deviation for each measurement

```         
samsung_mean_std <- select(samsung, subject, training, grep(".mean.", colnames(samsung), fixed = TRUE), grep("std", colnames(samsung), fixed = TRUE))
```

### Step 5 : Use descriptive activity names to name the activities in the data set

```         
samsung_mean_std <- mutate(samsung_mean_std, training = activity_labels[samsung_mean_std$training, "activity"])
```

### Step 6: create a second, independent tidy data set with the average of each variable for each activity and each subject.

```         
column <- colnames(samsung_new)[3:66]
samsung_new %>% 
        group_by(subject, training) %>%
        summarize(across(column, mean)) %>%
        write.table(file = paste(workingdirectory, "/cleandata.txt", sep = ""), row.names = FALSE)
```

#### variant column is for summarize to perform across col 3: 66
