// Setup
sysuse auto

// Machine learning methods like SVM are a black-box and it is very easy to overfit them.
// To compensate, it is important to split data into training and testing sets, fit on
// the former and measure performance on the latter, so that performance measurements
// are not artificially inflated by data they've already seen.
local split = floor(_N/2)
local train = "1/`=`split'-1'"
local test = "`split'/`=_N'"

// But the proportion of classes in each set can be unbalanced.
// The reliable way to handle this is a stratified split;
// the quick and dirty way is a shuffle:
set seed 9876
gen u = uniform()
sort u

// Fit the classification model, with 'verbose' enabled, on the training set.
// Training cannot handle missing data; here we elide it, but usually you should impute.
svm foreign price-gear_ratio if !missing(rep78) in `train', v

// Predict on the test set.
// Unlike training, predict simply predicts missing if any data is missing.
predict P in `test'

// Compute error rate: the percentage of mispredictions is the mean of err.
gen err = foreign != P in `test'
sum err in `test'