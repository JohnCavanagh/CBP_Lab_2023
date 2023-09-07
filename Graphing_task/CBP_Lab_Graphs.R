#################################################################
#Title: 	Coding Best Practices Lab, graph advisture				
#Last Modified by: Jack Cavanagh (jcavanagh@povertyactionlab.org)	
#Date Created: 08/20/2023	
#Description: Interactive script for RST participants to work on outputting reproducible graphs from R		 							
#################################################################
rm(list=ls())
library(ggplot2) ## For graphing
library(haven) ## For reading in Stata data

### Reproducibly set working directory woooo
User <- Sys.getenv()["USER"] #### This will get your username
if (User == "jackcavanagh"){ ### PUT YOUR USERNAME HERE WHEN YOU COPY AND PASTE
  ps <- "~/Documents/CBP_Lab" # For importing data
}
setwd(ps)

df <- read_stata('Data/baseline.dta')

# WELCOME TO THE R GRAPHING CODING BEST PRACTICES LAB. 
## Your goal is to edit this do-file to do two things: 
### i) make the graph below into the best-possible version of itself based on our data vis principles; 
### ii) (if time) make it into the worst possible version of itself based on our data vis principles. 
## The data we'll be using is a baseline for a study involving elderly individuals in Tamil Nadu. 
### The PIs on the project asked for a simple graph of loneliness score by age. 
## The simplest way to produce this is coded below, but R has a rich set of options for improving graphs. 
## Some (but certainly not all) are included as hints!

graph <- ggplot(df, aes(y=ucla_loneliness_score,x=age)) +
  geom_col()
graph

#We can take some information away from this, but obviously there are a lot of problems here! 
#Let's take two and solve them together. It's important to remember while graphing that some fixes 
#involve changes to the graph code, but some might be more easily done by cleaning the data! 
  
#Let's start with the latter: one problem with the graph is that there are too many bars. 
#Many overlap with each other and we can't tell which is which, leading the graph to be pretty non-informative.
#We can solve this by grouping our x-axis variable, age, into bins: */
  
df$age_bins <- case_when(
  df$age < 50 ~ "<50",
  df$age >= 50 & df$age < 60 ~ "[50-59]",
  df$age >= 60 & df$age < 70 ~ "[60-69]",
  df$age >= 70 & df$age < 80 ~ "[70-79]",
  df$age >= 80 & df$age < 90 ~ "[80-89]",
  df$age >= 90 & df$age < 100 ~ "[90-99]",
  TRUE ~ ">99"
)

### Lets see what happens now
graph <- ggplot(df, aes(y=ucla_loneliness_score,x=age_bins)) +
  geom_col()
graph

### Better! Let's try to solve one more -- right now the graph seems to be doing sums instead of something
## informative, like a mean. Let's solve that.
df$ucla_loneliness_score <-as.numeric(df$ucla_loneliness_score)
graph <- ggplot(df, aes(y=ucla_loneliness_score,x=age_bins)) +
  geom_bar(stat = "summary", fun = mean) ### The "stat" option in geom_bar tells it how to aggregate the y-var
graph

### Now this is actually telling us something! But there are still a lot of problems, namely:
# It doesn't have any basic information, like a title or proper axis labels!
# The color is drab and the bars are close together and homogenous
# What are we supposed to be taking away from this graph?

