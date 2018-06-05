# Getting and Cleaning Data Project CodeBook
## Assignment Text

>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
>
>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
>
>Here are the data for the project:
>
>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Data Preparation, Housekeeping, and Prerequisites
### Libraries
- `library(reshape2)` - Used for melt and dcast functions in final tidy data set
- `libary(dplyr)` - Used only for %>% operator
### Software
- `R version 3.5.0`
- `RStudio version 1.1.447`
- `Visual Studio Code version 1.23.1`
### Read Raw Data Files
#### Features
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
``` R
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
```

#### Activities
Six different activities are possible for each of the aforementioned features
- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING
``` R
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
```

### Test Data
There are six total data files pertaining specifically to test and training data
1. `train/X_train.txt` - Training Data Set
2. `train/Y_train.txt` - Training Labels (Activities)
3. `train/subject_train.txt` - Identifies the subject who performed the activity
4. `test/X_test.txt` - Test Data Set
5. `test/Y_test.txt` - Test Labels (Activities)
6. `test/subject_test.txt` - Identifies the subject who performed the activity
```R
trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainAct <- read.table("UCI HAR Dataset/train/y_train.txt")
trainVal <- read.table("UCI HAR Dataset/train/X_train.txt")

testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
testAct <- read.table ("UCI HAR Dataset/test/y_test.txt")
testVal <- read.table("UCI HAR Dataset/test/X_test.txt")
```

## Assignment Requirements
### 1. Merges the training and test sets to create one data set
```R
# Bind columns for test and training
train <- cbind(trainSub,trainAct,trainVal)
test <- cbind(testSub,testAct,testVal) 
```

