# home_credit_default_prediction
This project was part of a seminar paper on Gradient Boosting Machines & XGBoost at the University of Hamburg Business School. The dataset originates from a Kaggle competition by Home Credit on credit default risk prediction.

## Observations & Disclaimers
It is important to note that the data may be subject to selection bias. Home Credit may have only accepted applicants who were likely to repay their credit, meaning the dataset represents only a subset of all applicants.

## Feature Engineering
The SQL file consists of a feature engineering pipeline across 7 tables. In total, 142 new features were engineered and added to the main table via SQL. The final CSV file was used in a Python machine learning pipeline in Google Colab.

## Machine Learning Pipeline
Missing values were identified and imputed with the value "Unknown". The dataframe was split into an 80% training set and 20% test set using stratified sampling to preserve the class distribution of the binary target variable.

Three models were trained on the full training set and evaluated on the test set: Logistic Regression as a baseline, a Gradient Boosting Machine (GBM), and XGBoost. Class imbalance (~8% defaults) was addressed via sample weighting. A hyperparameter search via RandomizedSearchCV was conducted for XGBoost and the resulting optimal parameters were transferred to the GBM, following the hypothesis that both models are structurally similar.

The best model, GBM, achieved an AUC of 0.783 and a Recall of 0.65 on the test set.

## Files
- `sample.csv`: a 100-row sample of the final table aggregated via SQL
- `loading_data.ipynb`: Python code run locally to load the dataset into MySQL
- `feature_engineering.sql`: SQL code used to aggregate all tables with the application_train dataset and engineer 142 new features
- `home_credit_main.ipynb`: Python code to train and compare Logistic Regression, GBMs and XGBoost

For exporting the final table to CSV, the MySQL export wizard was used. The SK_ID_CURR column was removed from the final CSV.

## Source
Anna Montoya, inversion, KirillOdintsov, and Martin Kotek. Home Credit Default Risk. https://kaggle.com/competitions/home-credit-default-risk, 2018. Kaggle.
