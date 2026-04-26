# home_credit_default_prediction

This project was part of a seminar paper "Gradient Boosting Machines & XGBoost" at University of Hamburg Business School.
Its objective was to show how GBMs and XGBoost compare to the less complex models logstic regression and simple classification trees for a binary classification problem.

The dataset was part of a Kaggle competition. My final model scores an ROC AUC value of 0.78. The best teams in the Kaggle competition scored an ROC AUC of just above 0.8. While in absolute terms
this seems to be a minor difference, for 300,000 datapoints this is still quite important. However, the diminshing returns at some point are too low for my usage of this project, which is why I decided to stop at that
point. Although it is noted that more features would be required to get a better result.

Explanation of the files:
sample.csv: a 100 row sample of the final table aggregated via SQL and used in python
loading_data.ipynb: python code run locally to install the datasets to mySQL
feature_engineering.sql: SQL code used to aggregate all tables with the application_train dataset and to engineer 142 new features
main.ipynb: python code for creating models etc.

For exporting home_credit_table to a csv file, the mySQL exporting wizard was used and the columns SK_ID_CURR where all removed from the final csv.

Observations & Disclaimers:

It is important to note that the data might underly an important selection bias. Home Credit might only have accepted potential credit takers that were likely to pay back their credit to begin with,
thus, the model has only been trained for this subset of every credit applier. But because the general trends and correlations of the data are likely to also apply for other people, the practical usage of the model
is still very high.

LLM Usage: While mainly serving as a data project for the seminar thesis, I also want it to be an example project for potential employers to show my data literacy
and understanding of SQL, Python and PowerBI. Using LLMs without actually understanding the code ("Vibe-Coding") and data would be missleading, thus I limited the usage of LLMs (mainly Claude Sonnet 4.6)
to understanding the distribution of the data in the columns of the original table scraped from Kaggle, identifying potential important features in the dataset and bug fixes. I fully understand, what the code does and could replicate it anytime.
