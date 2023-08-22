/******************************************************************************
Title: 	Coding Best Practices Lab, Latex advisture				
Last Modified by: Jack Cavanagh (jcavanagh@povertyactionlab.org)	
Date Created: 08/20/2023	
Description: Interactive do-file for RST participants to work on outputting reproducible latex tables from Stata		 							
*****************************************************************************/
/// SET YOUR DIRECTORY IN A REPRODUCIBLE WAY WOO
di "`c(username)'"
if c(username) == "jackcavanagh" { 
	cd "/Users/jackcavanagh/Documents/CBP_Lab"
}


************************ DO NOT WORRY ABOUT THIS *******************************
cap file close f
file open f using "Latex_task/Final_Output.tex", write replace

file write f "\documentclass[12pt]{article}" _n "\usepackage[utf8]{inputenc}" _n "\usepackage{geometry,etoolbox,breakcites,cite,hyperref,dsfont,amssymb,rotating,booktabs,array,ragged2e,breqn,morefloats,chngcntr,tabularx,lipsum,titling,lscape,multirow,longtable,pdflscape}" _n "\begin{document}" _n

use "Data/baseline.dta", clear
ren s2_4_work_days_num work_days
ren s3_9_1_sleep_hrs_last_mm hrs_slp
ren s3_2_issue_name_2 fever
ren s7_9_parti_light_sports_tm light_sports
ren ucla_loneliness_index ucla
************************** START HERE ******************************************
/* WELCOME TO THE LATEX CODING BEST PRACTICES LAB. Your goal is to edit this do-file to allow it to output reproducible statistics in well-formatted latex. Because the previous RA on the project, Sloppy Steve, was in a rush to get off the project, he left things a bit of a mess: there's some code to output basic counts, summary statistics, and a regression table to a latex file, but most of the statistics are hard-coded in! Now the data has changed a bit, and you want to take this opportunity to make the whole thing more reproducible. Follow the prompts below to create a script that would output exactly what is found in the "Final_Product.tex" file in the folder. */


************** PART 1: LET'S COUNT!
/* The first part is some basic tabulation. The PIs want to know how many elders fit into the following age bins: X<60; 60<= X < 80; 80 < X. Sloppy Steve wrote the following code to count the groups: */

count if age <60


count if age >= 60 & age <80


count if age >=80 


*** Question 1a: add in code to the above section that lets us store the counts in different locals named for the bin. 


// HINT: Stata stores values from commands in r() locals. To find out what is stored with count, run "help count" 


// HINT: Remeber that you can initiate a local with the syntax "local NAME = [VALUE]"



*** Question 1b: The counts were exported to the latex file here. Replace the hard-coded numbers with your locals to make it more reproducible!

file write f _n "\section{Counts}" _n "Count of elders in the following age bins:\\ " _n 

file write f "Less than 60: 2 \\" _n
file write f "Between 60 and 80: 26 \\" _n
file write f "Over 80: 3 \\" _n


// HINT: Stata allows you to embed locals within strings, but you have to wrap their names a certain way to let stata know it should check for locals!
// HINT: the "_n" is the way we tell Stata to start a new line in the file we're writing. The \\ tells latex to start a new line.


************** PART 2: SUMM STATS
/* The next part moves on to summary statistics. The PIs want to know the mean, standard deviation, and median of number of days worked over the last week, and they are persnickity about formatting, and so want them in a bulleted list. The code below is hardcoded, and only exports the first two! */

summ work_days, detail
local mean = `r(mean)'
local sd = `r(sd)'

di "`mean'"
di "`sd'"

file write f _n "\section{Summ stats}" _n "Summary stats for days worked" _n 


**** How do we make mean and SD reproducible, and add in median?
file write f "\begin{itemize}" _n "\item Mean: 21.297" _n "\item SD: 5.786"

file write f _n "\end{itemize}" _n

// BONUS: Stata default is to output a whole string of significant digits. Can you output rounded numbers?

************** PART 3: REGRESSION OUTPUT
/* Finally, the PIs want to see the results of a regression of both days worked and hours slept at night on age, having a fever, any light sport, per capita consumption, and the ucla loneliness index, but all individually (no one knows why). They want to see the results in a table similar to those you'd find in academic papers -- outcomes as the column index and independent variables as the horizontal index, with estimates in one row and standard errors in the next. The code below runs the the regressions and creates the table, but only outputs a hardcoded regression the PIs don't care about anymore! */

file write f _n "\section{Regression output}"_n "\begin{tabular}{lcc}" _n "\hline" _n " \hline" _n " Independent var  &  Days worked & Hours slept \\"_n "\hline" _n 

reg work_days gdi_score
file write f "work_days & 207.58 &\\" _n "& (75.13) &\\" _n


global outcomes work_days hrs_slp
global independents age fever light_sports percap_hh_c ucla

foreach yvar in $outcomes{
	foreach xvar in $independents{
		reg `yvar' `xvar'
		// HINT: You may want to add some locals here to capture certain statistics from the regression??
		
		
	}	
	
}
	// HINT: What if you used a similar for loop to make the process of writing each line of the table easier?


******** Bonus question! If you completed all of the above, try adding p-value stars (*** for <=.01, ** for >.01 & <=.05, so on) to the table automatedly



file write f "\hline" _n "\hline" _n "\end{tabular}" _n


************************ DO NOT WORRY ABOUT THIS *******************************
file write f _n"\end{document}"
file close f
