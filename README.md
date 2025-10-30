# mlds400-hw3-titanic-disaster

## Repo Overview

The repo contains two applications (in Python and R respectively) that both predicts the survival of Titanic passengers with the given information using a Logistic Regression model. The two applications can be built separately on local machine by following the instructions below. 

## How to run the repo?

### Before You Start
Please make sure you have account/access to the following:
- Github
- Docker Desktop

### Step 1: Data Download 
To get the data required for this repo to run, please navigate to https://www.kaggle.com/competitions/titanic/data and click on "Download All". The download will result in a .zip file. Please unzip the file and rename the file to "data" (case sensitive). 

### Step 2: Clone the Repo
Navigate to terminal, in the directory of your choice, run the following command

`git clone https://github.com/Jiarui-Chen/mlds400-hw3-titanic-disaster.git`

Once the repo is cloned, a folder named "mlds400-hw3-titantic-disaster" will appear in the directory. Open the "mlds400-hw3-titantic-disaster" folder and place the "data" folder you got from step 1 under "src". Make sure your local folder has the following structure:

```
mlds400-hw3-titanic-disaster
|--src
|   |--data
|   |--python-app
|   |--r-app
```

### Step 3: Run App

#### Python App:
Run the following command line by line under `src` directory to build docker image and run the prediction app in Python. 

`docker build -f python-app/Dockerfile -t titanic-python-app .`

`docker run titanic-python-app`

If the app runs successfully, you will be able to a series of data processing steps and training accuracy being printed to the terminal. 

#### R App: 
Run the following command line by line under `src` directory to build docker image and run the prediction app in R. 

`docker build -f r-app/Dockerfile -t titanic-r-app .`

`docker run titanic-r-app`

If the app runs successfully, you will be able to a series of data processing steps and training accuracy being printed to the terminal. 

### Step 4: Prediction Result Retrieval
After being executed successfully, both Python and R app will generate a prediction file in the working directory of the docker file. To retrieve this prediction file to your local machine, navigate to Docker Desktop Dashboard. Once there, select "Containers" in the menu bar on the left. Then, in the "Image" column, locate the image you ran in step 3 (with name either being "titanic-python-app" or "titanic-r-app"). Copy the Container ID (make sure you use the "Copy to Clipboard" icon to get the full ID) and run the following command: 

#### For Prediction File from the Python App
`docker cp <container_id>:prediction.csv <target_path>`

#### For Prediction File from the R App
`docker cp <container_id>:prediction_r.csv <target_path>`

Replace `<container_id>` with the container ID you copied and `<target_path>` with the directory where you want to store the prediction file at. 

Once done, you can view the survival prediction by the Logistic model at the path you specified. 