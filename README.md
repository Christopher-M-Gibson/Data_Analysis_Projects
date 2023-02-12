# Data_Analysis_Projects
This repository some of the various projects I have worked on in Python, SQL, R, and Excel.  
What follows is a short description of each project, highlighting the associated files,   
software used, the purpose of the project, the methods of analysis, and the results. They are   ordered alphabetically.

*Note: I am not proficient in Git, apologies for the formatting*

**Amazon Alexa Reviews**

1) Associated Files:  
&emsp; Amazon Alexa Sentiment Analysis (Python).ipynb  
&emsp;&emsp; This is the file containing the code for the project  
&emsp; Amazon_Alexa_Reviews.csv  
&emsp;&emsp; This file contains the original dataset  

2) Software Used:  
&emsp; Excel, Python (Jupyter Notebook)  

3) Purpose of the Project:  
&emsp; To understand how Amazon Alexa was viewed by those who purchased it.

4) Methods:  
&emsp; After importing the dataset, I cleaned it by:  
&emsp;&emsp; - Checking for missing values (there were none)   
&emsp;&emsp; - Removing all of the filler words that would skew the results of the analysis  
&emsp;&emsp; - Dropping the unnecessary columns  
&emsp; For the first portion of the analysis, I observed the amount of each rating that was  
&emsp; used to describe Amazon Alexa, visualizing that using a donut chart.  
&emsp; For the second portion of the analysis, I used a sentiment analyzer to run through    
&emsp; the comments to classify them as positive, negative, and neutral, visualizing that  
&emsp; using a bar chart  
&emsp; For the third portion of the analysis, I isolated the most negative reviews to     
&emsp; find ways to improve the product. I did the same for the most positive reviews,  
&emsp; except I looked to features of the product that should remain unchanged.

5) Results:  
&emsp; - The donut chart gives that roughly 75% of the ratings were perfect ratings (5/5),   
&emsp; around 90% of ratings are at least a 3/5.  
&emsp; - The sentiment analysis revealed that the reviews associated with the rating were  
&emsp; mostly split between positive and neutral.  
&emsp; - This illustrates a flaw of the rating system from 1 to 5: that it generalizes the  
&emsp; review. Only looking at the ratings here gives an overly-positive view of the   
&emsp; product. 

**Admissions for Graduate School**

1) Associated Files:  
&emsp; Admission Data Correlation Analysis (Python).ipynb  
&emsp;&emsp; This is the file containing the code for the project  
&emsp; adm_data.xlsx  
&emsp;&emsp; This file contains the original dataset  

2) Software Used:  
&emsp; Excel, Python (Jupyter Notebook)  

3) Purpose of the Project:  
&emsp; To understand what admission factors are correlated to having a higher admission   
&emsp; chance

4) Methods:  
&emsp; After importing the dataset, I cleaned it by:  
&emsp;&emsp; - Checking for missing values (there were none)   
&emsp;&emsp; - Renaming columns    
&emsp;&emsp; - Dropping the unnecessary columns  
&emsp;&emsp; - Sorting the data by the chance of admission  
&emsp; I then observed the correlation between the variables by producing a correlation    
&emsp; matrix and then a heat map, before specifying the relationships that have a high    
&emsp; correlation (above |.75|).    

5) Results:  
&emsp; -  The following admission factors are highly correlated with having a high chance  
&emsp; of admission: TOEFL Score, GRE Score, and CGPA (cumulative GPA).    
&emsp; - The three admission factors are also highly correlated with each other.    

**Flight Data for NYC Airports 2013**

1) Associated Files:  
&emsp; Flight Fata Exploratory Analysis.sql  
&emsp;&emsp; This is the file containing the queries used for the project  
&emsp; flight_data.xlsx  
&emsp;&emsp; This file contains the original dataset  
&emsp; Weather_2013.xlsx  
&emsp;&emsp; This file contains the data for the weather in 2013  
&emsp; *TBD*  
&emsp;&emsp; This PDF highlights the data cleaning for the file used for Tableau visualization  

