########################### Data Prep and Housekeeping ##################################
#Check if the UCI HAR Dataset exists, if not, download and unzip
if(!file.exists("UCI HAR Dataset")){
    if(!file.exists("UCI_HAR_Dataset.zip")){
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url, "UCI_HAR_Dataset.zip")
    }
    unzip("UCI_HAR_Dataset.zip")
}

#Read in data
trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainAct <- read.table("UCI HAR Dataset/train/y_train.txt")
trainVal <- read.table("UCI HAR Dataset/train/X_train.txt")

testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
testAct <- read.table ("UCI HAR Dataset/test/y_test.txt")
testVal <- read.table("UCI HAR Dataset/test/X_test.txt")

features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")


########################### Begin Script ####################################
# Step 1 - Merges the training and the test sets to create one data set.
# Bind columns for test and training
train <- cbind(trainSub,trainAct,trainVal)
test <- cbind(testSub,testAct,testVal)

# Bind rows for test and training into one dataset
all <- rbind(train,test)
# Assign column names
colnames(all) <- c("Subject", "Activity", features[,2])


# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# Find all of the columns names with 'mean' or 'std' and assign them to dataframe
featuresOfInterest <- features[grep ("-(mean|std)\\(\\)", features[,2], ignore.case = TRUE),2]
all <- all[,c("Subject", "Activity", featuresOfInterest)]


# Step 3 - Uses descriptive activity names to name the activities in the data set
# Convert activity into factor
all$Activity <- factor(all$Activity, levels = activityLabels[,1], labels = activityLabels[,2])

#Also convert subject to factor for later analysis
all$Subject <- as.factor(all$Subject)


# Step 4 - Appropriately labels the data set with descriptive variable names.
# Abbreviations and proper case
names(all) <- gsub("^t", "Time", names(all))
names(all) <- gsub("^f", "Frequency", names(all))
names(all) <- gsub("-std\\(\\)","StandardDeviation", names(all))
names(all) <- gsub("-mean\\(\\)", "Mean", names(all))
names(all) <- gsub("Gyro","Gyroscope", names(all))
names(all) <- gsub("Acc","Accelerometer", names(all))
names(all) <- gsub("gravity", "Gravity", names(all))
names(all) <- gsub("Mag", "Magnitude", names(all))

# Clean up special characters and typos
names(all) <- gsub("BodyBody","Body", names(all))
names(all) <- gsub("-", "", names(all))


# Step 5 - From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
# Load reshape2 library for melt and dcast functions (Lecture 4) as well as dplyr for %>%
suppressMessages(library(dplyr))
suppressMessages(library(reshape2))

allMean <- melt(all, id = c("Subject","Activity")) %>% dcast(Subject + Activity ~ variable, mean)

# Write Data
write.table(allMean, "tidy_data_set.txt", row.names = FALSE, quote = FALSE)






