# Home Credit Default Risk Prediction

This project was built as part of a seminar paper on Gradient Boosting Machines and XGBoost at Hamburg Business School (University of Hamburg). The data comes from the Kaggle competition "Home Credit Default Risk" (2018): a binary classification task to predict whether a loan applicant will default.

## Pipeline Overview

1. Load the raw Kaggle tables into MySQL (`loading_data.ipynb`)
2. Feature engineering in SQL across 7 tables (`feature_engineering.sql`)
3. Model training and evaluation in Python on Google Colab (`home_credit_main.ipynb`)

## Feature Engineering

The SQL pipeline joins 7 tables and adds 142 engineered features to the main application table, for example `ratio_annuity_income` and `avg_debt_to_credit_ratio`. The final table was exported to CSV using the MySQL export wizard. The ID column `SK_ID_CURR` was dropped before modeling.

## Modeling

Missing values occurred only in categorical variables and were imputed with the value "Unknown", so that missingness is treated as its own category. The data was split 80/20 into training and test set using stratified sampling to preserve the class distribution of the target (~8% defaults). Class imbalance was addressed through sample weighting.

Three models were trained and compared:

- Logistic Regression as a baseline
- Gradient Boosting Machine (GBM)
- XGBoost

Hyperparameters were tuned for XGBoost via RandomizedSearchCV. Because of the compute limits of the Colab environment, no separate search was run for the GBM. Instead, the shared parameters (learning rate, tree depth, number of estimators, subsampling) were transferred from the XGBoost search, since both models build on the same gradient boosting framework. XGBoost-specific regularization parameters have no GBM equivalent and were left out.

**Best model: GBM with an AUC of 0.783 and a recall of 0.65 on the test set** — slightly ahead of XGBoost, even though the parameters were originally tuned for XGBoost.

## Limitations

- The data is likely subject to selection bias. Home Credit only observes the repayment behavior of accepted applicants, so the dataset does not represent the full applicant population.
- Recall is reported at the default classification threshold of 0.5.

## Files

- `loading_data.ipynb` — loads the raw dataset into MySQL (run locally)
- `feature_engineering.sql` — joins all tables with `application_train` and engineers the 142 features
- `home_credit_main.ipynb` — trains and compares Logistic Regression, GBM and XGBoost
- `sample.csv` — a 100-row sample of the final aggregated table

## Data Source

Anna Montoya, inversion, KirillOdintsov, and Martin Kotek. Home Credit Default Risk. Kaggle, 2018. https://kaggle.com/competitions/home-credit-default-risk
