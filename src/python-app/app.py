import pandas as pd
import numpy as np
import sklearn
import os

from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

def process_data(data_source):
    print("=" * 40)
    # read data
    print("Read in dataset:")
    titanic = pd.read_csv(data_source)
    print(titanic.head())
    print("=" * 40)

    print("Drop features that won't be included in prediction: Name, Ticket, Cabin, Embarked")
    titanic = titanic.drop(["Name", "Ticket", "Cabin", "Embarked"], axis=1)
    print(titanic.head())
    print("=" * 40)
    
    print("One Hot Encode the 'Pclass' feature:")
    encoder = OneHotEncoder(drop="first", sparse_output=False) 
    encoded_pclass = encoder.fit_transform(titanic[['Pclass']])
    encoded_df = pd.DataFrame(encoded_pclass, columns=encoder.get_feature_names_out(['Pclass']))
    titanic[["Pclass_2", "Pclass_3"]] = encoded_df[["Pclass_2", "Pclass_3"]]
    titanic = titanic.drop("Pclass", axis=1)
    print(titanic.head())
    print("=" * 40)

    print("Fill missing age and fare with median:")
    titanic['Age'] = titanic['Age'].fillna(titanic['Age'].median())
    titanic['Fare'] = titanic['Fare'].fillna(titanic['Fare'].median())
    print(titanic.head())
    print("=" * 40)

    print("Feature engineering to see if the passenger is alone:")
    titanic['NotAlone'] = ((titanic['SibSp'] + titanic['Parch']) > 0) * 1.0
    titanic = titanic.drop(["SibSp", "Parch"], axis=1)
    print(titanic.head())
    print("=" * 40)

    print("Convert Sex Column to Numeric, Represented by a new column IsMale:")
    titanic["IsMale"] = (titanic["Sex"] == "male") * 1.0
    titanic = titanic.drop("Sex", axis=1)
    print(titanic.head())
    print("=" * 40)

    print("Normalize Age and Fare Column:")
    scaler = MinMaxScaler()
    titanic[["Age_Normalized", "Fare_Normalized"]] = scaler.fit_transform(titanic[['Age', 'Fare']])
    titanic = titanic.drop(["Age", "Fare"], axis=1)
    print(titanic.head())
    print("=" * 40)
    return titanic


def train_model(train_df):
    print("=" * 40)
    print("Train the model")
    model = LogisticRegression()
    model.fit(train_df[train_df.columns[2:]], train_df["Survived"])
    y_pred = model.predict(train_df[train_df.columns[2:]])
    print(f"Training Accuracy:", accuracy_score(train_df["Survived"], y_pred))
    return model


def test_model(model, test_data_source):
    print("=" * 40)
    print("Test the model")
    x_test_df = process_data(test_data_source)
    y_pred = model.predict(x_test_df[x_test_df.columns[1:]])
    y_pred = pd.DataFrame(y_pred)
    y_pred.columns = ["Prediction"]
    y_pred.to_csv("prediction.csv")


def main():
    train = process_data("train.csv")
    model = train_model(train)
    test_model(model, "test.csv")
    

if __name__ == "__main__":
    main()