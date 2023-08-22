/******************************************************************************
Title: 	Coding Best Practices Lab, Latex advisture				
Last Modified by: Jack Cavanagh (jcavanagh@povertyactionlab.org)	
Date Created: 08/20/2023	
Description: Interactive do-file for RST participants to work on outputting reproducible latex tables from Stata		 							
*****************************************************************************/
/// SET YOUR DIRECTORY IN A REPRODUCIBLE WAY WOO
di "`c(username)'"
if c(username) == "jackcavanagh" { 
	cd "/Users/jackcavanagh/Documents/CBP_Lab/Latex_task"
}


************************ DO NOT WORRY ABOUT THIS *******************************
cap file close f
file open f using "Final_Product.tex", write replace

file write f "\documentclass[12pt]{article}" _n "\usepackage[utf8]{inputenc}" _n "\usepackage{geometry,etoolbox,breakcites,cite,hyperref,dsfont,amssymb,rotating,booktabs,array,ragged2e,breqn,morefloats,chngcntr,tabularx,lipsum,titling,lscape,multirow,longtable,pdflscape}" _n "\begin{document}" _n

sysuse auto, clear

************************** START HERE ******************************************
/* WELCOME TO THE LATEX CODING BEST PRACTICES LAB. Your goal is to edit this do-file to allow it to output reproducible statistics in well-formatted latex. Because the previous RA on the project, Sloppy Steve, was in a rush to get off the project, he left things a bit of a mess: there's some code to output basic counts, summary statistics, and a regression table to a latex file, but most of the statistics are hard-coded in! Now the data has changed a bit, and you want to take this opportunity to make the whole thing more reproducible. Follow the prompts below to create a script that would output exactly what is found in the "Final_Product.tex" file in the folder. */


************** PART 1: LET'S COUNT!
/* The first part is some basic tabulation. The PIs want to know how many cars fit into the following price bins: X<5,000; 5,000<= X < 10,000; 10,000 < X. Sloppy Steve wrote the following code to count the groups: */

count if price <5000
local price_low = `r(N)'

count if price >= 5000 & price <10000
local price_med = `r(N)'

count if price >=10000 
local price_high = `r(N)'


*** Question 1a: add in code to the above section that lets us store the counts in different locals named for the bin. 


// HINT: Stata stores values from commands in r() locals. To find out what is stored with count, run "help count" 


// HINT: Remeber that you can initiate a local with the syntax "local NAME = [VALUE]"



*** Question 1b: The counts were exported to the latex file here. Replace the hard-coded numbers with your locals to make it more reproducible!

file write f _n "\section{Counts}" _n "Count of models in the following price bins:\\ " _n 

file write f "Less than 5 thousand dollars: `price_low' \\" _n
file write f "Between 5 and 10 thousand dollars: `price_med' \\" _n
file write f "Over 10 thousand dollars: `price_high' \\" _n


// HINT: Stata allows you to embed locals within strings, but you have to wrap their names a certain way to let stata know it should check for locals!
// HINT: the "_n" is the way we tell Stata to start a new line in the file we're writing. The \\ tells latex to start a new line.


************** PART 2: SUMM STATS
/* The next part moves on to summary statistics. The PIs want to know the mean, standard deviation, and median of mileage, and they are persnickity about formatting, and so want them in a bulleted list. The code below is hardcoded, and only exports the first two! */

summ mpg, detail
local mean = `r(mean)'
local sd = `r(sd)'

di "`mean'"
di "`sd'"

local mean = string(`mean', "%3.2f")
local sd = string(`sd', "%3.2f")
local median = string(`r(p50)', "%3.2f")

file write f _n "\section{Summ stats}" _n "Summary stats for mileage" _n 


**** How do we make mean and SD reproducible, and add in median?
file write f "\begin{itemize}" _n "\item Mean: `mean'" _n "\item SD: `sd'" _n "\item Median: `median'"

file write f _n "\end{itemize}" _n

************** PART 3: REGRESSION OUTPUT
/* Finally, the PIs want to see the results of a regression of both price and displacement on mpg, headroom, weight, and length, but all individually (no one knows why). They want to see the results in a table similar to those you'd find in academic papers -- outcomes as the column index and independent variables as the horizontal index, with estimates in one row and standard errors in the next. The code below runs the the regressions and creates the table, but only outputs a hardcoded regression the PIs don't care about anymore! */

file write f _n "\section{Regression output}"_n "\begin{tabular}{lcc}" _n "\hline" _n " \hline" _n " Independent var  &  Price & Displacement \\"_n "\hline" _n 

//reg price turn
//file write f "turn & 207.58 &\\" _n "& (75.13) &\\" _n


global outcomes price displacement
global independents mpg headroom weight length

foreach yvar in $outcomes{
	foreach xvar in $independents{
		reg `yvar' `xvar'
		// HINT: You may want to add some locals here to capture certain statistics from the regression??
	lincom _b[`xvar'] 
	local `yvar'_`xvar'_e = string(r(estimate), "%3.2f")
	local `yvar'_`xvar'_se = string(r(se), "%3.2f")
	
	
	****** Significance stars (BONUS QUESTION) *******
	local `yvar'_`xvar'_p = string((2 * ttail(e(df_r), abs(r(estimate)/r(se)))), "%3.2f")	
			 if ``yvar'_`xvar'_p' < 0.01 {
				local `yvar'_`xvar'_e = "``yvar'_`xvar'_e'***"
				}

		if ``yvar'_`xvar'_p' < 0.05 & ``yvar'_`xvar'_p' >= 0.01 {
				local `yvar'_`xvar'_e = "``yvar'_`xvar'_e'**"
				}

		 if ``yvar'_`xvar'_p' < 0.1 & ``yvar'_`xvar'_p' >= 0.05 {
				local `yvar'_`xvar'_e = "``yvar'_`xvar'_e'*"
				}

	}	
	
}


	foreach xvar in $independents{
		// HINT: What if you used a similar for loop to make the process of writing each line of the table easier?
	file write f "`xvar' & `price_`xvar'_e' & `displacement_`xvar'_e'\\"_n "& (`price_`xvar'_se') & (`displacement_`xvar'_se')\\"_n
	
	}

******** Bonus question! If you completed all of the above, try adding p-value stars (*** for <=.01, ** for >.01 & <=.05, so on) to the table automatedly



file write f "\hline" _n "\hline" _n "\end{tabular}" _n


************************ DO NOT WORRY ABOUT THIS *******************************
file write f _n"\end{document}"
file close f
