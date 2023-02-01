# Google_Data_Analytics_Case_Study

## Intro
Capstone Project for Google Analytics Case Study

## Business Problem
The business task is to analyze smart device usage in order to find trends and insights on how other non-Bellbeat users use other smart devices. I will then apply these insights to one of the Bellbeat Products. I will then need to create a presentation for Bellbeat Executive team and marketing team on general consumer trends, how these trends apply to Bellbeat's marketing strategy, and how these trends are applicable to Bellbeat products.

## Data Source
The data source, "Fitbit Fitness Tracker Data" was found on Kaggle. The datasets were sourced from a survey performed on Amazon Mechanical Turk workers for a study which collected Fitbit tracking data. The original study states 30 participants were surveyed, however 33 can be found in the data. No demographic information such as age, height, or sex was provided. The exact Fitbit models are not specified, but it is noted that variation across the datasets is potentially due to varying device models and user tracking preferences. The data in my analysis is focused during 4-12-2016 to 5-12-2016. The data includes a total of 33 users over 3 datasets tracking data including: physical activity sleep time, and weight information. Overall the data seems reliable but I would like a bigger sample size for the data and the ability to look at the demographics in order to ensure our data is inclusive of all factors such as age, race and gender.

 * "Daily Activity Merged" This table has 13 Columns and over 941 rows. There were 33 unique user IDs which is an unusual since the original survey states that their were only 30 users. There are 13 columns in this dataset which are Id, Activity Date, Total Steps, Total Distance, Tracker Distance, Logged Activities Distance, Very Active Distance, Moderately Active Distance, Lightly Active Distance, Sedentary Active Distance, Very Active Minutes, Fairly Active Minutes, Lightly Active Minutes, Sedentary Minutes, Calories.
 *"Sleep Day Merged" This table has 5 columns with 68 rows and has 24 unique user IDs. The columns in this table are Id, Sleep Day, Total Sleep Records, Total Minutes Asleep, Total Time In Bed.
 *"Weight Log Info Merged", This table has 8 columns with 68 rows and has only 8 unique user IDs. The columns in this table are Id, Date, Weight Kg, Weight Pounds, Fat, BMI, Is Manual Report, Log Id.

## Data Cleaning
I used Google Sheets for data cleaning. Overall the dataset was already pretty clean.

## Data Analysis
Here I downloaded all three of the tables into CSV files. From there I uploaded all the files to my local PostgreSQL database.


1. SQL_Queries for all queries used. 
2. Data Table files resulting from queries
3. Analysis Findings about the data and Visualizations
4. Recommendations Suggested marketing strategy.
