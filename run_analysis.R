# Getting and Cleaning Data Peer Assessments
# This code prepares tidy data from - Human Activity Recognition 
# Using Smartphones Data Set that can be used for later analysis

# reading training data 
x.train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y.train<-read.table("./UCI HAR Dataset/train/y_train.txt")
s.train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading test data 
x.test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y.test<-read.table("./UCI HAR Dataset/test/y_test.txt")
s.test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading in the features - variable names
feature.name<-read.table("./UCI HAR Dataset/features.txt")

# combining all three - traning set + training label + subject
training.data = cbind(x.train,y.train,s.train)

# combining all three - - test set + test label + subject
test.data = cbind(x.test,y.test,s.test)

# combining training data and test data to masterdata
master.data = rbind(training.data,test.data)

# combining the variable names 
variable.names = c(as.character(feature.name[,2]),"activity.labels","subject")

# cleaning the variable names 
variable.names = make.names(variable.names)

# setting the column names
names(master.data) = variable.names

# Using descriptive activity names to name the activities in the data set
descriptive.activity.names = read.table("./UCI HAR Dataset/activity_labels.txt")
for (i in 1:length(descriptive.activity.names$V1)){
        master.data$activity.labels[master.data$activity.labels == i] = 
                as.character(descriptive.activity.names$V2[i])
}
master.data$activity.labels = as.factor(master.data$activity.labels)

# Extracting only the measurements on the 
# mean and standard deviation for each measurement by checking in variable name
master.data.meanSD = master.data[grepl("std",names(master.data), ignore.case = TRUE) 
                                 + grepl("mean",names(master.data), ignore.case = TRUE)]
#str(master.data.meanSD)


# Creating a second, independent tidy data set 
# with the average of each variable for each activity and each subject. 
library(reshape)
library(reshape2)
master.data.meanSD$subject = master.data$subject
master.data.meanSD$activity.labels = master.data$activity.labels
master.data.melt = melt(master.data.meanSD,id=c("subject","activity.labels"))
master.data.mean = dcast(master.data.melt, subject + activity.labels  ~ variable,mean)

# Creating datasets as text files
write.table(master.data,"TidyData.txt")
write.table(master.data.meanSD,"MeanAndStandardDeviation.txt")
write.table(master.data.mean,"VariableAverages.txt")

