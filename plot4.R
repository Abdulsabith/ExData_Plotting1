library(tidyr)
library(dplyr)

#Checking for directory and downloading data
if (!dir.exists("DataforProject1")){dir.create("DataforProject1")}
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataurl,"DataforProject1/Data.zip")

#Extracting data from Zip folder
unzip(zipfile="DataforProject1/Data.zip",exdir="DataforProject1")

#creating the file path to read in the data file.
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
png(filename = "plot4.png",width = 480, height = 480)

#Setting the no. and arrangement of plots to be shown, along with margins.
par(mfcol=c(2,2),mar=c(4,4,2,1))

#Plotting the top left graph.
plot(reqdata$Datetime,reqdata$Global_active_power,type = "l",ylab="Global Active Power (kilowatts)",xlab="")

#Plotting the bottom left graph
plot(reqdata$Datetime,reqdata$Sub_metering_1,type = "l",ylab="Energy sub metering",xlab="")
lines(reqdata$Datetime,reqdata$Sub_metering_2,type = "l",ylab="Energy sub metering",xlab="",col="red")
lines(reqdata$Datetime,reqdata$Sub_metering_3,type = "l",ylab="Energy sub metering",xlab="",col="blue")
legend("topright",col=c("black","red","blue"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1,bty="n")

#Plotting the top right graph
plot(reqdata$Datetime,reqdata$Voltage,type = "l",ylab="Voltage",xlab="Datetime")

#Plotting the bottom right graph
plot(reqdata$Datetime,reqdata$Global_reactive_power,type = "l",ylab="Global_reactive_power",xlab="Datetime")

dev.off()
