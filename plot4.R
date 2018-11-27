####################################
## 
## Class:  Exploratory Data Analysis
## Project 1:  graph electrical data
## PLOT #4
## 
####################################
##
##  Description:  This script is to read relevant .txt file data into R, then construct a page with 4
##  distinct graphs on one page per specifications (example) provided by instructor.  Then will save 
##  the histogram to .png.
##
##  ---KEY ASSUMPTIONS---:
##      1.) Source file (https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip)
##          is already saved to local directory
##      2.) working directory is appropriately set to the location of the downloaded (and unzipped) source file
##
####################


#########
##  Prep:  Load packages and check if file available in working directory
#########
    library(dplyr)
    library(pryr)
    library(lubridate)
    if(!file.exists("household_power_consumption.txt")){
      download.file(url1, "household_power_consumption.zip", exdir=getwd())
    }

#########
##  Step 1:  Read data into R, then format date and time columns into one date-time column
#########
    sf <- file("household_power_consumption.txt")
    df <- read.table(text = grep("^[1,2]/2/2007", readLines(sf), value=TRUE), sep=";", 
                     header=FALSE, col.names = c("Date", "Time", "Global_active_power", 
                                                 "Global_reactive_power", "Voltage", "Global_intensity",
                                                 "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    df$Date <- as.Date(df$Date, "%d/%m/%Y")
    finalDF <- tidyr::unite(df, "Date.Time", 1:2, sep=", ")
    finalDF$Date.Time <- as.POSIXct(finalDF$Date.Time, format = "%Y-%m-%d, %H:%M:%S")

#########
##  Step 2:  Construct 4 graphs to match the example provided by instructor
#########

    png(filename="plot4.png", width = 480, height = 480, units = "px")
    
#########
##  Step 3:  Save to a .png file named plot4.png
#########
    par(mfcol=c(2,2))
    plot(finalDF$Date.Time, finalDF$Global_active_power, type="l",ylab="Global Active Power", xlab="")
    plot(finalDF$Date.Time, finalDF$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
    lines(finalDF$Date.Time, finalDF$Sub_metering_2, type="l", col="red")
    lines(finalDF$Date.Time, finalDF$Sub_metering_3, type="l", col="blue")
    legend(x="topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"),
           lty=c(1,1,1), lwd=c(2.5,2.5,2.5))
    plot(finalDF$Date.Time, finalDF$Voltage, type="l", xlab="", ylab="Voltage")
    plot(finalDF$Date.Time, finalDF$Global_reactive_power, type="l", xlab="", ylab="Global_reactive_power")
    dev.off()