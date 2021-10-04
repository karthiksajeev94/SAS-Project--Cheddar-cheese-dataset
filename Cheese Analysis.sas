data cheese;
input case taste acetic h2s lactic;
cards;
1	12.3	4.543	3.135	0.86
2	20.9	5.159	5.043	1.53
3	39	5.366	5.438	1.57
4	47.9	5.759	7.496	1.81
5	5.6	4.663	3.807	0.99
6	25.9	5.697	7.601	1.09
7	37.3	5.892	8.726	1.29
8	21.9	6.078	7.966	1.78
9	18.1	4.898	3.85	1.29
10	21	5.242	4.174	1.58
11	34.9	5.74	6.142	1.68
12	57.2	6.446	7.908	1.9
13	0.7	4.477	2.996	1.06
14	25.9	5.236	4.942	1.3
15	54.9	6.151	6.752	1.52
16	40.9	6.365	9.588	1.74
17	15.9	4.787	3.912	1.16
18	6.4	5.412	4.7	1.49
19	18	5.247	6.174	1.63
20	38.9	5.438	9.064	1.99
21	14	4.564	4.949	1.15
22	15.2	5.298	5.22	1.33
23	32	5.455	9.242	1.44
24	56.7	5.855	10.199	2.01
25	16.8	5.366	3.664	1.31
26	11.6	6.043	3.219	1.46
27	26.5	6.458	6.962	1.72
28	0.7	5.328	3.912	1.25
29	13.4	5.802	6.685	1.08
30	5.5	6.176	4.787	1.25
proc print data=cheese;

proc sgscatter data=cheese;
matrix taste acetic h2s lactic;
run;

proc corr data=cheese noprob;
var taste acetic h2s lactic;
run;

proc reg data=cheese;
model taste = acetic;
model taste = h2s;
model taste = lactic;
model taste=acetic h2s lactic;
run;

proc sort data=cheese; by acetic;
symbol1 v=circle i=sm70;
axis1 label=('Acetic');
axis2 label=(angle=90 'Taste');
proc gplot data=cheese;
plot taste*acetic/ haxis=axis1 vaxis=axis2;
run;
proc sort data=cheese; by h2s;
symbol1 v=circle i=sm70;
axis1 label=('H2S');
axis2 label=(angle=90 'Taste');
proc gplot data=cheese;
plot taste*h2s/ haxis=axis1 vaxis=axis2;
run;
proc sort data=cheese; by lactic;
symbol1 v=circle i=sm70;
axis1 label=('Lactic');
axis2 label=(angle=90 'Taste');
proc gplot data=cheese;
plot taste*lactic/ haxis=axis1 vaxis=axis2;
run;

symbol i=none;
proc reg data=cheese;
model taste=acetic h2s lactic;
output out=check r=resid;
proc gplot data=check;
plot resid*acetic/vref=0;
plot resid*h2s/vref=0;
plot resid*lactic/vref=0;
plot case*acetic;
plot case*h2s;
plot case*lactic;
plot case*resid;
run;

proc univariate data=check plot normal; 
var resid;
title1 'Problem 3 - Histogram & QQ Plot';
title2 'Sandesh George Oommen';
histogram resid / normal kernel(L=2); 
qqplot resid / normal (L=1 mu=est sigma=est);
run;

proc transreg data = cheese;
model boxcox(taste)=identity(lactic h2s acetic);
run;

data box;
set cheese;
taste2=taste**0.75;
logtaste=log(taste);
sqrttaste=taste**0.5;
run;

symbol i=none;
proc reg data=box;
model taste2=lactic h2s acetic;
output out=resid r=res;
proc gplot data=resid;
plot res*lactic/vref=0;
plot res*h2s/vref=0;
plot res*acetic/vref=0;
run;

symbol i=none;
proc reg data=box;
model logtaste=lactic h2s acetic;
output out=resid r=res;
proc gplot data=resid;
plot res*lactic/vref=0;
plot res*h2s/vref=0;
plot res*acetic/vref=0;
run;

symbol i=none;
proc reg data=box;
model sqrttaste=lactic h2s acetic;
output out=resid r=res;
proc gplot data=resid;
plot res*lactic/vref=0;
plot res*h2s/vref=0;
plot res*acetic/vref=0;
run;

proc reg data=cheese;
model taste=lactic h2s acetic /ss1 ss2;
run;

