# home_credit_default_prediction

This project was part of a seminar paper on Gradient Boosting Machines & XGBoost at the University of Hamburg Business School. The dataset originates from a Kaggle competition by Home Credit on credit default risk prediction.

## Observations & Disclaimers
It is important to note that the data may be subject to selection bias. Home Credit may have only accepted applicants who were likely to repay their credit, meaning the dataset represents only a subset of all applicants.

## Feature Engineering
The SQL file consists of a feature engineering pipeline across 7 tables. In total, 142 new features were engineered and added to the main table via SQL. The final CSV file was used in a Python machine learning pipeline in Google Colab.

## Machine Learning Pipeline
Missing values were identified and imputed. The dataframe was split into an 80% training set and 20% test set. A comparison of three models was conducted: Logistic Regression, GBMs and XGBoost.

First, all models were trained on 30% of the training set and evaluated on the test set to ensure comparability. GBMs have extremely long training duration in Python, which is why a hyperparameter search on the full training set would require too many resources. Since this was part of a theoretical paper on GBMs and XGBoost, all models were given the same training set to ensure equal conditions. The results show that Logistic Regression is beaten by GBMs, which is beaten by XGBoost.

Next, Logistic Regression and XGBoost were additionally trained on the full training set. The Logistic Regression still underperformed GBMs despite the larger training set, which further demonstrates the superiority of tree-based models for this task. The best model, XGBoost trained on the full training set, achieved an AUC of 0.782 and a recall of 0.65.

## Files
- `sample.csv`: a 100-row sample of the final table aggregated via SQL
- `loading_data.ipynb`: Python code run locally to load the dataset into MySQL
- `feature_engineering.sql`: SQL code used to aggregate all tables with the application_train dataset and engineer 142 new features
- `home_credit_main.ipynb`: Python code to train and compare Logistic Regression, GBMs and XGBoost

For exporting the final table to CSV, the MySQL export wizard was used. The SK_ID_CURR column was removed from the final CSV.

## Source
Anna Montoya, inversion, KirillOdintsov, and Martin Kotek. Home Credit Default Risk. https://kaggle.com/competitions/home-credit-default-risk, 2018. Kaggle.
