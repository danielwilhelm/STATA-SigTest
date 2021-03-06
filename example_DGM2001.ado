/*
	Monte Carlo study in Delgado and Gonzalez Manteiga (AoS, 2001)
	
21/08/2018

Samples are generated according to the model
	
	Y = a*XL + m(X) + b*sin(a*Z) + U
	where
	U ~ N(0,1)
	X,Z ~ i.i.d. U(0,1) and independent of U
	e.g., m(X) = 1 + X1 or m(X) = 1 + sin(10*X1);
	e.g., XL = X2, m(X) = 1 + X1

	Modify (1) the number of observation,
	       (2) depvar and expvar following the settings in DGM (AoS, 2001), or
	       (3) add specific option values in dgmtest
	           default: qz(1) qw2(0) teststat(CvM) kernel(epanechnikov) bw(0) bootdist(mammen) bootnum(500) ngrid(0) qgrid(0)
*/

*************** example_DGM2001 CODE *******************************************
program define example_DGM2001, eclass

capture program drop dgmtest
clear

// Number of observations = sample size (DGM (2001): n=50 or n=100)
set obs 50

// Error U are generated from N(0,1)
generate U = rnormal()

// Regressors are i.i.d. U(0,1), independent of Ui
generate X1 = runiform()
generate X2 = runiform()
generate Z1 = runiform()
generate Z2 = runiform()

// DGP for Y
// Table 1
generate Y11 = 1 + X1 + U
generate Y12 = 1 + sin(10*X1) + U
// Table 2
generate Y21 = 1 + X1 + sin(5*Z1) + U
generate Y22 = 1 + X1 + sin(10*Z1) + U
// Table 3
generate Y3  = 1 + X1 + X2 + U
// Table 4
generate Y41 = 1 + X1 + X2 + sin(5*Z1) + U
generate Y42 = 1 + X1 + X2 + sin(10*Z1) + U

// Bootstrap Significance Testing
// e.g., Table 1.2: dgmtest Y11 X1 Z1 Z2, qz(2) [other options]
// e.g., Table 4.1: dgmtest Y41 X1 X2 Z1[, options]
dgmtest Y42 X1 X2 Z1, kernel(epan2) bootnum(2000)

end
