*EXERCISE 1

//end goal - see the bias in the estimate of B1 in a bivariate regression models
//in the presence of a confounder (that might be unmeasured in real life)

//DGP
//with no confounding
clear
set obs 1000
gen i = _n
gen e = rnormal(0,4)
gen Z = rnormal(0,2)
gen X = rnormal(0,2)
gen Y = 1 + 2*X + 2*Z + e

//model to test
regress Y X


//versus with confounding
clear
set obs 1000
gen i = _n
gen e = rnormal(0,4)
gen Z = rnormal(0,2)
gen X = 0.5*Z + rnormal(0,2)
gen Y = 1 + 2*X + 2*Z + e

regress Y X

//bringing together in a loop?
clear
set seed 12345
forvalues B2 = 0/3 { //say the number if higher level units - here just sticking to 5.
clear
set obs 1000

gen e = rnormal(0,4)
gen Z = rnormal(0,2)
gen X = 0.5*Z + rnormal(0,2)
gen Y = 1 + 2*X + `B2'*Z + e
regress Y X

}


*EXERCISE 2

clear
set seed 12345
//cd "C:\Users\Andrew\Google Drive\Teaching\Essex MLM\test"
mat A = (1,2,3,4,5)
mat colnames A = B2true B1 B0 B1se B0se


forvalues B2 = 0/3 { 
forvalues iteration = 1/100 {
clear
set obs 1000 //set the sample size
gen e = rnormal(0,4) //generate the random residual variation
gen Z = rnormal(0,2) //generate the unobserved confounder
gen X = 0.5*Z + rnormal(0,2) //generate the measured variable, a function of the confounder
gen Y = 1 + 2*X + `B2'*Z + e //generate the outcome variable, a function of both X and Z
regress Y X //run the model


mat b = e(b) //extract the beta estimates
mat vars = vecdiag(e(V)) //extract the uncertainty measures - 
//note that these are variances - ie need to take sqrt to get SEs

mat info = `B2' // attach the size of the confounding
mat A = ( A \ info, b, vars ) //combine all together in a matrix

}

mat A = A[2...,.] //remove the top line of the matrix (that is just column nos)
clear 
}

svmat A, names(col) //turn the matrix into data.

replace B0se = sqrt(B0se)
replace B1se = sqrt(B1se) //convert variances to SEs

//we could now calculate some things
//Bias
egen meanB1 =  mean(B1), by(B2true)
gen bias = meanB1 / 2

//RMSE
gen sqerror = (B1 - 2)^2
egen mse = mean(sqerror), by(B2true)
gen rmse = sqrt(mse)

//optimism
gen sqdiff = (B1-meanB1)^2
egen meansqdiff = mean(sqdiff), by(B2true)
gen numerator = sqrt(meansqdiff)
gen SEsq = B1se^2
egen meanSEsq = mean(SEsq), by(B2true)
gen denominator = sqrt(meanSEsq)
gen optimism = numerator / denominator

//make a table illustrating the change in bias
collapse (mean) bias rmse optimism, by(B2true)
graph bar bias, over(B2true)
twoway line bias B2true
twoway line optimism B2true
//etc
