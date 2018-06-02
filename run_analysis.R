#Check if data directory exists, create if it doesn't
if(!file.exists("data")){
    dir.create("data")
}

#Change working directory to data directory, if not already
if (basename(getwd()) != "data" & basename(getwd()) != "UCI HAR Dataset"){
    setwd("data")
}

#Check if the UCI HAR Dataset exists, if not, download and unzip
if(!file.exists("UCI HAR Dataset") & basename(getwd()) != "UCI HAR Dataset"){
    if(!file.exists("UCI_HAR_Dataset.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI_HAR_Dataset.zip")
    }
    unzip("UCI_HAR_Dataset.zip")
}

#Check if current working directory is UCI HAR Dataset, if not, make it so
if (basename(getwd()) != "UCI HAR Dataset"){
    setwd("UCI HAR Dataset")
}

