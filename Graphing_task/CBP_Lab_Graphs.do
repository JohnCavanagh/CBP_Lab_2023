/******************************************************************************
Title: 	Coding Best Practices Lab, Latex advisture				
Last Modified by: Jack Cavanagh (jcavanagh@povertyactionlab.org)	
Date Created: 08/20/2023	
Description: Interactive do-file for RST participants to work on outputting reproducible graphs from Stata		 							
*****************************************************************************/
/// SET YOUR DIRECTORY IN A REPRODUCIBLE WAY WOO
di "`c(username)'"
if c(username) == "jackcavanagh" { 
	cd "/Users/jackcavanagh/Documents/CBP_Lab"
}


************************ IMPORTING DATA *******************************
use "Data/baseline.dta", clear
************************** START HERE ******************************************
/* WELCOME TO THE STATA GRAPHING CODING BEST PRACTICES LAB. Your goal is to edit this do-file to do two things: i) make the graph below into the best-possible version of itself based on our data vis principles; ii) (if time) make it into the worst possible version of itself based on our data vis principles. The data we'll be using is a baseline for a study involving elderly individuals in Tamil Nadu. The PIs on the project asked for a simple graph of loneliness score by age. The simplest way to produce this is coded below, but Stata has a rich set of options for improving graphs. Some (but certainly not all) are included as hints!
 */
 
 
graph twoway bar ucla_loneliness_score age
 
/* We can take some information away from this, but obviously there are a lot of problems here! Let's take two and solve them together. It's important to remember while graphing that some fixes involve changes to the graph code, but some might be more easily done by cleaning the data! 

Let's start with the latter: one problem with the graph is that there are too many bars. Many overlap with each other and we can't tell which is which, leading the graph to be pretty non-informative. We can solve this by grouping our x-axis variable, age, into bins: */

gen age_bins = "<50" if age <50
replace age_bins = "[50-59]" if age >= 50 & age < 60
replace age_bins = "[60-69]" if age >= 60 & age < 70
replace age_bins = "[70-79]" if age >= 70 & age < 80
replace age_bins = "[80-89]" if age >= 80 & age < 90
replace age_bins = "[90-99]" if age >= 90 & age < 100
replace age_bins = ">99" if age >99
encode age_bins, gen(age_bins_enc)

graph twoway bar ucla_loneliness_score age_bins_enc

/* This helps draw things down, but now we have uninformative numbers on the x-axis! Let's now work with the actual graph code to add labels */

graph twoway bar ucla_loneliness_score age_bins_enc,xlabel(,valuelabel)

/* Getting there, but there's still a lot of work to be done. Some remaining problems in the graph:

 - It's hard to tell the breakdown of loneliness score by age group -- the splits in the bars do this, but they aren't very intuitive and hard to see.
 - It doesn't have any basic information, like a title or proper axis labels!
 - The color is drab and the bars are close together and homogenous
 - What are we supposed to be taking away from this graph?
 */

