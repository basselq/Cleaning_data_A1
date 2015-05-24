

# read the variable names to label the data
activity_label <- read.table("activity_labels.txt",stringsAsFactors=FALSE)

setwd("./test")

sbj_tst<- read.table("subject_test.txt") # the testing subjects
y_tst <- read.table("y_test.txt") # the testing activities
x_tst<- read.table("X_test.txt") # the testing variables


#replace the activity number by the activity name  (Q3a)
for (i in 1:6){
  y_tst[y_tst==i]<- activity_label[[i,2]]
}


#merging the tesing data into one table  
test <- cbind(sbj_tst,y_tst,x_tst)


setwd("../train/")
sbj_trn <- read.table("subject_train.txt") # the training subjects
y_trn <- read.table("y_train.txt") # the training activities
x_trn <- read.table("X_train.txt")  # the training variables

#replace the activity number by the activity name (Q3b)
for (i in 1:6){
  y_trn[y_trn==i]<- activity_label[[i,2]]
}

#merging the training data into one table
train <- cbind(sbj_trn,y_trn,x_trn)

# merging the traing and the testing data (Q1)
merged <- rbind(test,train)

# read the variable names to label the data  (Q4)
setwd("../")
vars <- read.table("features.txt",stringsAsFactors=FALSE)
V<- vars[,2]
cnames <-c("Subject","Activity",V)
colnames(merged)<- cnames             #assining the col. names : end of (Q4)


#for Q2
#col is TRUE for the colomns that we will keep (mean and standard_deviation)
# ignore.case will guarantee including capital and small letters ("Mean" == "mean")
Col<- grepl("mean",V,ignore.case=TRUE) | grepl("std",V,ignore.case=TRUE)  
# append for the first two colomns (to keep subjects and activities)
Col<- c(TRUE,TRUE,Col)

extracted <- merged[,Col] # end of Q2
# ordering by subject and then by activity (not important step)
extracted<-extracted[order(extracted$Subject,extracted$Activity),]

# Q5
library(dplyr)
tidy<-group_by(extracted, Subject, Activity) %>% summarise_each(funs(mean))


write.table(tidy,file="Tidy.txt",row.name=FALSE)