2) Software Used:  
&emsp; Excel, SQL (SQL Server) 

3) Purpose of the Project:  
&emsp; To observe qualities of the airlines and airports in NYC that could be expanded      
&emsp; in a further analysis

4) Methods:  
&emsp; After importing the dataset, I prepared the dataset by adding a day_of_year column  
&emsp; to simplify future queries.  
&emsp; The exploration was divided into four parts where I observed:     
&emsp;&emsp; - The number of delays for each airport/airline     
&emsp;&emsp; - The average delay time and the number of delays each day   
&emsp;&emsp; - On time-percentage (the percentage of flights arriving within 15 minutes of    
&emsp;&emsp; scheduled arrival) for each airport/airline  
&emsp;&emsp; - Flight speed for each airline    

5) Results:  
&emsp; These are just some of the observations from the analysis:  
&emsp;&emsp; - There are over 300,000 delays, which are roughly evenly divided between the  
&emsp;&emsp; three airports  
&emsp;&emsp; - There are more delays in the summer months than any other time of the year  
&emsp;&emsp; - The on-time percentage for the airlines ranges from 30% to 52% (being this  
&emsp;&emsp; low is understandable, as the dataset only consists of delays. It is reasonable  
&emsp;&emsp; to assume it would be much higher if every flight was recorded.  
&emsp;&emsp; - The flight speed ranges from 330 mph to 480 mph  

**Movie Industry**

1) Associated Files:  
&emsp; Movie Industry Correlation Analysis (Python).ipynb  
&emsp;&emsp; This is the file containing the code for the project  
&emsp; movies.csv  
&emsp;&emsp; This file contains the original dataset  

2) Software Used:  
&emsp; Excel, Python (Jupyter Notebook)  

3) Purpose of the Project:  
&emsp; To understand what factors in the movie industry are highly correlated.  

4) Methods:  
&emsp; After importing the dataset, I cleaned it by:  
&emsp;&emsp; - Dropping missing values     
&emsp;&emsp; - Altering the data types of the columns    
&emsp;&emsp; - Sorting the table by the gross revenue value    
&emsp; I observed the relationship between the budget of the movie and the gross      
&emsp; earnings via a scatterplot.  
&emsp; I produced a correlation matrix and heatmap of the factors, specifying those which  
&emsp; has a high correlation (above |0.5|)    

5) Results:  
&emsp; - The following relationships are highly correlated:  
&emsp;&emsp; - number of votes and gross revenue  
&emsp;&emsp; - budget and gross revenue  
&emsp; - This makes sense, as movies with a higher budget are expected to generate    
&emsp; more revenue, and the movies that generate more revenue would expect to be the     
&emsp; best rated movies (i.e. have the most votes)  

**Nashville Housing**

1) Associated Files:  
&emsp; Nashville Housing Data Cleaning.sql   
&emsp;&emsp; This is the file containing the queries for the project  
&emsp; Nashville_Housing_Data.xlsx    
&emsp;&emsp; This file contains the original dataset  

2) Software Used:  
&emsp; Excel, SQL (SQL Server)    

3) Purpose of the Project:  
&emsp; Clean the dataset so that it could be further analyzed  

4) Methods:  
&emsp; The data was cleaned performing six steps:       
&emsp;&emsp; - I converted the date to a standard format       
&emsp;&emsp; - I used the data from one column to populate missing data in another     
&emsp;&emsp; - I divided the address column into three individual columns (street  
&emsp;&emsp; address, city, and state)    
&emsp;&emsp; - I changed the formatting of the data in the SoldAsVacant column (from     
&emsp;&emsp; Y/N to Yes/No)    
&emsp;&emsp; - I removed duplicate rows  
&emsp;&emsp; - I wrote the code that would delete unnecessary rows (however, I did not  
&emsp;&emsp; run this code)      

5) Results:  
&emsp; - Having cleaned the dataset, it is ready to be used for further analysis
