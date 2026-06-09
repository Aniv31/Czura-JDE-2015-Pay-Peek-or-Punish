*Variable Creation 
tab extension, gen(ex)
rename ex1 ex_monitoring
rename ex2 ex_punishment
rename ex3 ex_combination

gen repay_extension = m4_repay
replace repay_extension=  p2_repay if repay_extension==.
replace repay_extension=  c4_repay if repay_extension==.
label var repay_extension "Unconditional repayment decision in extension game"
label define yesno 1 "yes" 0 "no"
label value repay_extension yesno

gen repay_belief_extension= m5_repay_belief
replace repay_belief_extension= p3_repay_belief if repay_belief_extension==.
replace repay_belief_extension= c5_repay_belief if repay_belief_extension==.
label var repay_belief_extension "Belief about partner's repayment decision in extension"
label value repay_belief_extension yesno

gen mon_belief_extension= m3_monitoring_belief
replace mon_belief_extension= c3_monitoring_belief if mon_belief_extension==.
label var mon_belief_extension "Belief about partner's monitoring decision in extension game" 
label value mon_belief_extension yesno

gen pun_extension=p6_punishment
replace  pun_extension= c9a_punishment_unconditional if  pun_extension==.
label var pun_extension "Punishment decision in extenstion game - unconditional punishment" 
label value pun_extension yesno

gen mon_extension= m2_monitoring
replace mon_extension=c2_monitoring if mon_extension==.
label var mon_extension "Monitoring decision in extension game" 
label value mon_extension  yesno


gen pun_belief_extension=p7a_punish_belief_unconditional
replace  pun_belief_extension= c10a_punish_belief_unconditional if  pun_belief_extension==.
label var pun_belief_extension "Belief about partner's punishment decision in extenstion game - unconditional punishment" 
label value pun_belief_extension yesno