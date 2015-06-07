# Calculate a rough estimate of how much memory the dataset will require in memory
# 2,075,259 rows and 9 columns, assume all variables are numeric (8 bytes/numeric)
Memory_Required = 2075259*9*8/2^20/2^10 * 2
Memory_Required
## If you free memory is greater than x, then it is sufficient
#---------------------------------------------------------------------------------

# Check if "data.txt" exist
# If not, generate "data.txt" with the following codes
if(!file.exists("./data.txt")){
  
  ## Unzip file and save at working directory
  if(!file.exists("./household_power_consumption.txt")){
    household_power_consumption <- read.table(unz("exdata_data_household_power_consumption.zip",
                                                  "household_power_consumption.txt"), sep = ";", header = T)
    write.table(household_power_consumption, file = "./household_power_consumption.txt",
                quote = F, sep = ";", row.names = F)
    closeAllConnections()
    rm(household_power_consumption)
  }
  
  ## 1. Read the first 10 rows of the dataset
  initial <- read.table("household_power_consumption.txt", sep = ";", header = T, nrows = 10)
  
  ## 2. Read lines and form a data with Date equals to "1/2/2007" and "2/2/2007"
  fileLink <- "household_power_consumption.txt"
  start <- grep("1/2/2007", readLines(file(fileLink, "r")))[1]
  end <- grep("3/2/2007", readLines(file(fileLink, "r")))[1]
  closeAllConnections()
  data <- read.table("household_power_consumption.txt", sep = ";", skip = start-1, nrows = end-start)
  
  ## 3. Matching the column names with the initial dataset
  names(data) <- names(initial)
  rm(initial, fileLink, start, end)
  
  ## 4. Creat a Date_Time column
  Date_Time <- as.POSIXlt(paste(as.Date(data$Date, format="%d/%m/%Y"), data$Time, sep=" "))
  data <- cbind.data.frame(Date_Time, data)
  rm(Date_Time)
  
  ## 5. Save data.csv to working directory
  write.table(data, file = "./data.txt", row.names = F) 
  rm(data)
} ## Now "data.txt" has been generated

# 1. read "data.txt" into "data"
data <- read.table("data.txt", header = T, row.names = NULL)

# 2. Open PNG device; create "plot3.png" in working directory
png(filename = "plot3.png", width = 480, height = 480, units = "px")

# 3. Create a plot and send to "plot3.png"
Date_Time <- as.POSIXlt(paste(as.Date(data$Date, format="%d/%m/%Y"), data$Time, sep=" "))
plot(Date_Time, data$Sub_metering_1, type="l", xlab='', ylab="Energy sub metering")
lines(Date_Time, data$Sub_metering_2, col="red")
lines(Date_Time, data$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1), col=c("black", "red", "blue"))

rm(Date_Time)

# Close the PNG file device
dev.off()
