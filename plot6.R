#
# plot 6
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##
## Prepare Data
##
## Baltimore City: fips=="24510"
## Los Angeles:    fips=="06037"
library(dplyr)
# convert `SCC`column to character for joining the tables
NEI <- transform(NEI, SCC = as.character(SCC))
SCC <- transform(SCC, SCC = as.character(SCC))
# join tables and filter
df <- left_join(NEI, SCC) %>% 
    filter(grepl("Vehicle", EI.Sector, fixed = TRUE)) %>%
    filter(fips=="24510" | fips=="06037") %>%
    mutate(city = factor(fips, levels = c("24510", "06037"), labels = c("Baltimore City", "Los Angeles"))) %>%
    arrange(fips, year, EI.Sector) %>%
    select(fips, city, Emissions, year, type, SCC, EI.Sector)

# split dataset for the two cities
pm0 <- df %>% filter(fips=="24510")
pm1 <- df %>% filter(fips=="06037")


##
## Plotting
##
library(ggplot2)
png(filename = "plot6.png")

ggplot(df, aes(year, Emissions)) +
    labs(title = "Emissions 'Baltimore City' vs. 'Los Angeles' (1999 to 2008)",
         x = "Year", y = "PM2.5 Emissions [tons]") +
    geom_point(color = "black", size = 3, alpha = 1/2) + 
    coord_cartesian(ylim = c(0, 50)) +  # include outliers (see 'qqplot2'-PDF, "Axis Limits")
    facet_grid(. ~ city) +
    geom_smooth(method = "lm")

dev.off()
