# IJC437-Billboard-Music-Analysis
Project Overview
This repository contains the coursework project for IJC437 – Introduction to Data Science.
The project analyses Billboard Hot-100 songs from 2000 to 2023 to examine how musical features derived from Spotify audio data relate to chart success.
The project follows a standard data science workflow including data cleaning, exploratory data analysis, modelling, and evaluation, implemented using R.
Research Question
RQ1: Which musical features are associated with higher Billboard Hot-100 chart rankings?
RQ2: How have the musical characteristics of charting songs changed over time?
RQ3: To what extent can Billboard chart success be predicted using Spotify audio features?
Dataset
The dataset combines:
Billboard Hot-100 chart rankings (2000–2023)
Spotify audio features, including:
Danceability
Energy
Loudness
Tempo
Valence
Acousticness
The dataset was provided as part of the IJC437 coursework materials and pre-processed prior to analysis.
Methods
The analysis follows the stages of a typical data science process:
Data loading and cleaning
Exploratory data analysis and visualisation
Predictive modelling
Model evaluation and interpretation
The following techniques were used:
Exploratory visualisation using ggplot2
Linear regression for interpretable modelling
Random Forest regression for non-linear relationships
Model evaluation using Root Mean Squared Error (RMSE)
Key Findings
Danceability and loudness are the strongest predictors of chart success.
Popular music has become increasingly rhythm-focused and less acoustic over time.
Musical features alone cannot fully explain Billboard chart success, indicating the influence of wider social and industry factors.
Repository Contents
introds.R — Full R script for data cleaning, analysis, visualisation, and modelling
index.md — GitHub Pages project summary
README.md — Project description and instructions
How to Run the Code
Download or clone this repository.
Open RStudio.
Set the working directory to the folder containing billboard_analysis.R.
Install the required packages (run once):
install.packages(c("tidyverse", "caret", "randomForest", "ROCR", "ggplot2"))
Open introds

Run the script line by line or source the entire file.

The script performs data cleaning, exploratory analysis, modelling, and visualisation.
