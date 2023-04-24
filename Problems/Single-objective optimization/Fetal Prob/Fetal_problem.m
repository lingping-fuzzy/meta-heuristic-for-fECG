classdef Fetal_problem < PROBLEM
% <single> <real> <expensive/none>

% author: lingping KONG, lingping.kong@vsb.cz
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 Lingping Kong, modified code from
% BIMK Group- PlatEMO. You are free to use the this code for
% research purposes. All publications which use this code or any code
% in the platform should acknowledge the use of "PlatEMO" and reference 
% ----
%--------------------------------------------------------------------------
    properties
        pID = 0; % person's number
        %D(window size) N(pop size)
        mirror= 100; % mirror size
        type = 1;  % for using LMS of updating/no-updating W(pop(:))
        mu = 0.010; % using LMS of mu 
        X;	%  mixed signal
        S; % mother signal
    end
    methods
        %% Default settings of the problem
        function Setting(obj)
            [obj.pID,obj.mirror, obj.type, obj.mu] = obj.parameter{1,:};
            path = 'signal\Signals_ICA\'; %path to the ICA data
            ICAdata = load(strcat(path, 'r', int2str(obj.pID),'_ICA.mat'));

            obj.X = ICAdata.aECG;
            obj.S = ICAdata.mECG;

            obj.M = 1;
            if isempty(obj.D); obj.D = 20; end
            if isempty(obj.N); obj.N = 30; end
            obj.lower    = zeros(1,obj.D) - 1;
            obj.upper    = zeros(1,obj.D) + 1;
            obj.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
                inputX = [obj.X(obj.mirror:-1:1) obj.X]; 
                inputS = [obj.S(obj.mirror:-1:1) obj.S];
                inputX = inputX.'; inputS = inputS.';

                f = zeros(size(PopDec,1), 1); % pop-fitness
                % iteration steps
                if obj.type== 1 % withno updating of Coefficient
                    for j = 1 : size(PopDec,1) % pop iteration
                         fitnessValue = 0;
                        for i = obj.D: length(inputX)     % the k iteration
                            k = i;
                            xv = inputS(k:-1:k-obj.D+1);        % input of M data
                            y = PopDec(j,:)*xv;
                            ern = inputX(k) - y ;        % error of the k step
                            fitnessValue = fitnessValue + (ern.^2) ;
                        end
                        f(j) = fitnessValue; 
                    end
                else  % no updating of Coefficient
                    for j = 1 : size(PopDec,1) % pop iteration
                        fitnessValue = 0;
                        W = PopDec(j,:);
                        for i = obj.D: length(inputX)     % the k iteration
                            k = i;
                            xv = inputS(k:-1:k-obj.D+1);        % input of M data
                            y = W*xv;
                            ern = inputX(k) - y ;        % error of the k step
                            fitnessValue = fitnessValue + (ern.^2) ;
                            W = W + 2*obj.mu*ern*xv';
                        end
                        f(j) = fitnessValue; 
                   end
                end
                PopObj = f;
%   platemo('problem',@Fetal_cal_r2,'algorithm',@GA,'N',4,'M', 1, 'maxFE',8, 'save', 1);

        end
    end
end