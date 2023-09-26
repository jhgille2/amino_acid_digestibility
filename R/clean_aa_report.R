#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param aa_report_file
#' @return
#' @author Jay Gillenwater
#' @export

# A function to clean up a raw amino acid report file
clean_aa_report <- function(aa_report_file){
  
  # Read in the report file
  aa_df <- read_excel(aa_report_file, col_names = FALSE)
  
  # A function to return the row numbers that define the boundaries for data
  # to be extracted
  get_row_indices <- function(aa_df){
    
    # col 1 as a character
    aa_df_col_1 <- as.character(unlist(aa_df[, 1]))
    aa_df_col_1 <- gsub("Taurine §", "Taurine", aa_df_col_1)
    
    # Which row has "ESCL #"
    escl_rows          <- which(aa_df_col_1 == "ESCL #")
    id_rows            <- which(aa_df_col_1 == "USDA ID")
    taurine_rows       <- str_detect(aa_df_col_1, "Taurine") %>% which()
    tryptophan_rows    <- which(aa_df_col_1 == "Tryptophan")
    total_rows         <- which(aa_df_col_1 == "Total")
    crude_protein_rows <- which(aa_df_col_1 == "Crude protein*")
    
    indices_tbl <- tibble(escl          = escl_rows,
                          ids           = id_rows,
                          taurine       = taurine_rows,
                          tryptophan    = tryptophan_rows,
                          total         = total_rows,
                          crude_protein = crude_protein_rows)
    
    return(indices_tbl)
  }
  
  # A function that takes the tibble of indices from the previous function
  # and uses it to subset the aa_df dataframe
  subset_aa_df <- function(escl, ids, taurine, tryptophan, total, crude_protein){
    
    # Get the IDs
    sample_ids <- aa_df[ids, ] %>% 
      unlist() %>% 
      as.character()
    
    sample_ids[1] <- "Phenotype"
    sample_ids    <- sample_ids[!is.na(sample_ids)]
    
    # The rows that hold the phenotype data
    pheno_rows <- c(taurine:tryptophan, total, crude_protein)
    
    # Subset the dataframe to only keep the phenotype data
    pheno_subset <- aa_df[pheno_rows, 1:length(sample_ids)] %>% 
      set_names(sample_ids) %>% 
      pivot_longer(cols = 2:ncol(.)) %>% 
      pivot_wider(names_from = Phenotype) %>% 
      rename(USDA_id = name) %>% 
      clean_names()
    
    return(pheno_subset)
  }
  
  
  # Get the row indides tibble from the amino acid report df
  indices_tbl <- get_row_indices(aa_df)
  
  # Apply the subsetting function to each combination of row indices and
  # bind the rows of all the results
  combined_pheno <- pmap_dfr(indices_tbl, subset_aa_df) %>% 
    mutate(across(2:ncol(.), as.numeric)) %>% 
    mutate(across(2:(ncol(.) - 2), function(x) x * 1000)) %>% 
    mutate(across(2:(ncol(.) - 2), function(x) x / crude_protein))
  
  return(combined_pheno)
}
