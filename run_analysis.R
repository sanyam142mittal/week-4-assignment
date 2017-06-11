library(dtplyr)
x_train<-read.table("UCI HAR Dataset/train/x_train.txt")
y_train<- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")


x_test<-read.table("UCI HAR Dataset/test/x_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#Merges the Test and Training data set to create one data set
x_train_test <- rbind(x_train,x_test)
y_train_test <- rbind(y_train,y_test)
subject_train_test <- rbind(subject_train,subject_test)

#Extract Mean and Standard Deviation fields
required_columns <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
x_train_test <- x_train_test[,required_columns[,1]]

#Use Descriptive activity names to name the activities in data set
colnames(y_train_test) <- "activity"
y_train_test$activitylabel<-factor(y_train_test$activity,labels=as.character(activity_labels[,2]))
activitylabel <- y_train_test[,-1]

#Appropriatly labels the data set with descriptive variable names
colnames(x_train_test) <- features[required_columns[,1],2]

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(subject_train_test) <- "subjects"
tidydataset<-cbind(x_train_test,activitylabel,subject_train_test)
dttidydataset <- data.table(tidydataset)
meantidydataset <-dt[,lapply(.SD,mean,na.rm=TRUE),by=list(activitylabel,subjects)]



