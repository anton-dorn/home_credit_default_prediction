# home_credit_default_prediction

This project was part of a seminar paper "Gradient Boosting Machines & XGBoost" at University of Hamburg Business School.
It's objective was to show how GBMs and XGBoost compare to the less complex models logstic regression and simple classification trees.

It is important to note that the data might underly an important selection bias. Home Credit might only have accepted potential credit takers that were likely to pay back their credit to begin with,
thus, the model has only been trained for this subset of every credit applier. But because the general trends and correlations of the data are likely to also apply for other people, the practical usage of the model
is still very high.

LLM Usage: While mainly serving as a data project for the seminar thesis, I also want it to be an example project for potential employers to show my data literacy
and understanding of SQL, Python and PowerBI. Using LLMs without actually understanding the code ("Vibe-Coding") and data would be missleading, thus I limited the usage of LLMs (mainly Claude Sonnet 4.6)
to understanding the distribution of the data in the columns of the original table scraped from Kaggle, identifying potential important features in the dataset and bug fixes. I fully understand, what the code does.

Competition: The dataset was published by Home Credit for a Kaggle-Competition. While I used the dataset, I did not participate the competition and the results are completely independend of it.
