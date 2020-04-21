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
set(0,'DefaultFigureWindowStyle','docked') 
% a)
z = 1000*x +5000; % current during welding
b = A(:,2)>0.5;
x1 = x(b); 
y1 = y(b);

figure
scatter(x1,y1,'*'); 

% Looks like polynomial relationship 

fit = polyfit(x1,y1,2)

%evaluate
y2 = polyval(fit,x1);
figure
plot(x1,y1,'o')
hold on
plot(x1,y2)
hold off

% R-square of 99%. Very nice. 

% c) Do residual plot with observations and compare with y1-x1 plot

% Residual plots
regr = regstats(y1,x1,'quadratic','all');
yhat = regr.yhat;
r = regr.r;
figure('name','Histogram'); 
hist = histogram(r,13);
% Hard to say if residuals are normally distributed with such low sample,
% but could very well be => 

figure('name','residuals vs observation order'); 
rSquared = scatter(1:length(r),r)
% Observations does not indicate time-dependency

figure('name','Residual vs fitted value');  
yhat_r = scatter(yhat,r,'*')
% Observations mean seem to be randomly scattered around 0, so assumption
% of mean 0 is reasonable. (Even though small amount of observations)

figure('name','Normal probability plot');  
normP = normplot(r);

% Although some departures from normal distributions, it does seem somewhat
% reasonable to assume normal distribution of these residuals.


