# global variables go here
print("I am global")

library(shiny)
library(shinythemes)
library(dplyr)
library(hexbin)
library(RColorBrewer)
library(ggplot2)
library(factoextra)
library(RCurl)
library(XML)
library(FITSio)

app_title <- "ZEST analysis using R Shiny"
getCurlOptionsConstants()[["connecttimeout"]]
myOpts <- curlOptions(connecttimeout = 5000)


source("app.R")