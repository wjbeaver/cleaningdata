############## load the data ############################

if (!file.exists("data")) {
        dir.create("data")
        
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/1_1.zip", method="curl")
        
        unzip("data/1_1.zip", exdir="./data/")
        
}

############## data folder structure ####################

mainFolder<-"./data/UCI HAR Dataset"

testFolder<-paste(mainFolder, "test", sep="/")

trainFolder<-paste(mainFolder, "train", sep="/")

################## labels ####################

# activity labels
fileName<-paste(mainFolder, "activity_labels.txt", sep="/")

activity<-read.table(fileName, sep=" ", col.names=c("Activity_id", "Activity"))

library(dplyr)

activity<-mutate(activity, Activity = tolower(Activity))

# feature labels 
fileName<-paste(mainFolder, "features.txt", sep="/")

feature<-read.table(fileName, sep=" ", colClasses = "character", col.names=c("Feature_id", "Feature"))

feature.clean<-rbind(filter(feature, grepl(".std", Feature)), filter(feature,grepl(".mean", Feature)))

rm(feature)

################### test ###########################

# subject test
fileName<-paste(testFolder, "subject_test.txt", sep="/")

testSubject<-read.table(fileName, sep="", col.names=c("Subject"))

# test labels
fileName<-paste(testFolder, "Y_test.txt", sep="/")

testLabels<-read.table(fileName, sep="", col.names=c("Activity_id"))

# test set
fileName<-paste(testFolder, "X_test.txt", sep="/")

test<-read.table(fileName, sep="")

test.clean<-select(test, as.numeric(feature.clean$Feature_id))

rm(test)

colnames(test.clean)<-feature.clean$Feature

test.clean<-mutate(test.clean, Subject=testSubject$Subject)
test.clean<-mutate(test.clean, Activity = right_join(testLabels, activity)$Activity)

##################### train ##########################

# subject train
fileName<-paste(trainFolder, "subject_train.txt", sep="/")

trainSubject<-read.table(fileName, sep="", col.names=c("Subject"))

# train labels
fileName<-paste(trainFolder, "Y_train.txt", sep="/")

trainLabels<-read.table(fileName, sep="", col.names=c("Activity_id"))

# train set
fileName<-paste(trainFolder, "X_train.txt", sep="/")

train<-read.table(fileName, sep="")

train.clean<-select(train, as.numeric(feature.clean$Feature_id))

rm(train)

colnames(train.clean)<-feature.clean$Feature

train.clean<-mutate(train.clean, Subject=trainSubject$Subject)
train.clean<-mutate(train.clean, Activity = right_join(trainLabels, activity)$Activity)

######################### build cleaned table ##################

clean<-bind_rows(test.clean, train.clean)

clean$Subject<-factor(clean$Subject)

clean$Activity<-factor(clean$Activity)

library(reshape2)

clean.melt<-melt(clean, id_vars=c("Subject", "Activity"))

names(clean.melt)<-c("Subject", "Activity", "Signals", "Value")

clean.sum<- clean.melt %>%
                group_by(Subject, Activity, Signals) %>%
                dplyr::summarize(Mean=mean(Value))

write.table(clean.sum, "clean.txt", row.names=FALSE)
