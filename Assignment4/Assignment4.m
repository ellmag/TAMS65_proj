% ----------- DUMMY VARIABLES -------------------



% In a study, one wanted to study whether an active security program has significance for the number of
% working hours which lost due to accidents at work. 50 companies were randomly selected. Results:



%[y x1 x2]
  A=[92.12811753495609 8135 1;
   52.372581043370793 1629 1;
   49.320215545456612 2824 1;
   195.82116711759434 9780 0;
   100.80193659982224 8856 1;
   113.71113387918105 10387 1;
   54.587980520593121 4002 1;
   216.13369216830267 9572 0;
   122.33448745905834 9177 1;
   198.17621607581896 9304 0;
   71.067735543226377 5354 1;
   129.52240191677302 6405 0;
   121.49993662088163 10135 1;
   144.08134536999512 6977 0;
   32.119065165757 1068 1;
   93.511984578003009 3723 0;
   63.583074181200146 2374 0;
   97.6261727455732 8086 1;
   47.583103616512247 1415 0;
   90.036272256417249 5367 1;
   183.36046674761221 7803 0;
   100.41539984998558 6517 1;
   54.847602872506812 2779 1;
   56.374196858062454 1855 0;
   47.770960250407285 2867 1;
   64.211107915749068 4687 1;
   121.97824778980936 10310 1;
   88.592364609991748 7966 1;
   47.17971290231803 2663 1;
   90.611225724112714 8735 1;
   76.3973729599586 5132 1;
   168.70097729078248 8086 0;
   88.816188289405659 4321 0;
   75.797597102062014 6510 1;
   223.0378574579876 10964 0;
   157.12805990787081 7671 0;
   202.06255075414697 9889 0;
   113.41940077958014 4582 0;
   120.73800292419928 5340 0;
   79.198725340944179 8330 1;
   132.9931132644225 10945 1;
   74.088756509257379 5766 1;
   66.484975397869846 4315 1;
   142.64882141763508 7053 0;
   97.005863387471734 8731 1;
   75.214063406839642 4856 1;
   36.092260757293921 3038 1;
   116.73429818522619 4866 0;
   67.629764068451223 1650 0;
   114.02922486622516 5323 0];

% Y = number of lost working hours during 1 year,
% x1 = number of employees,
% x2 = 1, if you have security program; 0, otherwise

y=A(:,1);
x1=A(:,2);
x2=A(:,3);
z1 = x1/1000;
z2 = z1.*x2;
% a) Analyze data according to model Y= g0 + g1*z1 +g2*x2 +e

figure; scatter(z1,y, 'filled'); title('Z1 vs Y');
tbl = table(y,z1,x2,z2, 'VariableNames',{'y','z1','x2','z2'})
tbl.x2 = categorical(tbl.x2);
mdl = fitlm(tbl, 'y~ z1 + x2')
% Rsquared = 0.89 lost working hours seems to be explained by z1 and x2
% well..but can we improve?

r2_1=mdl.Rsquared.Ordinary
g0 = mdl.Coefficients.Estimate(1);
g1 = mdl.Coefficients.Estimate(2);
g2 = mdl.Coefficients.Estimate(3);


h1 =figure; 
set(h1,'name', 'Model 1','numbertitle','on') % Setting the name of the figure
clf(h1) % Erase the contents of the figure
set(h1,'WindowStyle','docked') % Insert the figure to dock
scatter(z1,y, 'filled'); title('Model1: Y= g0 + g1*z1 +g2*x2 +e');
hold on;
%Regression line for x2 = 0
yhat0 = g0 + g1.*z1;
plot(z1,yhat0);
hold on;
%Regression line for x2=1
yhat1 = g0 + g1.*z1 + g2;
plot(z1,yhat1);
hold off;

% -------------------------------
% c ) analyze with model 2:
% y = b0 + b1*z1 + b2*z2 +e
% with z1 = x1/1000, z2 = x2*z1


%x22=A(:,3);

mdl2 = fitlm(tbl, 'y~ z1 + x2*z1')

r2_2 = mdl2.Rsquared.Ordinary;
b0 = mdl2.Coefficients.Estimate(1);
b1 = mdl2.Coefficients.Estimate(2);
b2 = mdl2.Coefficients.Estimate(3);
b3 = mdl2.Coefficients.Estimate(4);

% Rsquared of 0.97, a bit(~9%) more of the variance can be explained with this
% model, good!

% ------------------------------------------
% d) Plot model 2 with the regression lines

h2 =figure; 
set(h2,'name','Model 2','numbertitle','on') % Setting the name of the figure
clf(h2) % Erase the contents of the figure
set(h2,'WindowStyle','docked') % Insert the figure to dock
scatter(z1,y, 'filled'); title('Model 2: y = b0 + b1*z1 + b2*z2 +e');
hold on;
%Regression line for x2 = 0
yhat0 = b0 + b1.*z1;
plot(z1,yhat0);
hold on;
%Regression line for x2=1
yhat1 = (b0 +b2) + (b1+b3).*z1;
plot(z1,yhat1);
hold off;

% Much nicer fit for both lines, explains the increased Rsquared compared
% to model 1.

%----------------------------------
% e) Does analysis give indication that security programs lead to fewer
% working hours lost? Construct appropriate CI.

%Significance test on b3 since the slope of the lines are the difference we
%are looking for.
% H0: b3 = 0 
% H1: b3 /= 0
anova(mdl2) 
% null hypothesis is rejected at the 5% significance level => 
% slopes not equal => security programs seem to reduce working hours lost.

%Another test with confidence intervals
betaCI=coefCI(mdl2);
b3_CI =[betaCI(4,1) betaCI(4,2)]
% CI for beta4 does not include zero, which indicates that using security
% program lower working hours lost. 


