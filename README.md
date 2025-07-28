# Customer Segmentation Based on Income and Preferred Brand

## 📘 Project Overview

This project applies unsupervised machine learning using k-means clustering to segment customers based on their income and preferred car brand. The analysis helps businesses better understand customer preferences, identify high-value segments, and tailor marketing strategies.

---

## 🔍 Objectives

- Segment customers using income and brand preference
- Visualize clusters using ggplot2
- Summarize segment insights to identify business opportunities

---

## 🛠️ Tools & Technologies

| Component       | Tool/Package       |
|-----------------|--------------------|
| Language        | R                  |
| IDE             | RStudio            |
| Visualization   | ggplot2            |
| Data Wrangling  | dplyr              |
| Clustering      | kmeans             |

---

## 📦 Methodology

1. **Data Preparation**
   - Imported a dataset with 300 customers and multiple features including `Income`, `Preferred_Brand`, etc.
   - Cleaned and standardized variables.

2. **Customer Segmentation**
   - Applied k-means clustering on scaled income values.
   - Assigned cluster labels to each customer.
   - Created a new factor column: `Segment_IncomeBrand`.

3. **Visualization**
   - Used `ggplot2` with `geom_jitter()` to display income vs. brand preference colored by segment.
   - Clear separation of customer clusters was visible by income levels and brand affinity.

4. **Segment Summary**
   - Aggregated average income, top brand, and count per segment using `dplyr`.

---

## 📊 Segment Insights

| Segment | Avg_Income | Top_Brand | Count |
|---------|------------|-----------|-------|
| 1       | ₹1,389,097 | Hyundai   | 127   |
| 2       | ₹1,857,599 | Toyota    | 104   |
| 3       | ₹3,581,918 | BMW       | 69    |

- **Segment 1**: Budget-conscious, prefers Hyundai/Kia.
- **Segment 2**: Mid-income, leans toward Toyota.
- **Segment 3**: High-income, luxury buyers favoring BMW/Mercedes.

---

