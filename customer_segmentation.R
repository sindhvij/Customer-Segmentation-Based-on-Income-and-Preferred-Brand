# Load required library
library(dplyr)
set.seed(123)

# Define constants
n <- 300
zones <- c("Sadashiv Nagar", "JP Nagar", "Indiranagar", "Whitefield", 
           "HSR Layout", "Basaveshwar Nagar", "Sunkadakatte", "Ullal", "Hebbal")

# Generate City Zone
City_Zone <- sample(zones, n, replace = TRUE)

# Income logic based on zone
generate_income <- function(zone) {
  if (zone == "Sadashiv Nagar") {
    runif(1, 2500000, 5000000)
  } else if (zone %in% c("JP Nagar", "Indiranagar")) {
    if (runif(1) < 0.4) runif(1, 3000000, 5000000) else runif(1, 1500000 , 3000000)
  } else if (zone %in% c("Whitefield", "HSR Layout", "Basaveshwar Nagar")) {
    if (runif(1) < 0.6) runif(1, 2000000, 3000000) else runif(1, 600000, 2000000)
  } else {
    if (runif(1) < 0.9) runif(1, 600000, 1500000) else runif(1, 1500000, 2000000)
  }
}
Income <- sapply(City_Zone, generate_income) %>% round()

# Age distribution: more in range 30–50
Age <- sample(22:65, n, replace = TRUE, prob = dnorm(22:65, mean = 38, sd = 10))

# Purchase frequency based on income
Purchase_Frequency <- sapply(Income, function(x) {
  if (x > 3000000) sample(2:3, 1) else if (x > 1500000) sample(1:3, 1) else sample(1:2, 1)
})

# Car Type logic
Car_Type <- sapply(Income, function(x) {
  if (x > 3000000) sample(c("SUV", "Luxury", "EV", "Sedan"), 1) 
  else if (x > 1500000) sample(c("Sedan", "SUV", "EV", "Hatchback"), 1)
  else sample(c("Hatchback", "Sedan", "SUV"), 1)
})

# Fuel Type logic
Fuel_Type <- sapply(Income, function(x) {
  if (x > 2500000) sample(c("Petrol", "Diesel", "Electric", "Hybrid"), 1, prob = c(0.2, 0.2, 0.5, 0.1))
  else sample(c("Petrol", "Diesel", "Electric"), 1, prob = c(0.5, 0.4, 0.1))
})

# Finance Type logic
Finance_Type <- mapply(function(zone, income) {
  if (zone == "Sadashiv Nagar" || income > 3000000) {
    sample(c("Cash", "Loan", "Lease"), 1, prob = c(0.7, 0.25, 0.05))
  } else if (zone %in% c("JP Nagar", "Indiranagar", "Whitefield", "HSR Layout", "Basaveshwar Nagar")) {
    sample(c("Cash", "Loan", "Lease"), 1, prob = c(0.4, 0.5, 0.1))
  } else {
    sample(c("Cash", "Loan", "Lease"), 1, prob = c(0.1, 0.85, 0.05))
  }
}, City_Zone, Income)

# Brand logic
Preferred_Brand <- mapply(function(zone, income) {
  if (zone == "Sadashiv Nagar") {
    sample(c("BMW", "Mercedes", "Porsche", "Toyota", "Mahindra"), 1, prob = c(0.3, 0.3, 0.2, 0.1, 0.1))
  } else if (zone %in% c("JP Nagar", "Indiranagar")) {
    if (income > 3000000) sample(c("BMW", "Mercedes", "Toyota", "Kia", "Volkswagen"), 1, prob = c(0.4, 0.3, 0.1, 0.1, 0.1))
    else sample(c("Toyota", "Hyundai", "Kia", "Volkswagen"), 1)
  } else if (zone %in% c("Whitefield", "HSR Layout", "Basaveshwar Nagar")) {
    if (income > 2000000) sample(c("Toyota", "Mahindra", "Volkswagen", "BMW", "Hyundai", "Tata"), 1)
    else sample(c("Hyundai", "Tata", "Kia", "Toyota"), 1)
  } else {
    if (income < 1200000) sample(c("Maruti Suzuki", "Hyundai", "Tata"), 1, prob = c(0.5, 0.3, 0.2))
    else sample(c("Hyundai", "Tata", "Toyota", "Mahindra"), 1)
  }
}, City_Zone, Income)

# Combine all into final dataframe
customers <- data.frame(
  Customer_ID = 1:n,
  Age = Age,
  Income = Income,
  Car_Type = Car_Type,
  Fuel_Type = Fuel_Type,
  Purchase_Frequency = Purchase_Frequency,
  Finance_Type = Finance_Type,
  Preferred_Brand = Preferred_Brand,
  City_Zone = City_Zone
)


# Load necessary libraries
library(dplyr)
library(ggplot2)
library(factoextra)

# Step 1: Encode Preferred_Brand to numeric and store factor levels
customers$Preferred_Brand_Factor <- as.factor(customers$Preferred_Brand)
customers$Brand_Code <- as.numeric(customers$Preferred_Brand_Factor)

# Save brand levels for labeling
brand_levels <- levels(customers$Preferred_Brand_Factor)

# Step 2: Select and scale relevant features
clust_data <- customers %>%
  dplyr::select(Income, Brand_Code) %>%
  scale()

# Step 3: Run K-Means clustering (k = 3)
set.seed(123)
fviz_nbclust(clust_data, kmeans, method = "wss")
fviz_nbclust(clust_data, kmeans, method = "silhouette") 
fviz_nbclust(clust_data, kmeans, method = "gap_stat")


kmeans_result <- kmeans(clust_data, centers = 3, nstart = 25)

# Step 4: Assign segment labels to main dataset
customers$Segment_IncomeBrand <- as.factor(kmeans_result$cluster)

# Step 5: Visualize the clusters with brand labels
ggplot(customers, aes(x = Brand_Code, y = Income, color = Segment_IncomeBrand)) +
  geom_jitter(width = 0.3, size = 3, alpha = 0.7) +
  scale_x_continuous(
    breaks = 1:length(brand_levels),
    labels = brand_levels
  ) +
  labs(
    title = "Customer Segmentation Based on Income and Preferred Brand",
    x = "Preferred Brand",
    y = "Income (INR)",
    color = "Segment"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # rotate x labels

# Step 6: Segment Summary
segment_summary <- customers %>%
  group_by(Segment_IncomeBrand) %>%
  summarise(
    Avg_Income = round(mean(Income)),
    Top_Brand = names(sort(table(Preferred_Brand), decreasing = TRUE))[1],
    Count = n()
  )

print(segment_summary)