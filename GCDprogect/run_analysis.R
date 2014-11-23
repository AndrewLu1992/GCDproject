#This is step by step code to gather and clean the dataset downloaded from
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#Assumption: The local PC has installed dplyr package and all the related data are in the working directory.

#read in all original data set
trainData <- read.table(".\\X_train.txt", quote="\"")
trainType <- read.table(".\\y_train.txt", quote="\"")
trainSubject<-read.table(".\\subject_train.txt",quote="\"")
testData <- read.table(".\\X_test.txt", quote="\"")
testType <- read.table(".\\y_test.txt", quote="\"")
testSubject<-read.table(".\\subject_test.txt",quote="\"")
features<-read.table(".\\features.txt", quote="\"")
activityLabels<-read.table(".\\activity_labels.txt", quote="\"")

#merge data in train folder
ActivityLabels<-trainType
Subjects<-trainSubject
trainData<-cbind(Subjects,ActivityLabels,trainData)
#merge data in test folder
ActivityLabels<-testType
Subjects<-testSubject
testData<-cbind(Subjects,ActivityLabels,testData)
#merge test and train data
data<-rbind(trainData,testData)
#make a valid name vector and aasign names
name<-make.names(features$V2,unique=T)
names(data)[1:2]<-c("Subjects","ActivityLabels")
names(data)[3:563]<-name
#select measurements only containing "std" or"mean"
data<-data[,c(1,2,grep("mean|std",name)+2)]
#Uses descriptive activity names to name the activities in the data set
data$ActivityLabels<-as.factor(data$ActivityLabels)
levels(data$ActivityLabels)<-activityLabels$V2

#tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
result<-summarise_each(group_by(data,Subjects,ActivityLabels),funs(mean))
write.table(result,".\\summarizedData.txt",row.names=F)