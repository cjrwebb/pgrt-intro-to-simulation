*EXERCISE 1 answers

//DGP
//with no collider bias

clear 
set obs 1000 //set the sample size
gen e = rnormal(0,4) //generate the random residual variation
gen X = rnormal(0,2) 
gen Y = 1 + 2*X + e 
gen Z = rnormal(0,2) //this is where the collider bias would be included

//models to test
regress Y X Z //run the model
regress Y X //run the model


//with collider bias
clear
set obs 1000 //set the sample size
gen e = rnormal(0,4)
gen X = rnormal(0,2)
gen Y = 1 + 2*X + e
gen Z = 1*X + 1*Y + rnormal(0,2) 

regress Y X Z //run the model
regress Y X


//bringing together in a loop
clear
set seed 12345
forvalues B2 = 0/3 { 
clear
set obs 1000 //set the sample size
gen e = rnormal(0,4)
gen X = rnormal(0,2)
gen Y = 1 + 2*X + e
gen Z = 1*X + `B2'*Y + rnormal(0,2) 

regress Y X Z //run the model
regress Y X
}

*EXERCISE 2 -collider - answers
*First for the model that does control for Z
clear
set seed 12345
mat A = (1,2,3,4,5,6,7)
mat colnames A = collider B1 B2 B0 B1se B2se B0se


forvalues B2 = 0/3 { 
forvalues iteration = 1/100 {
clear
set obs 1000 //set the sample size
gen e = rnormal(0,4) 
gen X = rnormal(0,2) 
gen Y = 1 + 2*X + e
gen Z = `B2'*X + 1*Y + rnormal(0,2)
regress Y X Z //run the model


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
egen meanB1 =  mean(B1), by(collider)
gen bias = meanB1 / 2

//RMSE
gen sqerror = (B1 - 2)^2
egen mse = mean(sqerror), by(collider)
gen rmse = sqrt(mse)

//optimism
gen sqdiff = (B1-meanB1)^2
egen meansqdiff = mean(sqdiff), by(collider)
gen numerator = sqrt(meansqdiff)
gen SEsq = B1se^2
egen meanSEsq = mean(SEsq), by(collider)
gen denominator = sqrt(meanSEsq)
gen optimism = numerator / denominator

//make a table illustrating the change in bias
collapse (mean) bias rmse optimism, by(collider)
graph bar bias, over(collider)
twoway line bias collider
twoway line optimism collider
//etc


//PART 2
*then for the model where Z is not controlled
clear
set seed 12345
mat A = (1,2,3,4,5)
mat colnames A = collider B1 B0 B1se B0se


forvalues B2 = 0/3 { 
forvalues iteration = 1/100 {
clear
set obs 1000 //set the sample size
gen e = rnormal(0,4) 
gen X = rnormal(0,2) 
gen Y = 1 + 2*X + e 
gen Z = 0.5*X + `B2'*Y + rnormal(0,2) 
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
egen meanB1 =  mean(B1), by(collider)
gen bias = meanB1 / 2

//RMSE
gen sqerror = (B1 - 2)^2
egen mse = mean(sqerror), by(collider)
gen rmse = sqrt(mse)

//optimism
gen sqdiff = (B1-meanB1)^2
egen meansqdiff = mean(sqdiff), by(collider)
gen numerator = sqrt(meansqdiff)
gen SEsq = B1se^2
egen meanSEsq = mean(SEsq), by(collider)
gen denominator = sqrt(meanSEsq)
gen optimism = numerator / denominator

//make a table illustrating the change in bias
collapse (mean) bias rmse optimism, by(collider)
graph bar bias, over(collider)
twoway line bias collider
twoway line optimism collider
//etc

