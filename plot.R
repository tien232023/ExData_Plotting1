# loading a subset of very large data into R using SQL commands, instead of loading
# the entire dataset and then subsetting it
library(dplyr)
library(sqldf)
library(lubridate)
colClass <- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", nrows = 10) %>%
            sapply(class) # find out colClasses to accelerate the reading process
selectCommand <- "SELECT * FROM file WHERE Date=\"1/2/2007\" OR Date=\"2/2/2007\"" # beware of the format in the original dataset!
mydf <- read.csv.sql("./household_power_consumption.txt",
               sql=selectCommand,
               header = TRUE,
               sep=";", # beware of the separator in original dataset!
               colClasses=colClass) 
closeAllConnections() # remember to close the connections, or an error will occur!


# convert the "Date" and "Time" variables to Date/Time classes
household <- mutate(mydf, Time=strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"),
                    Date=strptime(Date, "%d/%m/%Y")) 
                    # Originally, Date and Time are both of character class when read in.
                    # beware of the variable order: the first calculated one will affect the following calculated ones.
                    # If we first transform Date, then Date become of Date class, and then we can't paste something of Date class with characters (Time)                                


# plot figure 1
png("./plot1.png", width = 480, height = 480, units = 'px')
hist(household$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")
dev.off()


# plot figure 2
png("./plot2.png", width = 480, height = 480, units = 'px')
Sys.setlocale(category = "LC_ALL", locale = "english")
plot(household$Time, household$Global_active_power,
     type = 's', # Don't mistake plot2 as of barplot (with inner borders); it is a "stair" plot (no inner border)
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()
    

# plot figure 3
png("./plot3.png", width = 480, height = 480, units = 'px')
with(household, plot(Time, Sub_metering_1, type='s', col='black', ylab="Energy sub metering"))
with(household, lines(Time, Sub_metering_2, type='s', col='red'))
with(household, lines(Time, Sub_metering_3, type='s', col='blue'))         
with(household, legend("topright", lty = 1, col = c('black', 'red', 'blue'), 
                       legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')))
dev.off()


# plot figure 4
png("./plot4.png", width = 480, height = 480, units = 'px')
par(mfrow=c(2,2))
# the first subplot
with(household, plot(Time, Global_active_power,
                     type = 's',
                     xlab = "",
                     ylab = "Global Active Power (kilowatts)"))
# the second subplot
with(household, plot(Time, Voltage,
                     type = 's',
                     xlab = 'datetime',
                     ylab = 'Voltage'))
# the third subplot
with(household, plot(Time, Sub_metering_1, type='s', col='black', ylab="Energy sub metering"))
with(household, lines(Time, Sub_metering_2, type='s', col='red'))
with(household, lines(Time, Sub_metering_3, type='s', col='blue'))         
with(household, legend(box.lty=0, bg="transparent", "topright", lty = 1, col = c('black', 'red', 'blue'), 
                       legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')))
# the fourth subplot
with(household, plot(Time, Global_reactive_power,
                     type = 's',
                     xlab = 'datetime',
                     ylab = 'Global_reactive_power'))
dev.off()





     