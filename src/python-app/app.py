import numpy as np
import pandas as pd
import sklearn
import os

# test code
df = pd.read_csv(os.path.join(os.path.dirname(__file__), "../data/train.csv"))
print(df.head(5))