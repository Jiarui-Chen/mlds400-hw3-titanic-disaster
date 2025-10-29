# import pacakges
library(dplyr)
library(readr)
library(caret)

print("==================================")
print("Read in dataset:")
titanic <- read_csv("train.csv", show_col_types = FALSE)
print(head(titanic))
print("==================================")

print("Drop features that won't be included in prediction: Name, Ticket, Cabin, Embarked")
titanic <- titanic %>% select(-c(Name, Ticket, Cabin, Embarked))
print(head(titanic))
print("==================================")

print("One Hot Encode the 'Pclass' feature:")
titanic <- titanic %>%
  mutate(
    Pclass_2 = ifelse(Pclass == 2, 1, 0),
    Pclass_3 = ifelse(Pclass == 3, 1, 0)
  ) %>%
  select(-Pclass)
print(head(titanic))
print("==================================")

print("Fill missing Age and Fare with median:")
titanic$Age[is.na(titanic$Age)] <- median(titanic$Age, na.rm = TRUE)
titanic$Fare[is.na(titanic$Fare)] <- median(titanic$Fare, na.rm = TRUE)
print(head(titanic))
print("==================================")

print("Feature engineering to see if the passenger is alone:")
titanic <- titanic %>%
  mutate(
    NotAlone = ifelse(SibSp + Parch > 0, 1, 0)
  ) %>%
  select(-c(SibSp, Parch))
print(head(titanic))
print("==================================")

print("Convert Sex column to numeric (IsMale):")
titanic <- titanic %>%
  mutate(IsMale = ifelse(Sex == "male", 1, 0)) %>%
  select(-Sex)
print(head(titanic))
print("==================================")

print("Normalize Age and Fare columns:")
titanic <- titanic %>%
  mutate(
    Age_Normalized = (Age - min(Age)) / (max(Age) - min(Age)),
    Fare_Normalized = (Fare - min(Fare)) / (max(Fare) - min(Fare))
  ) %>%
  select(-c(Age, Fare))
print(head(titanic))
print("==================================")

print("==================================")
print("Train the model:")
model <- glm(Survived ~ Pclass_2 + Pclass_3 + NotAlone + IsMale + Age_Normalized + Fare_Normalized, data = titanic, family = binomial)
preds <- ifelse(predict(model, type = "response") > 0.5, 1, 0)
acc <- mean(preds == titanic$Survived)
print("Training Accuracy")
print(acc)

# do the same data processing for test
print("==================================")
print("Read in test dataset:")
test <- read_csv("test.csv", show_col_types = FALSE)
print(head(test))
print("==================================")

print("Drop features that won't be included in prediction: Name, Ticket, Cabin, Embarked")
test <- test %>% select(-c(Name, Ticket, Cabin, Embarked))
print(head(test))
print("==================================")

print("One Hot Encode the 'Pclass' feature:")
test <- test %>%
  mutate(
    Pclass_2 = ifelse(Pclass == 2, 1, 0),
    Pclass_3 = ifelse(Pclass == 3, 1, 0)
  ) %>%
  select(-Pclass)
print(head(test))
print("==================================")

print("Fill missing Age and Fare with median:")
test$Age[is.na(test$Age)] <- median(test$Age, na.rm = TRUE)
test$Fare[is.na(test$Fare)] <- median(test$Fare, na.rm = TRUE)
print(head(test))
print("==================================")

print("Feature engineering to see if the passenger is alone:")
test <- test %>%
  mutate(
    NotAlone = ifelse(SibSp + Parch > 0, 1, 0)
  ) %>%
  select(-c(SibSp, Parch))
print(head(test))
print("==================================")

print("Convert Sex column to numeric (IsMale):")
test <- test %>%
  mutate(IsMale = ifelse(Sex == "male", 1, 0)) %>%
  select(-Sex)
print(head(test))
print("==================================")

print("Normalize Age and Fare columns:")
test <- test %>%
  mutate(
    Age_Normalized = (Age - min(Age)) / (max(Age) - min(Age)),
    Fare_Normalized = (Fare - min(Fare)) / (max(Fare) - min(Fare))
  ) %>%
  select(-c(Age, Fare))
print(head(test))
print("==================================")

print("Make Prediction")
y_pred <- ifelse(predict(model, newdata = test, type = "response")> 0.5, 1, 0)
print("Preview prediction")
print(y_pred)

# write output
test$Predicted <- y_pred
write.csv(test, "prediction_r.csv", row.names = FALSE)

