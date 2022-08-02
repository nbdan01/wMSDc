function [ID,Offset_par,Offset_per,alpha_local_par,alpha_local_per,alpha_local_2D,MSD_meanPAR,MSD_meanPER,LagTPAR,LagTPER] = Alpha_power_law(XC,YC,ss,it,TIME,dt,Window_width)



%% Calculate alpha in the sliding WW


ID    = intersect(TIME, [it-ss:it+ss]);
posit = [XC(ID),YC(ID)];                 % Positions in the window

% minimal number of consecutive points in the window to calculate the MSD
tt = 3;
if length(ID) > tt
    % Calculate MSD in the parallel direction
    [LagTpar,MSD_meanpar,MSD_stdpar,yfitpar,ppar] = MSD(posit(:,1),(TIME(ID)-min(TIME(ID))+1)*dt,Window_width,dt);

    % Calculate MSD in the perpendicular direction
    [LagTper,MSD_meanper,MSD_stdper,yfitper,pper] = MSD(posit(:,2),(TIME(ID)-min(TIME(ID))+1)*dt,Window_width,dt);
    % Calculate MSD in the parallel and perpendicular directions (2D)
    [LagT2D,MSD_mean2D,MSD_std2D,yfit2D,p2D] = MSD(posit,(TIME(ID)-min(TIME(ID))+1)*dt,Window_width,dt);
    
    if size(MSD_meanpar,2) <= (Window_width-1)/2
    else

        % Fit the parallel MSD
        fittedDpard = polyfit(LagTpar(1:tt), MSD_meanpar(1:tt),1);
        Offset_par = fittedDpard(2); % Coordinate at the origin MSD = f(lag time) ~= local PL
        
        % Fit the perpendicular MSD
        fittedDperd = polyfit(LagTpar(1:tt), MSD_meanper(1:tt),1);
        Offset_per = fittedDperd(2); % Coordinate at the origin MSD = f(lag time) ~= local PL

        Time_pour_log = zeros(size([1:length(LagTper)],2),1);
        Dinst_pour_log = zeros(size([1:length(LagTper)],2),1);
        %% Calcul of Alpha in the perpendicular direction
        for iii = 1 : length(LagTper)
            Time_pour_log(iii) = iii;
            Paraset2ptsinst = [1 1];
            if iii==1
                XXxx1 =[0,LagTper([iii:iii])];
                YYyy1 = [0,MSD_meanper([iii:iii])];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst1,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx1,YYyy1,[],[],curvefitoptions);
                Dinst_pour_log(iii) = fittedParameters_inst1(1);
            else

                XXxx2 =[0,LagTper(iii)];
                YYyy2 = [0,MSD_meanper(iii)];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst2,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx2,YYyy2,[],[],curvefitoptions);
                Dinst_pour_log(iii) = fittedParameters_inst2(1);
            end
        end

        XXfit_inst2 = log(Time_pour_log);
        D_total_D2_inst2 = [Dinst_pour_log]./Dinst_pour_log(1);
        dXXfit_inst2 = XXfit_inst2(2:end)-XXfit_inst2(1:end-1);
        dlog_D_total_D2_inst2 = log(D_total_D2_inst2(2:end))-log(D_total_D2_inst2(1:end-1));
        pente = 1+dlog_D_total_D2_inst2./dXXfit_inst2;
        alpha_local_per = mean(pente(1:(Window_width-1)/2));

        Time_pour_logpar = zeros(size([1:length(LagTpar)],2),1);
        Dinst_pour_logpar = zeros(size([1:length(LagTpar)],2),1);
        
        %% Calcul of Alpha in the parallel direction
        for iii = 1 : length(LagTpar)
            Time_pour_logpar(iii) = iii;
            Paraset2ptsinst = [1 1];
            if iii==1
                XXxx1 =[0,LagTpar([iii:iii])];
                YYyy1 = [0,MSD_meanpar([iii:iii])];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst1,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx1,YYyy1,[],[],curvefitoptions);
                Dinst_pour_logpar(iii)   = fittedParameters_inst1(1);
            else

                XXxx2 =[0,LagTpar(iii)];
                YYyy2 = [0,MSD_meanpar(iii)];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst2,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx2,YYyy2,[],[],curvefitoptions);
                Dinst_pour_logpar(iii)   = fittedParameters_inst2(1);
            end
        end

        XXfit_inst2par = log(Time_pour_logpar);
        D_total_D2_inst2par = [Dinst_pour_logpar]./Dinst_pour_logpar(1);
        dXXfit_inst2par = XXfit_inst2par(2:end)-XXfit_inst2par(1:end-1);
        dlog_D_total_D2_inst2par = log(D_total_D2_inst2par(2:end))-log(D_total_D2_inst2par(1:end-1));
        pentepar = 1+dlog_D_total_D2_inst2par./dXXfit_inst2par;
        alpha_local_par = mean(pentepar(1:(Window_width-1)/2));
        %%
        Time_pour_log2D = zeros(size([1:length(LagTper)],2),1);
        Dinst_pour_log2D = zeros(size([1:length(LagTper)],2),1);
        %% Calcul of Alpha in 2D
        for iii = 1 : length(LagT2D)
            Time_pour_log2D(iii) = iii;
            Paraset2ptsinst = [1 1];
            if iii==1
                XXxx1 =[0,LagT2D([iii:iii])];
                YYyy1 = [0,MSD_mean2D([iii:iii])];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst1,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx1,YYyy1,[],[],curvefitoptions);
                Dinst_pour_log2D(iii) = fittedParameters_inst1(1);
            else

                XXxx2 =[0,LagT2D(iii)];
                YYyy2 = [0,MSD_mean2D(iii)];
                curvefitoptions = optimset('Display','off','MaxFunEvals',10000,'MaxIter',10000,'TolX',1E-30,'TolFun',1E-30);
                [fittedParameters_inst2,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@Fit_MSD_intercept0_1D,Paraset2ptsinst, XXxx2,YYyy2,[],[],curvefitoptions);
                Dinst_pour_log2D(iii) = fittedParameters_inst2(1);
            end
        end

        XXfit_inst2 = log(Time_pour_log2D);
        D_total_D2_inst2 = [Dinst_pour_log2D]./Dinst_pour_log2D(1);
        dXXfit_inst2 = XXfit_inst2(2:end)-XXfit_inst2(1:end-1);
        dlog_D_total_D2_inst2 = log(D_total_D2_inst2(2:end))-log(D_total_D2_inst2(1:end-1));
        pente2D = 1+dlog_D_total_D2_inst2./dXXfit_inst2;
        alpha_local_2D = mean(pente2D(1:(Window_width-1)/2));

        %% Store MSD in a matrix
        if size(MSD_meanpar,2) == Window_width-1 && size(MSD_meanper,2) == Window_width-1
            MSD_meanPAR = MSD_meanpar;
            LagTPAR = LagTpar;
            MSD_meanPER = MSD_meanper;
            LagTPER = LagTper;
        else
            manque1 = (Window_width-1)-size(MSD_meanpar,2);
            manque2 = Window_width-1-size(MSD_meanper,2);
            MSD_meanPAR = [MSD_meanpar 500.*ones(1,manque1)];
            MSD_meanPER = [MSD_meanper 500.*ones(1,manque2)];
            LagTPAR = [LagTpar 500.*ones(1,manque1)];
            LagTPER = [LagTper 500.*ones(1,manque2)];

        end
    end
end

end