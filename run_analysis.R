library(dplyr)

# read test data  
subject_test<-read.table("subject_test.txt")
y_test<-read.table("y_test.txt")
x_test<-read.table("X_test.txt")

#read train data
x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
subject_train<-read.table("subject_train.txt")

# read features
features<-read.table("features.txt")

#read activitylabels
activity<-read.table("activity_labels.txt")

#rename the column names of test,train and activitylabels
colnames(x_test)<-features[,2]
colnames(y_test)<-"activityid"
colnames(subject_test)<-"subjectid"
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityid"
colnames(subject_train)<-"subjectid"
colnames(activity)<-c("activityid","activitylabels")

#merge the data of test
test_merg<-cbind(x_test,y_test,subject_test)

#merge the data of train
train_merg<-cbind(x_train,y_train,subject_train)

#merge the data of test and train
total_data<-rbind(test_merg,train_merg)

#find mean and standard deviation
mean_sd<-(grepl("activityid" , colNames) | grepl("subjectid" , colNames) | grepl("mean.." , colNames)| grepl("std.." , colNames))
setForMeanAndStd <- total_data[ , mean_sd == TRUE]

#create set with activity names
setWithActivityNames = merge(setForMeanAndStd, activity, by='activityId', all.x=TRUE)

# create a new tidy data set with the average of each variable for each activity and each subject.
group<-setWithActivityNames %>% group_by(activityid,subjectid)%>%summarize_each(funs(mean))
write.table(group, "secondTidySet.txt", row.name=FALSE)
