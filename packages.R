# Install pacman if it is not already installed
if (!require("pacman")) install.packages("pacman")

# Load required packages
pacman::p_load(conflicted,
               dotenv,
               targets,
               tarchetypes,
               here)

pacman::p_load(readxl,
               readr,
               tidyr,
               stringr,
               dplyr,
               purrr,
               janitor)
