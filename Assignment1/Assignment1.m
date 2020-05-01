%[y x1 x2]
  A=[80750.67983207744 24.817574516788952 1;
   33842.079470753873 23.825936382302192 0;
   194891.66932077392 23.268858402065369 1;
   15359.851544095609 21.030399174664652 1;
   64627.861059016643 23.704123793069336 0;
   34716.982870117215 23.77441539597471 0;
   26389.594392983439 24.81798320776792 0;
   212050.82646712702 27.95619562877393 0;
   106562.10472443166 26.913936961708149 0;
   386231.12334980676 28.497900986527739 1;
   37443.08337862941 25.122825258965264 0;
   65803.947236528023 28.550334084373336 0;
   35645.20344913489 24.654415467595264 0;
   22578.862223847584 22.648485977635783 0;
   84982.349041792477 26.294842137299753 0;
   48289.449189191306 25.627341189419198 0;
   242113.74753331198 25.411564676448855 1;
   23743.041118853296 23.933114393184741 0;
   119344.8891157014 24.20462371266418 1;
   15829.088847510799 21.371219777344184 1;
   47676.41669545789 22.921778784952238 1;
   19388.610568250097 20.073232131846215 1;
   359120.91922456573 29.327012247765065 0;
   70009.02286133208 26.092585410840297 0;
   686221.103911334 28.918456938262793 1;
   60557.485437015755 24.20824840285832 0;
   150665.64756441588 24.001813440136246 1;
   41530.151174548868 25.539341179688915 0;
   199256.16339654507 25.962594382507731 1;
   98595.985965528133 25.062788211049885 0];
y=A(:,1);  %number of bacteria grown during time t
x1=A(:,2); % temperature in C
x2=A(:,3); % binary, 0 for humidity <80%, 1: for >80%


% a) 
scatter(x1,y) %Scatter plot y against x1
corr1 = corr(x1,log(y)) %Calculate correlation between them
% corr = 0.6459

%Conclusion: 
% temperature(x1) does seem to correlate linearly according to scatter plot

% b)
tbl = table(logy,x1,x2, 'VariableNames',{'logy','x1','x2'})
tbl.x2 = categorical(tbl.x2) % since binary
mdl = fitlm(tbl, 'logy~ x1 + x2')



X = [ones(size(x1)) x1 x2]; % y = 1 + b1*x1 + b2*x2
logy = log(y);
[b, bint] = regress(logy,X); 



% Regr coef?f  : y = 1.1720 + 0.3849*x1 + 1.0057*x2

% c) 
corr2 = corr(x1, logy)
% corr2 = 0.7402
figure
scatter(x1,logy,'*');
hold on
lsline %
hold off
%}


% d) Predict for 25C, low humidity



u = [1 25 0]';
s2 = mdl.MSE;
s = sqrt(s2);
dfe = mdl.DFE
t = tinv(0.975,dfe);
betahat = mdl.Coefficients.Estimate
Cbetahat = mdl.CoefficientCovariance
XtXinv = Cbetahat/s2

%Prediction interval for log(y) = beta0 + beta1*x1 + beta2*x2
I_logy = [u'*betahat-t*s*sqrt(1+u'*XtXinv*u), u'*betahat+t*s*sqrt(1+u'*XtXinv*u)]
I_Y = exp(I_logy);

pred = P * b;
predInterval = P * [bint(:,1) bint(:,2)]
% CI_95: (6.5317 ; 15.0590)
