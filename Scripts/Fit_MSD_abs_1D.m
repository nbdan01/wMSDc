function y = Fit_MSD_abs_1D(param,deltat);
%  A = pRaram(1);
%  beta = param(1);
beta = param(1)
 beta = abs(beta);
 beta2 = param(2);
 y  = 2*beta*deltat+beta2;
  
end