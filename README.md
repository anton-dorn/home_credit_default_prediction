# home_credit_default_prediction

This project was part of a seminar paper on Gradient Boosting Machines & XGBoost at the University of Hamburg Business School. The dataset originates from a Kaggle competition by Home Credit on credit default risk prediction.

This repository consists mainly of the feature engineering pipeline across 7 tables. In total, 142 new features were engineered and added to the main table.

Explanation of the files:
sample.csv: a 100 row sample of the final table aggregated via SQL
loading_data.ipynb: python code run locally to install the dataset to MySQL
feature_engineering.sql: SQL code used to aggregate all tables with the application_train dataset and to engineer 142 new features

For exporting home_credit_table to a csv file, the MySQL exporting wizard was used and the columns SK_ID_CURR were all removed from the final csv.

Observations & Disclaimers:
It is important to note that the data might underly an important selection bias. Home Credit might only have accepted potential credit takers that were likely to pay back their credit to begin with, thus the dataset only includes a selection of all applicants.
