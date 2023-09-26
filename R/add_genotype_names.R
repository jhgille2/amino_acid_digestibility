#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param genotype_lookup_file
#' @param clean_aa_data
#' @return
#' @author Jay Gillenwater
#' @export
add_genotype_names <- function(genotype_lookup_file, clean_aa_data) {

  # Read in the genotype lookup table
  genotype_lookup_tbl <- read_csv(genotype_lookup_file)
  
  # Add the genotypes
  genotypes_added <- left_join(clean_aa_data, genotype_lookup_tbl, by = c("usda_id" = "id")) %>% 
    relocate(genotype, .after = "usda_id") %>% 
    relocate(location, .after = genotype)
  
  # Return the full table
  return(genotypes_added)
}
