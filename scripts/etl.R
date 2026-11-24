
# =====================================
# SALES ETL PIPELINE
# STEP 1 - EXTRACT
# =====================================

library(dplyr)
library(readr)
library(DBI)
library(RSQLite)
library(lubridate)

# Read source data

sales_raw <- read_csv(
  "data/raw/sales_raw.csv",
  show_col_types = FALSE
)

# Display raw data

print(sales_raw)

# Number of records

cat("Extracted rows:", nrow(sales_raw), "\n")


# =====================================
# STEP 2 - DATA QUALITY CHECK
# =====================================

# Check number of rows
cat("Number of rows:", nrow(sales_raw), "\n")

# Check missing values
cat("Missing values:\n")

print(colSums(is.na(sales_raw)))

# Check duplicate order IDs
cat(
  "Duplicate order IDs:",
  sum(duplicated(sales_raw$order_id)),
  "\n"
)

# =====================================
# STEP 3 - DATA CLEANING
# =====================================

sales_clean <- sales_raw %>%
  
  # Remove unnecessary spaces
  mutate(
    customer = trimws(customer),
    product = trimws(product),
    category = trimws(category)
  ) %>%
  
  # Remove missing customers
  filter(
    !is.na(customer),
    customer != ""
  ) %>%
  
  # Remove invalid quantities
  filter(
    quantity > 0
  ) %>%
  
  # Remove invalid prices
  filter(
    unit_price >= 0
  ) %>%
  
  # Remove duplicate orders
  distinct(
    order_id,
    .keep_all = TRUE
  )

# Display cleaned data
print(sales_clean)

cat(
  "\nRows after cleaning:",
  nrow(sales_clean),
  "\n"
)


# =====================================
# STEP 4 - CALCULATE REVENUE
# =====================================

sales_clean <- sales_clean %>%
  
  mutate(
    revenue = quantity * unit_price
  )

print(
  sales_clean %>%
    select(order_id, product, quantity, unit_price, revenue)
)


# =====================================
# STEP 5 - SALES AGGREGATION
# =====================================

sales_summary <- sales_clean %>%
  
  group_by(category) %>%
  
  summarise(
    total_orders = n(),
    total_quantity = sum(quantity),
    total_revenue = sum(revenue),
    .groups = "drop"
  )

print(sales_summary)


# =====================================
# STEP 6 - SAVE TRANSFORMED DATA
# =====================================

write_csv(
  sales_clean,
  "output/sales_clean.csv"
)

write_csv(
  sales_summary,
  "output/sales_summary.csv"
)

cat("Transformed data saved successfully!\n")



# =====================================
# STEP 7 - LOAD DATA INTO SQLITE
# =====================================

# Create database connection

con <- dbConnect(
  SQLite(),
  "database/sales.db"
)

cat("Connected to SQLite database!\n")


# Load cleaned sales data

dbWriteTable(
  con,
  "sales_clean",
  sales_clean,
  overwrite = TRUE
)

# Load aggregated sales data

dbWriteTable(
  con,
  "sales_summary",
  sales_summary,
  overwrite = TRUE
)

cat("Data successfully loaded into SQLite!\n")

# Close database connection

dbDisconnect(con)

cat("ETL PIPELINE COMPLETED SUCCESSFULLY!\n")