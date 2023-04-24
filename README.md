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


<br>

## Reproducibility 

(if you have higher version of PlatEMO) follow this 
    
    step 1: move the code file [Fetal_problem.m] to the folder of [Problem]->PlatEMO.
    step 2: modify the code of file [Fetal_problem.m] for the Path to the dataset [ICA]
      it is in line-25
    step 3: run ANY single-objective algorithm to solve the problem  [Fetal_problem.m],

    for example to call Genetic algorithm to solve it, by using the command 

    platemo('problem',@Fetal_problem,'algorithm',@GA,'N',4,'M', 1, 'maxFE',8, 'save', 1);

    More details to use PlatEMO, please check the [instructions here](https://github.com/BIMK/PlatEMO) 

if you download the entire project, just run

    platemo('problem',@Fetal_problem,'algorithm',@GA,'N',4,'M', 1, 'maxFE',8, 'save', 1);


## Verify the accuracy

Step 1: prepare the results (coefficient/weights) obtained from above process

Step 2: Modify the code [mooOpenSource.m] where the Path to the reference data (true fetal signal data).

line-127 and line-139

Step 3: line-36 to line-60 is coded for my results with specific parameter, you need to modify it based on your results,

     for example, you need to change ' the window size, population size, etc.''
     
     
## results - by ours

 we upload the sample results

