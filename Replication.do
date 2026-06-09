*Examining Data 
describe 
*To verify unique key
isid slno
summarize slno
codebook 
*For examining and identifying outliers in more detail 
*These are the only variables used because tehy a re teh only variable swhich could be compared 
local varlist i1_age i4_hh_mem i5_educ i9_hh_income
foreach  var of local varlist {
graph box `var',title("Boxplot of `var'")
graph export "plots/`var'.png",replace
}
*Creates box plot o fmanin contro variabels 
*For checking misiing values 
misstable summarize 
Only 1 msiing for vaue otehr msiisng values fir twith tyoe of treatment 

*For Table 1 
*For occupation 
tab i7_occupation 
tab i7_occupation if extension == 1
tab i7_occupation if extension == 2
tab i7_occupation if extension == 3

*For continuous variables 

*For means of charcateristisc varibles acros ages
 estpost tabstat i1_age i4_hh_mem i5_educ income_TRS  literate membership_month ,by(extension) statistics(mean sd count ) columns(stati
> stics) listwise
 esttab,main(mean) aux(sd) b(2) nostar unstack label


*For getting p values of the F statistisc 
local varlist i1_age i4_hh_mem i5_educ income_TRS literate membership_month  

foreach var of local varlist {
    reg `var' ib2.extension
}

*Table 6 
reg s2a_repay_uncond  i1_age i3_relation i4_hh_mem i5_educ literate membership_month,vce(cluster JLG)
outreg2 using table6.doc,replace ctitle("Repayment-Unconditional") label dec(3)
reg s2b_repay_cond  i1_age i3_relation i4_hh_mem i5_educ literate membership_month,vce(cluster JLG)
outreg2 using table6.doc,append ctitle("Repayment-conditional-peer repays") label dec(3)
reg s2c_repay_cond  i1_age i3_relation i4_hh_mem i5_educ literate membership_month,vce(cluster JLG)
outreg2 using table6.doc,append ctitle("Repayment-Conditional-peer defaults") label dec(3) addnote("Notes: Dependent variable: Repayment – binary variable equal to 1 if participant repays, 0 if participant defaults. (1) Unconditional repayment without knowledge of partner’s repayment decision in the standard game. (2) Conditional repayment given that the partner repays in the standard game. (3) Conditional repayment given that the partner defaults in the standard game. (4) Unconditional repayment decision in the treatment game. Standard errors in parentheses and clustered at the joint-liability-group (JLG) level.")

*Variable Creation 


*Figure 6 
graph bar (mean) always_repayers always_defaulters reciprocal_borrowers converse_borrowers ///
    bar(1, color(gs0)) bar(2, color(gs4)) bar(3, color(gs8)) bar(4, color(gs12)) ///
    ytitle("Repayment share (in %) of Borrowers in Standard Game")  ///
    title("Figure 6: Repayment Type in Standard Game")

	
	
*Table 2 
tabout s2a_repay_uncond s2b_repay_cond s2c_repay_cond s3_repay_belief extension using Table22.docx, replace ///
    c(mean s2a_repay_uncond mean  s2b_repay_cond mean s2c_repay_cond s3_repay_belief se) sum ///
    f(2) clab("") npos(none) style(tab) font(bold) ///
    topf("Standard Games")

	
	
	
*Table 2 Another attempt 
tabout s2a_repay_uncond s2b_repay_cond s2c_repay_cond s3_repay_belief extension ///
using Table22.docx, replace ///
    c(mean  s2a_repay_uncond s2b_repay_cond s2c_repay_cond s3_repay_belief se) f(2) clab("") npos(none) style(tab) font(bold) sum ///
    topf("Standard Games")
	
*Table 2 reshaping approach 
preserve
reshape long s2a_repay_uncond s2b_repay_cond_yes s3c_repay_cond_no s3_repay_belief, i(code) j(stage) string 


*Gettig pvalues for Table2 
local varlist s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief   

*Creating varibles fo figure 6 
gen always_repayers = s2b_repay_cond_yes == 1 & s2c_repay_cond_no== 1 
gen always_defaulters = s2b_repay_cond_yes == 0 &  s2c_repay_cond_no == 0 
gen  reciprocal_borrowers = s2b_repay_cond_yes == 1 & s2c_repay_cond_no == 0
gen converse_borrowers =  s2b_repay_cond_yes == 0 &  s2c_repay_cond_no == 1

gen borrower_type = . 
replace borrower_type =  1 if always_repayers== 1 
replace borrower_type = 2  if always_defaulters == 1
replace borrower_type = 3 if reciprocal_borrowers== 1
replace borrower_type = 4 if converse_borrowers == 1  

label define repay_lbl 1 "Always Repay" 2 "Never Repay" 3 "Reciprocal repay" 4"Converse Repay"
label values borrower_type repay_lbl 


graph bar (count), over(borrower_type,label)  asyvars  ///
    bar(1, color(gs4)) bar(2, color(gs12)) bar(3, color(gs8)) bar(4, color(gs2)) ///
	bargap(30) ///
    ytitle("Repayment share (in %) of Borrowers in Standard Game")  ///
    title("Figure 6: Repayment Type in Standard Game") ///\
	legend(off)
	graph export "Fig6.png"

*Table 2 tabstat approach 

estpost tabstat s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief,by(extension) statistics(mean sd count ) columns(statistics) listwise 
esttab,main(mean) aux(sd) b(2) nostar unstack label ///
mtitles("Peer Peeking" "Peer Punishment" "Peer peeking-cum-punishment" "Total" )


*Table2 seperate esttab + etspost appoach 
estpost tabstat s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief if extension == 2 ,statistics(mean sd ) columns(statistics) listwise 
est store m2

estpost tabstat s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief if extension == 1, statistics(mean sd ) columns(statistics) listwise 
est store m3

estpost tabstat s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief if extension == 3 ,statistics(mean sd ) columns(statistics) listwise 
est store m4

estpost tabstat s2a_repay_uncond s2b_repay_cond_yes s2c_repay_cond_no s3_repay_belief  ,statistics(mean sd ) columns(statistics) listwise 
est store total 

esttab total m2 m3 m4 , ///
    main(mean) aux(sd) b(2) ///
    label ///
    mtitles("All groups" "Peer Peeking-cum-Punishment" "Peer Peeking" "Peer Punishment" ) ///
    title("Table 2: Decisions on repayment, peer peeking, and peer punishment") 


	

	
   


	



	
    

    





