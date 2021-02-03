f = "household_power_consumption.txt"
setwd("~/Desktop")
readfile = read.table(f, sep=";", header=TRUE, na.strings="?")
library(lubridate)
library(dplyr)
readfile <- readfile %>% 
  filter(Date == "1/2/2007"|Date == "2/2/2007")  %>%
  mutate(completetime = paste(Date, Time))
readfile$completetime <- dmy_hms(readfile$completetime)
readfile <- readfile[,c(-1,-2)]
rgather <- readfile[,5:8] %>% 
  gather(sub_m, metering, -completetime)
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
with(readfile,{
  plot(completetime, Global_active_power, type="l",
       xlab = "datetime",
       ylab = "Global Active Power")
  plot(completetime, Voltage, type="l",
       xlab = "datetime",
       ylab = "Voltage")})
with(rgather,plot(completetime, metering, type = "n",
                  xlab = "datetime",ylab = "Energy sub metering"))
with(subset(rgather, sub_m=="Sub_metering_1"), lines(completetime, metering))
with(subset(rgather, sub_m=="Sub_metering_2"), lines(completetime, metering, col="red"))
with(subset(rgather, sub_m=="Sub_metering_3"), lines(completetime, metering, col="blue"))
legend("topright", legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lty=1,col = c("black","red","blue"))
with(readfile,{
  plot(completetime, Global_reactive_power, type="l",
       xlab = "datetime",
       ylab = "Clobal_reactive_power")})
dev.off()
