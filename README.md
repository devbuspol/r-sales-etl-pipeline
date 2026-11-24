
# Sales Data ETL Pipeline in R

## Project Overview

This project demonstrates an ETL (Extract, Transform, Load)
pipeline developed using R.

The pipeline extracts raw sales data from CSV files,
cleans and transforms the data, calculates revenue,
aggregates sales and loads the results into a SQLite database.

## Technologies

- R
- SQL
- SQLite
- dplyr
- readr
- DBI
- RSQLite
- lubridate

## ETL Architecture

1. Extract - Import raw sales data from CSV.
2. Transform - Clean data, remove duplicates and calculate revenue.
3. Load - Save processed data into SQLite database.

## Project Structure

```text
r-sales-etl-pipeline/
├── data/
│   └── raw/
├── scripts/
│   └── etl.R
├── output/
├── database/
├── requirements.R
└── README.md
```

## Data Quality

The pipeline handles:
- Missing customer values
- Duplicate order IDs
- Invalid quantities
- Revenue calculations

## Output

The pipeline generates:
- sales_clean.csv
- sales_summary.csv
- SQLite database with processed tables

## How to Run

1. Clone this repository.
2. Install R.
3. Run requirements.R.
4. Execute the ETL script:

```r
source("requirements.R")
source("scripts/etl.R")
```

## Author

Piotr Oswiecimski

## License

MIT
