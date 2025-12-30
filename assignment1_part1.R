library(data.table)

#Setting the working directory to the current file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#The library I'm importing here simply gets the path of the current file in RStudio to set the working directory to the current file location.
#This is useful for importing the datasets from the same folder as the script.

# Importing datasets from csv
gdp_data <- as.data.table(read.csv('API_NY.GDP.PCAP.KD_DS2_en_csv_v2_76156.csv', skip = 4))
saving_data <- as.data.table(read.csv('API_NY.GNS.ICTR.ZS_DS2_en_csv_v2_76153.csv', skip = 4))
pop_data <- as.data.table(read.csv('API_SP.POP.GROW_DS2_en_csv_v2_87.csv', skip = 4))

# Drop the X column that appears due to the read.csv function
gdp_data$X <- NULL
saving_data$X <- NULL
pop_data$X <- NULL

#Melt the datasets
gdp_data <- melt(gdp_data, id.vars = c("Country.Name"), measure.vars = patterns("^X"), variable.name = "Year", value.name = "GDP_per_capita")
saving_data <- melt(saving_data, id.vars = c("Country.Name"), measure.vars = patterns("^X"), variable.name = "Year", value.name = "savings_rate")
pop_data <- melt(pop_data, id.vars = c("Country.Name"), measure.vars = patterns("^X"), variable.name = "Year", value.name = "population")

#Remove X prefix and change Year to int
gdp_data[, Year := as.integer(sub("^X", "", Year))]
saving_data[, Year := as.integer(sub("^X", "", Year))]
pop_data[, Year := as.integer(sub("^X", "", Year))]

#Merge the datasets
data <- merge(gdp_data, saving_data, by = c("Country.Name", "Year"))
data <- merge(data, pop_data, by = c("Country.Name", "Year"))

#Check NAs by country
na_count_country <- data[, .(na_gdp = sum(is.na(GDP_per_capita)), na_saving = sum(is.na(savings_rate)), na_growth = sum(is.na(population))), by = Country.Name]
na_count_country

#Drop countries with more than 30% NAs in any category
num_years = length(unique(data$Year))
threshold = 0.3*num_years
data <- data[Country.Name %in% na_count_country[na_gdp < threshold & na_saving < threshold & na_growth < threshold, Country.Name]]

#Check NAs by year
na_count_year <- data[, .(na_gdp = sum(is.na(GDP_per_capita)), na_saving = sum(is.na(savings_rate)), na_growth = sum(is.na(population))), by = Year]
na_count_year

#Drop years with more than 30% NAs in any category
num_countries = length(unique(data$Country.Name))
threshold = 0.3*num_countries
data <- data[Year %in% na_count_year[na_gdp < threshold & na_saving < threshold & na_growth < threshold, Year]]

#Sanity check of NA counts
sum(is.na(data$GDP_per_capita))
sum(is.na(data$savings_rate))
sum(is.na(data$population))

#Estimating NA values using country-specific mean
data[, GDP_per_capita := ifelse(is.na(GDP_per_capita), mean(GDP_per_capita, na.rm = TRUE), GDP_per_capita), by = Country.Name]
data[, savings_rate := ifelse(is.na(savings_rate), mean(savings_rate, na.rm = TRUE), savings_rate), by = Country.Name]
data[, population := ifelse(is.na(population), mean(population, na.rm = TRUE), population), by = Country.Name]

#Removing negative values since we are taking logs
data <- data[GDP_per_capita > 0 & savings_rate > 0 & population > 0]

#Running the regression
regression <- lm(log(GDP_per_capita) ~ log(savings_rate) + log(population), data = data)
summary(regression)