```R
# Bind rows for test and training into one dataset
all <- rbind(train,test)
```
### 2. Extracts only the measurements on the mean and standard deviation for each measurement
After using grep to find the features of interest, only 66 measurement types remain. <b>Note: I intentionally omitted both the angle measurements as well as the meanFreq() measurements, as they aren't explicitly mean or standard deviation measurements.</b>
```R
featuresOfInterest <- features[grep ("-(mean|std)\\(\\)", features[,2], ignore.case = TRUE),2] 
```
- tBodyAcc-mean()-X
- tBodyAcc-mean()-Y
- tBodyAcc-mean()-Z
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tGravityAcc-mean()-X
- tGravityAcc-mean()-Y
- tGravityAcc-mean()-Z
- tGravityAcc-std()-X
- tGravityAcc-std()-Y
- tGravityAcc-std()-Z
- tBodyAccJerk-mean()-X
- tBodyAccJerk-mean()-Y
- tBodyAccJerk-mean()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-mean()-X
- tBodyGyro-mean()-Y
- tBodyGyro-mean()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyGyroJerk-mean()-X
- tBodyGyroJerk-mean()-Y
- tBodyGyroJerk-mean()-Z
- tBodyGyroJerk-std()-X
- tBodyGyroJerk-std()-Y
- tBodyGyroJerk-std()-Z
- tBodyAccMag-mean()
- tBodyAccMag-std()
- tGravityAccMag-mean()
- tGravityAccMag-std()
- tBodyAccJerkMag-mean()
- tBodyAccJerkMag-std()
- tBodyGyroMag-mean()
- tBodyGyroMag-std()
- tBodyGyroJerkMag-mean()
- tBodyGyroJerkMag-std()
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAcc-std()-X
- fBodyAcc-std()-Y
- fBodyAcc-std()-Z
- fBodyAccJerk-mean()-X
- fBodyAccJerk-mean()-Y
- fBodyAccJerk-mean()-Z
- fBodyAccJerk-std()-X
- fBodyAccJerk-std()-Y
- fBodyAccJerk-std()-Z
- fBodyGyro-mean()-X
- fBodyGyro-mean()-Y
- fBodyGyro-mean()-Z
- fBodyGyro-std()-X
- fBodyGyro-std()-Y
- fBodyGyro-std()-Z
- fBodyAccMag-mean()
- fBodyAccMag-std()
- fBodyBodyAccJerkMag-mean()
- fBodyBodyAccJerkMag-std()
- fBodyBodyGyroMag-mean()
- fBodyBodyGyroMag-std()
- fBodyBodyGyroJerkMag-mean()
- fBodyBodyGyroJerkMag-std()
### 3. Uses descriptive activity names to name the activities in the data set
Assigned activity names to the data within the set using the activity integer column.  It also converts both the subject and activity columns to factors for use in later functions.
```R
# Convert activity into factor and give descriptive name
all$Activity <- factor(all$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
```
```R
#Also convert subject to factor for later analysis
all$Subject <- as.factor(all$Subject)
```
### 4. Appropriately labels the data set with descriptive variable names. 
Use grep() and names() to assign appropriate variable names
```R
# Abbreviations and proper case
names(all) <- gsub("^t", "Time", names(all))
names(all) <- gsub("^f", "Frequency", names(all))
names(all) <- gsub("-std\\(\\)","StandardDeviation", names(all))
names(all) <- gsub("-mean\\(\\)", "Mean", names(all))
names(all) <- gsub("Gyro","Gyroscope", names(all))
names(all) <- gsub("Acc","Accelerometer", names(all))
names(all) <- gsub("gravity", "Gravity", names(all))
names(all) <- gsub("Mag", "Magnitude", names(all))
```
```R
# Clean up special characters and typos
names(all) <- gsub("BodyBody","Body", names(all))
names(all) <- gsub("-", "", names(all))
```
- TimeBodyAccelerometerMeanX
- TimeBodyAccelerometerMeanY
- TimeBodyAccelerometerMeanZ
- TimeBodyAccelerometerStandardDeviationX
- TimeBodyAccelerometerStandardDeviationY
- TimeBodyAccelerometerStandardDeviationZ
- TimeGravityAccelerometerMeanX
- TimeGravityAccelerometerMeanY
- TimeGravityAccelerometerMeanZ
- TimeGravityAccelerometerStandardDeviationX
- TimeGravityAccelerometerStandardDeviationY
- TimeGravityAccelerometerStandardDeviationZ
- TimeBodyAccelerometerJerkMeanX
- TimeBodyAccelerometerJerkMeanY
- TimeBodyAccelerometerJerkMeanZ
- TimeBodyAccelerometerJerkStandardDeviationX
- TimeBodyAccelerometerJerkStandardDeviationY
- TimeBodyAccelerometerJerkStandardDeviationZ
- TimeBodyGyroscopeMeanX
- TimeBodyGyroscopeMeanY
- TimeBodyGyroscopeMeanZ
- TimeBodyGyroscopeStandardDeviationX
- TimeBodyGyroscopeStandardDeviationY
- TimeBodyGyroscopeStandardDeviationZ
- TimeBodyGyroscopeJerkMeanX
- TimeBodyGyroscopeJerkMeanY
- TimeBodyGyroscopeJerkMeanZ
- TimeBodyGyroscopeJerkStandardDeviationX
- TimeBodyGyroscopeJerkStandardDeviationY
- TimeBodyGyroscopeJerkStandardDeviationZ
- TimeBodyAccelerometerMagnitudeMean
- TimeBodyAccelerometerMagnitudeStandardDeviation
- TimeGravityAccelerometerMagnitudeMean
- TimeGravityAccelerometerMagnitudeStandardDeviation
- TimeBodyAccelerometerJerkMagnitudeMean
- TimeBodyAccelerometerJerkMagnitudeStandardDeviation
- TimeBodyGyroscopeMagnitudeMean
- TimeBodyGyroscopeMagnitudeStandardDeviation
- TimeBodyGyroscopeJerkMagnitudeMean
- TimeBodyGyroscopeJerkMagnitudeStandardDeviation
- FrequencyBodyAccelerometerMeanX
- FrequencyBodyAccelerometerMeanY
- FrequencyBodyAccelerometerMeanZ
- FrequencyBodyAccelerometerStandardDeviationX
- FrequencyBodyAccelerometerStandardDeviationY
- FrequencyBodyAccelerometerStandardDeviationZ
- FrequencyBodyAccelerometerJerkMeanX
- FrequencyBodyAccelerometerJerkMeanY
- FrequencyBodyAccelerometerJerkMeanZ
- FrequencyBodyAccelerometerJerkStandardDeviationX
- FrequencyBodyAccelerometerJerkStandardDeviationY
- FrequencyBodyAccelerometerJerkStandardDeviationZ
- FrequencyBodyGyroscopeMeanX
- FrequencyBodyGyroscopeMeanY
- FrequencyBodyGyroscopeMeanZ
- FrequencyBodyGyroscopeStandardDeviationX
- FrequencyBodyGyroscopeStandardDeviationY
- FrequencyBodyGyroscopeStandardDeviationZ
- FrequencyBodyAccelerometerMagnitudeMean
- FrequencyBodyAccelerometerMagnitudeStandardDeviation
- FrequencyBodyAccelerometerJerkMagnitudeMean
- FrequencyBodyAccelerometerJerkMagnitudeStandardDeviation
- FrequencyBodyGyroscopeMagnitudeMean
- FrequencyBodyGyroscopeMagnitudeStandardDeviation
- FrequencyBodyGyroscopeJerkMagnitudeMean
- FrequencyBodyGyroscopeJerkMagnitudeStandardDeviation

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
'Unpivot' data using melt(), then repivot using dcast(), applying mean() and grouping by subject and activity using dcast().  Other functions, such as aggregate, can likely accomplish the same task.  The melt()/dcast() function was used as an example in both a lecture as well as one of the exercies in swirl. Final results can be viewed in the `tidy_data_set.txt` file.
```R
#Unpivot into tall and skinny data set, then repivot while calculating mean
allMean <- melt(all, id = c("Subject","Activity")) %>% 
            dcast(Subject + Activity ~ variable, mean)

# Write Data
write.table(allMean, "tidy_data_set.txt", row.names = FALSE, quote = FALSE)
```