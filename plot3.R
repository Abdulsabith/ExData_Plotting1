library(tidyr)
library(dplyr)

#Checking for directory and downloading data
if (!dir.exists("DataforProject1")){dir.create("DataforProject1")}
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataurl,"DataforProject1/Data.zip")

#Extracting data from Zip folder
unzip(zipfile="DataforProject1/Data.zip",exdir="DataforProject1")

#creating the file path to read in the data file
datafilepath <- file.path("DataforProject1" , "household_power_consumption.txt")

#reading in the data
datainput <- read.table(datafilepath,header=TRUE,sep=";",stringsAsFactors = FALSE)

#subsetting the data for the required date range
reqdata <- subset(datainput,Date=="1/2/2007"|Date=="2/2/2007")

#Concatenating date and time columns into a single column called Datetime
reqdata$Datetime <- paste(reqdata$Date,reqdata$Time,sep = " ")
reqdata$Datetime <- as.POSIXct(strptime(reqdata$Datetime,format = "%d/%m/%Y %H:%M:%S"))

#converting the numbers to numeric class
reqdata[,3:9] <- reqdata[,3:9] %>% mutate_if(is.character,as.numeric)

#opening png file device
png(filename = "plot3.png",width = 480, height = 480)

#Plotting the Sub_metering_1 readings on Y axis, against Datetime on X-axis
plot(reqdata$Datetime,reqdata$Sub_metering_1,type = "l",ylab="Energy sub metering",xlab="")

#Adding plots for sub_metering_2 and sub_metering_3, along with a legend.
lines(reqdata$Datetime,reqdata$Sub_metering_2,type = "l",ylab="Energy sub metering",xlab="",col="red")
lines(reqdata$Datetime,reqdata$Sub_metering_3,type = "l",ylab="Energy sub metering",xlab="",col="blue")
legend("topright",col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3",lty=1))

dev.off()
