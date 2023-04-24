% this is an example code,
% please read Readme, then check this code


clear; clc;
D = [30, 20, 22, 46, 30, 1, 46, 50, 64, 55]; 
N = [10, 15, 20]; type=[1, 2]; %Two different names(obtain dynamic coeffient or constant)
mu =[0.021, 0.098, 0.1, 0.004, 0.002, 0.1, 0.003, 0.008, 0.06, 0.02];
mirror=5000; 
seed=[42, 15, 95];

rng(95);
Tc = 1; 
alg={ 'OFA', 'FRCG', 'GA'};

for a = 1: size(alg, 2)
   for j = 1:10 % person_num
         pID = j;
         algo = str2func(alg{:, a});
         platemo('algorithm',algo ,'problem',{@Fetal_problem,pID,mirror, type(Tc), mu(j)},'N',15, 'D', D(j),'maxFE', D(j)*50 , 'save', 2)
   end
end