proc reg data=cheese;
model taste=lactic h2s acetic;
lacticonly: test h2s, acetic;
h2sonly: test lactic, acetic;
aceticonly: test lactic, h2s;
lacticacetic: test h2s;
h2sacetic: test lactic;
lactich2s: test acetic;
run;

title1 'Problem 2 - Selection of best model using Cp criterion';
title2 'Sandesh George Oommen';
proc reg data=cheese;
model taste=acetic h2s lactic/selection=cp b;
run;

title1 'Problem 2 - Selection of best model using stepwise criterion';
title2 'Sandesh George Oommen';
proc reg data=cheese;
model taste=acetic h2s lactic/selection=stepwise b;
run;

title1 'Problem 3 - Checking of assumptions for best model';
title2 'Sandesh George Oommen';
proc sort data=cheese; by h2s;
symbol1 v=circle i=sm70;
axis1 label=('H2S');
axis2 label=(angle=90 'Taste');
proc gplot data=cheese;
plot taste*h2s/ haxis=axis1 vaxis=axis2;
run;
proc sort data=cheese; by lactic;
symbol1 v=circle i=sm70;
axis1 label=('Lactic');
axis2 label=(angle=90 'Taste');
proc gplot data=cheese;
plot taste*lactic/ haxis=axis1 vaxis=axis2;
run;

proc reg data=cheese;
model taste=h2s lactic;
output out=check r=resid p=pred;
run;
symbol v=circle i=none c=red;
proc gplot data=check;
title1 'Problem 3 - Residual vs Predicted value of taste';
title2 'Sandesh George Oommen';
axis1 label=('Predicted value of taste');
axis2 label=(angle=90 'Residuals' );
plot resid*pred/ haxis=axis1 vaxis=axis2 vref=0;
proc gplot data=check;
title1 'Problem 3 - Residual vs H2S';
title2 'Sandesh George Oommen';
axis1 label=('H2S');
axis2 label=(angle=90 'Residuals' ); 
plot resid*h2s/haxis=axis1 vaxis=axis2 vref=0;
proc gplot data=check;
title1 'Problem 3 - Residual vs Lactic';
title2 'Sandesh George Oommen';
axis1 label=('Lactic');
axis2 label=(angle=90 'Residuals' );
plot resid*lactic/haxis=axis1 vaxis=axis2 vref=0;
proc gplot data=check;
title1 'Problem 3 - Residual vs Case number';
title2 'Sandesh George Oommen';
axis1 label=('Case number');
axis2 label=(angle=90 'Residuals' );
plot resid*case/haxis=axis1 vaxis=axis2 vref=0;
run;
axis1 label=('Case number');
axis2 label=(angle=90 'H2S' );
plot h2s*case/haxis=axis1 vaxis=axis2 vref=0;
run;
axis1 label=('Case number');
axis2 label=(angle=90 'Lactic' );
plot acetic*case/haxis=axis1 vaxis=axis2 vref=0;
run;
proc univariate data=check plot normal; 
var resid;
title1 'Problem 3 - Histogram & QQ Plot';
title2 'Sandesh George Oommen';
histogram resid / normal kernel(L=2); 
qqplot resid / normal (L=1 mu=est sigma=est);
run;

title1 'Problem 7 - Estimate of mean taste and 85% confidence interval';
title2 'Sandesh George Oommen';
proc reg data=cheese; 
model taste=h2s lactic/clb clm cli alpha=0.10; 
id h2s lactic;
run;

proc reg data=cheese;
model taste=h2s lactic/r partial influence tol vif;
plot r.*(h2s lactic);
run;

title1 'Partial residual plot';
title2 'for h2s’';
symbol1 v=circle i=rl;
axis1 label=('Residual H2S');
axis2 label=(angle=90 'Residual Taste');
proc reg data=cheese;
model taste h2s = lactic;
output out=partialh2s r=restaste resh2s;
proc gplot data=partialh2s;
plot restaste*resh2s / haxis=axis1 vaxis=axis2;
run;

title1 'Partial residual plot';
title2 'for lactic';
symbol1 v=circle i=rl;
axis1 label=('Residual lactic');
axis2 label=(angle=90 'Residual Taste');
proc reg data=cheese;
model taste lactic = h2s;
output out=partiallactic r=restaste reslactic;
proc gplot data=partiallactic;
plot restaste*reslactic / haxis=axis1 vaxis=axis2;
run;










