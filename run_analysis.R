library(reshape2)

filename <- "Assignment_dataset.zip"

# Download dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, destfile=filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

#Load Training and Testing Dataset
TrainX <-read.table("./UCI HAR Dataset/train/X_train.txt")
TrainY <-read.table("./UCI HAR Dataset/train/y_train.txt")
Train_Subject <-read.table("./UCI HAR Dataset/train/subject_train.txt")
TestX <-read.table("./UCI HAR Dataset/test/X_test.txt")
TestY <-read.table("./UCI HAR Dataset/test/y_test.txt")
Test_Subject <-read.table("./UCI HAR Dataset/test/subject_test.txt")

#Load Features
Feature<- read.table("./UCI HAR Dataset/features.txt")
FeatureNew <-Feature[grep(".*mean.*|.*std.*", Feature[,2]),]

#Load Labels
Label<- read.table("./UCI HAR Dataset/activity_labels.txt")

#Assign appopriate variables name
FeatureNew$V2<-gsub("[()]","",FeatureNew$V2)
FeatureNew$V2<-gsub("-mean","Mean",FeatureNew$V2)
FeatureNew$V2<-gsub("-","",FeatureNew$V2)
FeatureNew$V2<-gsub("std","Std",FeatureNew$V2)

#Pull the required column
C1 <-FeatureNew$V1
TrainX1 <-TrainX[,C1]
TestX1 <-TestX[,C1]

#Merge Training and Testing Dataset
Train <-cbind(Train_Subject,TrainX1,TrainY)
Test <-cbind(Test_Subject,TestX1,TestY)
Dat <-rbind(Train,Test)
colnames(Dat) <-c("Subject",FeatureNew$V2,"Activity")

#Turn merged dataset into factors
Dat$Activity <-factor(Dat$Activity,levels = Label[,1],labels = Label[,2])

#Generate tidy dataset
DatMelt<-melt(Dat,id=c("Subject","Activity"))
DatMean<-dcast(DatMelt,Subject+Activity ~ variable,mean)
write.table(DatMean,"tidy.txt",row.names = FALSE,quote = FALSE)