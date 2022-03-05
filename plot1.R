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
