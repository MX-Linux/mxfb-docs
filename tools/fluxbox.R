

BASE_FILE <- "menu-mx_template"
TRANSLATIONS <- "MenuTransItems.csv"
OUT_FILE <- "menu-mx" 

mappings <- read.csv(TRANSLATIONS)
base <- readLines(BASE_FILE)

message("Welcome to fluxbox_trans.R")
message("I see ", ncol(mappings) - 1, " translations to make ")
message("Number of mappings = ", nrow(mappings))

message("Eliminating spaces before and after close and open parens")

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
    
    outfile <- paste(OUT_FILE, lang, sep = "_")
    message("Translated ", trcount, " terms")
    message("Writing ", outfile)
    writeLines(trans, outfile)
  }
}
