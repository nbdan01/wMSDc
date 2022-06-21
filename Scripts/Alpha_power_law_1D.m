function [ID,Offset_par,Offset_per,alpha_local_par,alpha_local_per,MSD_meanPAR,MSD_meanPER,LagTPAR,LagTPER] = Alpha_power_law_1D(XC,YC,ss,it,TIME,dt,Window_width)



%% Calculate alpha in the sliding WW



ID    = intersect(TIME, [it-ss:it+ss]);
posit = [XC(ID),YC(ID)];                 % Positions in the window

% minimal number of consecutive points in the window to calculate the MSD
tt = 3;
if length(ID) > tt
    % Calculate MSD in the parallel direction
    [LagTpar,MSD_meanpar,MSD_stdpar,yfitpar,ppar] = MSD(posit(:,1),(TIME(ID)-min(TIME(ID))+1)*dt,Window_width,dt);

    % Calculate MSD in the perpendicular direction
    MSD_meanper = MSD_meanpar.*0;
    LagTper = MSD_meanper;

    if size(MSD_meanpar,2) <= (Window_width-1)/2
    else

        % Fit the parallel MSD
        fittedDpard = polyfit(LagTpar(1:tt), MSD_meanpar(1:tt),1);
        Offset_par = fittedDpard(2); % Coordinate at the origin MSD = f(lag time) ~= local PL
        
        Offset_per = 0;

        %% Alpha in the perpendicular direction (1D data)
        alpha_local_per = 0;

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