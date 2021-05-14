# Localize base file(s) based on a translations file
# 2021-05-14 Ben Bond-Lamberty

BASE_FILES <- list.files(pattern = "_template")

TRANSLATIONS <- "MenuTransItems.csv"

OUTPUT_DIR <- "../menu-translations/"

mappings <- read.csv(TRANSLATIONS)
message("Welcome to fluxbox_trans.R")
message("I see ", length(BASE_FILES), " base template files")
message("I see ", ncol(mappings) - 1, " translations to make")
message("Number of mappings = ", nrow(mappings))
message("Eliminating spaces before and after close and open parens")

for(bf in BASE_FILES) {
  message("------------------------------------")
  message("Processing ", bf)
  base <- readLines(bf)
  
  for(i in seq_along(mappings)) {
    message("------------------------------------")
    lang <- colnames(mappings)[i]
    message(lang)
    
    trans <- base
    trcount <- 0
    
    for(j in seq_len(nrow(mappings))) {
      # First column holds the English term to translate
      term <- paste0("\\(", trimws(mappings[j, 1]), "[[:space:]]*\\)")
      
      # jth column holds translated term
      transterm <- paste0("(", trimws(mappings[j, i]), ")")
      
      if(transterm != "" & !is.na(transterm)) {
        if(any(grepl(term, base))) {
          # message("\t", term, " -> ", transterm)
          trans <- gsub(term, transterm, trans)
          trcount <- trcount + 1
        } else {
          message("\tNot found: ", term)
        }
      } else {
        message("\tNo translation provided for ", term)
      }
      
      # Write the language-specific output file
      outfile <- paste(gsub("_template", "", bf), lang, sep = "_")
      message("Translated ", trcount, " terms")
      message("Writing ", outfile)
      writeLines(trans, file.path(OUTPUT_DIR, outfile))
    } # for j
  } # for i
} # for bf

message("All done.")
