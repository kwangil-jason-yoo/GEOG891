x <- seq(1:20)
sum(x)
#factors can be pain - ordering, leveling
typeof(8675309)
typeof(2)
typeof(integer(12039412))
typeof(true)
typeof(TRUE)
typeof(rep(1,20))
typeof(list(1,2,3, "orange"))
library(tidyverse)
mydf <- read_csv("./data/ne_counties.csv")
summary(mydf)
nrow(mydf)
ncol(mydf)
glimpse(mydf)
mydf$Total
summary(mydf$Total)
hist(mydf$Total)
dplyr::filter(mydf, Total > 10000 & MedHousInc < 40000)
mydf %>% dplyr::filter(., Total > 10000 & MedHouseInc < 40000)

#9/1
library(ggplot2)
glimpse(mydf)
plot(mydf$Total, mydf$TotalUnits)
plot(mydf$Total, mydf$PerCapInc)
hist(mydf$PerCapInc)
hist(mydf$PerCapInc, breaks = 50)
#ggplot
ggplot(mydf, aes(x=Total, y=PerCapInc))
ggplot(mydf, aes(x=Total, y=PerCapInc))+geom_point()
ggplot(mydf, aes(x=Total, y=PerCapInc))+geom_point(color = "dark red")
ggplot(mydf, aes(x=Total, y=PerCapInc))+geom_point(color = "dark red") + theme_bw()
ggplot(mydf, aes(x=Total, y=PerCapInc))+geom_point(color = "dark red") + theme_bw()+labs(x="Total Population", y="Per Capita income", title= "My first ggplot")
ggplot(mydf, aes(x=Total, y=PerCapInc))+geom_point(color = "dark red") + geom_smooth(method = "gim", color = "dark green")+ theme_bw()+labs(x="Total Population", y="Per Capita income", title= "My first ggplot")
#using categorical data
mydf2 <- mydf %>% mutate(sizeCategory = ifelse(Total > 20000, "big", "small"))
summary(mydf2$sizeCategory)
summary(as.factor(mydf2$sizeCategory))
ggplot(mydf2, aes(x = Total, y = PerCapInc)) + geom_point(aes(shape = sizeCategory, color = sizeCategory), size =3) + labs(x = "Total Population", y= "Per capita income", title = "My formatted ggplot")
mydf2 %>% ggplot(., aes(x = sizeCategory, y = PerCapInc)) + geom_boxplot(aes(fill = sizeCategory)) + theme_dark() + labs(x= "Categorical Size", y="Per capita income", title = "I made a boxplot", subtitle = "it's handy")
#create 
myfirstfunction <- function(x, y){
  return(x + y)
}
myfirstfunction(3,6)
#wildcard Friday
#task1
task1 <- function(x , y){
  return (x %% 2 == y %% 2)
}
task1(2,5)
task1(1.11,5)
task1(2,2)
#task2
install.packages("rgdal")
install.packages("raster")
library(rgdal)
library(raster)
task2 <- raster::raster("./data/ts_2016.1007_1013.L4.LCHMP3.CIcyano.MAXIMUM_7day.tif")
plot(task2)
summary(task2)
?raster
#classification - match low medium high ... 
#count
