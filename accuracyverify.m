% Loading audio file
clc; clear all;

%% Note 1: parameters setting
% parameter, alg, D, N, and run can be changed according to your MA results.
% here we give an example to play with.
alg={'IMODE'};
D = 21:30;
N = [15] ; % parameter, from 10 to 20
run = 10; % parameter, from 1 to 


%% Note 2: Download signal detection code
% you need to download the public source code 'jqrs_mod' and 'Bxb_compare'

%% Note 3: put the MA coefficient results under 'base' folder then set
% fetch the resutls
base = 'path to your MA-based results data';% p1-5


%% Note 4: All MA implemented from public source PlatEMO, if you use our MA results
% you need to make sure you have PlatEMO. Or you can run any MA of your own implementation
% then put the results under 'base' folder.  


%% Note 5: if you have problem to run it or you find error, please contact lingping.kong@vsb.cz

% mirror is a reflection length of signal, you can change it, would not effect results much.
mirror=200;  Fs = 1000;

%% Note 4: The detection result is stored in following. 
run_MA_Amplitude =zeros(length(D), 7); 



for dp = D % window size parameter
for ps = 1:size(N, 2) % population size parameter
   for j = 7 % person_id, parameter, 
     for a = 1: size(alg, 2)   % MA methods  
         pID = j;
         folder = strcat(base,alg{:, a}); 
         % you need to know how your results is saved by its name, then change the file-> as your named results file 
         file   = strcat(folder,'/',alg{:, a},'_','Fetal_cal_par','_M',int2str(1), '_D', int2str(D(dp-20)),...
             '_N',int2str(N(ps)),'_p',int2str(pID),'_T',int2str(1),'_', int2str(run), '.mat');
         cofe = load(file);
         [s1, s2] = fetch_cof_from_data(cofe);
         [sigA,sigm, sigF] = get_signal(pID, mirror);
         dim = D(dp-20);
          [F1_s2,MAE_s2,PPV_s2,SE_s2,TP_s2,FN_s2,FP_s2]= get_ynb_Amplitude(sigA, sigm, dim, s2, mirror, sigF, pID);
         
        
        run_MA_Amplitude(dim-20,:) = [F1_s2,MAE_s2,PPV_s2,SE_s2,TP_s2,FN_s2,FP_s2];          
     end

       sprintf("This is person %d in popsize %d and T %d of MA-Amplitude results", pID, N(ps), type(1))
       run_MA_Amplitude
   end

end
end


%%%%%%%%%%%%%%%% for the s1 %%%%%%%%%
  %%%-for original-%%%
function [s1, s2] = fetch_cof_from_data(data)
     cof = data.result{end};
     pop = cof.decs;
     [N, ~] = size(pop);
     s1= pop(1,:);
     if N > 1
        s2 = pop((N-1), :);
     else
        s2 = pop(N, :);
     end
end  
  
%%%%%%%%%%%%%%%%%%% stage three emf/stft/nmf------
function [F1,MAE,PPV,SE,TP,FN,FP]= get_ynb_process(inputX, inputS, nC, cof, mirror, fECG, pID)
    ynb = inf * ones(size(inputX));
        for k = nC:length(inputX)
            x = inputS(k:-1:k-nC+1);
            ynb(k) = inputX(k) - cof* x';
        end
%     disp('the  solution results');    
    [F1,MAE,PPV,SE,TP,FN,FP]= evaluation_signal(ynb, mirror, nC, fECG, pID) ;   
end


%%%%%%%%%%%%%%%%%%% stage three with amplitude tuning------
function [F1,MAE,PPV,SE,TP,FN,FP]= get_ynb_Amplitude(inputX, inputS, nC, cof, mirror, fECG, pID)
    ynb = inf * ones(size(inputX));
        for k = nC:length(inputX)
            x = inputS(k:-1:k-nC+1);
            ynb(k) = inputX(k) - cof* x';
        end
        
    hz = getHz( pID);
    acceptint = 50*hz/1000;
    whoinend = ynb((mirror-nC):end); 
    signal =  (whoinend - min(whoinend))/ (max(whoinend) - min(whoinend));   

    fqrsRestore = jqrs_mod(signal,0.25,0.100,hz,[],[],0); % here mirror-1 or mirror-nC
    fqrs= jqrs_mod(fECG,0.25,0.100,hz,[],[],0);
    [F1,MAE,PPV,SE,TP,FN,FP] = Bxb_compare(fqrs, fqrsRestore, acceptint); 
end


function [F1,MAE,PPV,SE,TP,FN,FP] = evaluation_signal( signal, mirror, nC, fECG, pID)
    hz = getHz( pID);
    acceptint = 50*hz/1000;
    whoinend = signal;    
    fqrsRestore = jqrs_mod(whoinend((mirror-nC):end),0.25,0.100,hz,[],[],0); % here mirror-1 or mirror-nC
    fqrs= jqrs_mod(fECG,0.25,0.100,hz,[],[],0);
    [F1,MAE,PPV,SE,TP,FN,FP] = Bxb_compare(fqrs, fqrsRestore, acceptint);
%     sprintf("%.3f, %.3f, %d, %d, %d", F1, PPV, TP, FN, FP)
end

function hz = getHz( pID)
  if pID == 1 || pID == 4 || pID == 7 || pID == 8 || pID == 10
      hz = 1000;
  else
      hz = 500;
  end
end


%% for Fecg- you need to change the data source path
function [inputX,inputS, fECG] = get_signal(pID, mirror)
    path = 'ECG\Origdata\Signals_ICA\';
    ICAdata = load(strcat(path, 'r', num2str(pID),'_ICA.mat'));

    X = ICAdata.aECG;
    S = ICAdata.mECG;
    inputX = [X(mirror:-1:1) X]; 
    inputS = [S(mirror:-1:1) S];
    % loading input signal%
    path = 'ECG\Origdata\ADFECGDB\ADFECGDB\r';
    fECG = load(strcat(path, num2str(pID), '\fECG.mat'));
    fECG = fECG.fECG;
end

