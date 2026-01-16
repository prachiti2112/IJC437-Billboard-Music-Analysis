#Installation of the libraries
install.packages("tidyverse")
install.packages("caret")
install.packages("randomForest")
install.packages("readr")
install.packages("ROCR")
install.packages("ggplot2")

#Main libraries 
library(tidyverse)
library(caret)
library(randomForest)
library(ROCR)
library(ggplot2)

#Lodaing the dataset(csv)
data<- read_csv("billboard_24years_lyrics_spotify.csv")

#Cleaning the data set & Pre-processing
data_clean<- data %>%
  distinct(song,band_singer,year, .keep_all = TRUE)%>%
  drop_na(ranking,
          danceability,
          energy,
          loudness,
          tempo,
          valence,
          acousticness) %>% 
  mutate(
    decade = floor(year/10)*10
  )
glimpse(data_clean)

#Training / testing split
set.seed(123)
train_index <- createDataPartition(data_clean$ranking,p=0.7,list = FALSE)
train <- data_clean[train_index, ]
test <- data_clean[-train_index, ]

#Figure 1- EDA(distributing the chart rank)
ggplot(data_clean , aes(ranking))+
  geom_histogram(bins = 30) +
  labs(
    title="Distribution of Billboard Hot-100 charts ranks",
    x="Chart Rank(Lower = Higher Popularity)",
    y="Number of songs"
  )+
  theme_minimal()

#Figure 2 - danceability overtime 
ggplot(data_clean,aes(x=year,y=danceability))+
  stat_summary(fun = mean,geom = "line",linewidth=1)+
  stat_summary(fun = mean,geom = "point")+
  labs(
    title = "Average Danceability of Billboard Hot-100 Songs (2000-2023)",
    x="Year",
    y="Average Dancebility"
  )+
  theme_minimal()
#Figure 3-Multiple feature trends 
data_long <- data_clean %>%
  select(year,danceability,energy,loudness,acousticness) %>%
  pivot_longer(-year,names_to = "feature",values_to = "value")
ggplot(data_long,aes(x=year,y=value,color=feature))+
  stat_summary(fun=mean,geom = "line",linewidth = 1)+
  labs(
    title = "Trends in musical features of billboard Hot-100 songs",
    x="year",
    y="Average feature value",
    color="feature"
  )+
  theme_minimal()
#Figure 4-comparing the deacades 
ggplot(data_clean,aes(x=factor(decade),y=danceability))+
  geom_boxplot()+
  labs(
    title = "Distribution of Danceability by Decade", 
    x="Decade",
    y="Dancebility"
  )+
  theme_minimal()
#Figure 5-Featuring relationships with chart success 
cor_data <- data_clean %>%
  select(ranking,danceability,energy,loudness,tempo,valence,acousticness) %>%
  pivot_longer(-ranking,names_to = "feature",values_to = "value")
ggplot(cor_data,aes(x=value,y=ranking))+
  geom_point(alpha=0.2)+
  geom_smooth(method = "lm",se=FALSE)+
  facet_wrap(~feature , scales = "free_x")+
  labs(
    title = "Relationship between musical features and billboard chart rank",
    x="Feature Value",
    y="Chart Rank(lower = better)"
  )+
  theme_minimal()
#Linear regression model
lm_model <-lm(
  ranking ~ danceability+energy+loudness+tempo+valence,
  data = train
)
pred_lm <- predict(lm_model,newdata = test)
summary(lm_model)
#Random Forest model
rf_model <- randomForest(
  ranking ~ danceability + energy + loudness + tempo +valence,
  data = train,
  importance = TRUE
)
pred_rf <- predict(rf_model,newdata = test )
summary(rf_model)
#Models performance (RMSE)
rmse_lm <- RMSE(pred_lm,test$ranking)
rmse_rf <- RMSE(pred_rf,test$ranking)

rmse_lm
rmse_rf
#Figure 6- Prediction vs actual result 
model_results <- tibble(
  Actual = test$ranking,
  Linear_Regression = pred_lm,
  Random_Forest = pred_rf
) %>%
  pivot_longer(-Actual,names_to = "Model", values_to = "Predicted")
ggplot(model_results,aes(x=Actual , y=Predicted))+
  geom_point(alpha = 0.3)+
  geom_abline(linetype = "dashed")+
  facet_wrap(~Model)+
  labs(
    title="Prediction vs Actual Billboard chart rank",
    x="Actual Chart Rank",
    y="Predicted Chart Rank"
  )+
  theme_minimal()
#Figure 7- Featuring importance 
importance_df <- importance(rf_model) %>%
  as.data.frame() %>%
  rownames_to_column("Feature")

ggplot(importance_df, aes(
  x=reorder(Feature,IncNodePurity),
  y=IncNodePurity
))+
  geom_col()+
  coord_flip()+
  labs(
    title = "Features Importance from Random forest model",
    x="Features",
    y="Importance"
  )+
  theme_minimal()



