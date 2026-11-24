packages <- c(
  "dplyr",
  "readr",
  "DBI",
  "RSQLite",
  "lubridate"
)

for (package in packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package)
  }
}