# meta-heuristic-for-fECG

Analysis on Population-based Algorithm Optimized Filter for Non-invasive fECG Extraction


"**[Analysis on Population-based Algorithm Optimized Filter for Non-invasive fECG Extraction](url)**"

## Requirements: 

MATLAB R2019b or newer

<br>

## dataset 

download the data from link:

or use the one we upload from folder [signal]

<br>

## base code 
This project is based on the framework [PlatEMO](https://github.com/BIMK/PlatEMO)

We thank this group for sharing their code.

<br>

## Reproducibility 

(if you have higher version of PlatEMO) follow this otherwise goes to Esay-TO-GO
    
    step 1: move the code file [Fetal_problem.m] to the folder of [Problem]->PlatEMO.
    step 2: modify the code of file [Fetal_problem.m] for the Path to the dataset [ICA]
      it is in line-25
    step 3: run ANY single-objective algorithm to solve the problem  [Fetal_problem.m],

    For example to call Genetic algorithm to solve it, by using the command 


    platemo('algorithm',@GA ,'problem',{@Fetal_problem, personID, mirror, type(Tc), initial mu-parameter},'N',15, 'D', 20,'maxFE', 100 , 'save', 2)

Parameter instruction:
 
    personID: in dataset, we have 12 person, you name one personID you use.

    mirror: a parameter how you construct the data, similar as in LMS
    
    type(Tc): Tc(1 or 2), it defines how you change the coeffient, dynamic or constant.
    
    initial mu-parameter: a value, just an initial step size parameter in LMS. 
    
    then 
    'N': population size
    
    'D': window size
    
    'maxFE', maximum fitness evaluation time


More details to use PlatEMO, please check the [instructions here](https://github.com/BIMK/PlatEMO) 

-[Esay-TO-GO] if you download the entire CODE, just run

    platemo('algorithm',@GA ,'problem',{@Fetal_problem, personID, mirror, type(Tc), initial mu-parameter},'N',15, 'D', 20,'maxFE', 100 , 'save', 2)



## Verify the accuracy

Step 1: prepare the results (coefficient/weights) obtained from above process

Step 2: Modify the code [mooOpenSource.m] where the Path to the reference data (true fetal signal data).

line-127 and line-139

Step 3: line-36 to line-60 is coded for my results with specific parameter, you need to modify it based on your results,

     for example, you need to change ' the window size, population size, etc.''
     
     
## results - by ours

 we upload the sample results

## QUESTIONS

please contact lingping_kong@yahoo.com if you find/have problems or questions.
