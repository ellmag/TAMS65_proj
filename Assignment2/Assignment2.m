%[y x]
 A=[80.197118070747166 -2.5666179827034052;
   96.100337557063114 -2.1269840916834286;
   102.21639050420207 -2.0418362601495867;
   115.87643421262707 -0.94927120819026278;
   111.29692037645944 -0.77116852214250153;
   111.32114732562169 -0.34786388198669016;
   112.83671847665971 -0.33817756808106303;
   101.68168180066911 -0.20539821841875217;
   104.7307892624973 -0.032731705194564142;
   92.051470144509921 0.1114712065857093;
   98.491434194738844 0.1688739978265108;
   84.04461874361705 0.45700722714542374;
   78.979113046489246 0.66221765079119921;
   87.439952721792793 0.70735546499701485;
   76.6596801766987 0.86590277556244155;
   64.227153112762878 1.4006804918975106;
   69.083374826334875 1.8572113116852353;
   67.716633413807259 2.1808909548484241;
   65.407652636407008 2.2720241040189979;
   88.850432917584953 2.7235225355912824;
   81.8739626287759 2.7258357341468651;
   132.05654439038884 3.3487347327508363;
   157.94216153772052 3.7074651941943113;
   193.04399353361654 3.9203050111333511;
   198.94506275634302 3.9481710246716464];
y=A(:,1); % measure of strength of weld joint
x=A(:,2); % transformed current during welding
% set(0,'DefaultFigureWindowStyle','docked') 

% a) Scatter plot obs for x > 0.5

z = 1000*x +5000; % current during welding
b = A(:,2)>0.5;
x1 = x(b); 
y1 = y(b);
x12 = x1.*x1;
X = [ones(size(x1)) x1 x12];
figure
aScat = scatter(x1,y1,'*'); 

% Looks like polynomial(X1^2) relationship 

% b) Give suitable regression model, calc R2 with y1 = B1*x1

pFit = polyfit(x1,y1,2)
lmFit2 = fitlm(x1,y1);
b = lmFit2.Coefficients.Estimate
yhat = X.*b

obsVregr = figure('name', 'obs vs regression line')
plot(x1,y1,'o')
hold on
plot(x1, yhat)
hold off

% Polynomial regression gives: 
% [B0 B1 B2] = [25.78,-86.32,131.99]
% R-square of 99%. Very nice. 

% c) Do residual plot with observations and compare with y1-x1 plot

% Residual plots
stats1 = regstats(y1,[x1 x12],'linear', 'all')
e2 = stats1.r;
R2_2 = stats1.rsquare;
figure; scatter(x1, e2, 'filled'); title('Model 1: Residuals, x1')
figure('name','Histogram'); 
hist = histogram(e2,13);
% Hard to say if residuals are normally distributed with such low sample,
% but could very well be => 


figure('name','Residual vs fitted value');  
yhat_r = scatter(yhat,e2,'*')
% Observations mean seem to be randomly scattered around 0, so assumption
% of mean 0 is reasonable. (Even though small amount of observations)

figure('name','Normal probability plot');  
normP = normplot(e2);

% Although some departures from normal distributions, it does seem somewhat
% reasonable to assume normal distribution of these residuals.


% d) Consider all observations

scatter(x,y)
% Plot looks more complex than quadratic. Degree 3 polynomial
x2=x.*x.*x;
x3=x.*x.*x;
X3 = [ones(size(x)) x x2 x3]

% Rsquared of 93.7%. Nice but not as nice as model 2. 




stats3 = regstats(y,[x x2 x3],'linear', 'all')
b3 = stats3.beta;
yhat3 = X3*b3;
e3 = stats3.r;
R2_3 = stats3.rsquare;
figure; scatter(x, e3, 'filled'); title('Model 2: Residuals, x')

hist = histogram(stats3.r,13);

%Interpolate regression line to get better resolution
xnew=transpose(linspace(-3,4,500));
x2new = xnew.*xnew;
x3new = xnew.*xnew.*xnew;
X3_I = [ones(size(xnew)) xnew x2new x3new]
yhat3new =X3_I*b3;

obsVregr = figure('name', 'obs vs regression line')
plot(x,y,'o')
hold on
plot(x, yhat3)
hold off



% e) Calculate stationary points(min/max) y, and of strength based on x
b0 = stats3.beta(1)
b1 = stats3.beta(2)
b2 = stats3.beta(3)
b3 = stats3.beta(4)

u = b3;

% Local stationary points from looking at regression-line plot
% x_max = -1 with y_max = 116
% x_min = 1.4 with y_min = 67.1

% I.e for currents between x = [-2 ; 0] we can expect strength of 116
% For currents between x = [1;2] we can expect strengths of 67.1

%We want to solve stationary points(max/min) 


