## First, we will check in the colClasses

initial <- read.table("../data/household_power_consumption.txt", nrows=100,
                      sep=";",header=TRUE)

colClasses <- sapply(initial, class)

colClasses[1] <- "character"
colClasses[2] <- "character"

dateOnlyClasses <- colClasses
dateOnlyClasses[2:length(dateOnlyClasses)] <-"NULL"

## Here we will read in only the date column of the file.

temp <- read.table("../data/household_power_consumption.txt",
                   sep=";",header=TRUE,colClasses=dateOnlyClasses)

## Now we identify which rows have the data for the dates that we require

date1 <- "01/02/2007"
date2 <- "02/02/2007"

requiredRows <- (as.Date(temp$Date,"%d/%m/%Y")==as.Date(date1,"%d/%m/%Y"))|(as.Date(temp$Date,"%d/%m/%Y")==as.Date(date2,"%d/%m/%Y"))

## finding the index of the first row in that date range

date1Index <- which(requiredRows)[1]
nRows <- sum(requiredRows)
skip <- date1Index-1

## Now we read in only the required Date data

reqData <- read.table("../data/household_power_consumption.txt",
                      sep=";",header=TRUE,colClasses=colClasses,nrows=nRows,skip=skip)

## get the required date time data
fullDate <- paste(reqData[,1],reqData[,2])
datetime <- as.POSIXct(strptime(fullDate,"%d/%m/%Y %H:%M:%S"))

##  Plot the Required File

png(filename="plot3.png",width=480,height=480,units="px")
with(reqData,plot(datetime,reqData[,7],type="n",xlab="",ylab="Energy sub metering"))
with(reqData,points(datetime,reqData[,7],type="l"))
with(reqData,points(datetime,reqData[,8],type="l",col="red"))
with(reqData,points(datetime,reqData[,9],type="l",col="blue"))
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=1)
dev.off()