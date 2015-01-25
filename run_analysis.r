if(!file.exists("./project")){dir.create("./project")}
source <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(source, destfile="./project/data.zip")


unzip(zipfile="./project/Dataset.zip",exdir="./project")


datafolder <- file.path("./project", "UCI HAR Dataset")
rawdata <- list.files(datafolder, recursive=TRUE)
rawdata

activitytest  <- read.table(file.path(datafolder, "test" , "Y_test.txt" ),header = FALSE)
activitytrain <- read.table(file.path(datafolder, "train", "Y_train.txt"),header = FALSE)


subjecttrain <- read.table(file.path(datafolder, "train", "subject_train.txt"),header = FALSE)
subjecttest  <- read.table(file.path(datafolder, "test" , "subject_test.txt"),header = FALSE)

featurestest  <- read.table(file.path(datafolder, "test" , "X_test.txt" ),header = FALSE)
featurestrain <- read.table(file.path(datafolder, "train", "X_train.txt"),header = FALSE)

str(activitytest)
str(subjecttrain)

str(subjecttest)
str(featurestest)
str(featurestrain)

subject.data <- rbind(subjecttrain, subjecttest)
activity.data <- rbind(activitytrain, activitytest)
features.data <- rbind(featurestrain, featurestest)

names(subject.data) <- c("subject")
names(activity.data)<- c("activity")
features.names <- read.table(file.path(datafolder, "features.txt"),head = FALSE)
names(features.data) <- features.names$V2

merge.data <- cbind(subject.data, activity.data)
merge.dataf <- cbind(features.data, merge.data)

subset.features <- features.names$V2[grep("mean\\(\\)|std\\(\\)", features.names$V2)]

subset.names <- c(as.character(subset.features), "subject", "activity" )
data <- subset(merge.dataf,select = subset.names)

str(data)

activity.labels <- read.table(file.path(datafolder, "activity_labels.txt"),header = FALSE)

data$activity <- factor(data$activity);
data$activity <- factor(data$activity,labels=as.character(activity.labels$V2))

head(data$activity,30)

names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))

library(plyr)
tidydata <- aggregate(. ~subject + activity, data, mean)
tatadata <- tidydata[order(tidydata$subject,tidydata$activity),]
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)
