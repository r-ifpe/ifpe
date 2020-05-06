

#' @importFrom rlang sym
#' @importFrom dplyr %>%
read_qacademico <- function(path){
  temp <-  list.files(path = path, pattern = "*.csv")
  temp <- paste0(path , "/", temp) %>% sort(decreasing = TRUE)

  classes <- c(Cpf = "character", "Percentual Frequencia" = "character")

  lapply(temp, function(e){
    utils::read.csv(e, sep = "",  stringsAsFactors = FALSE,
                    encoding = "latin1", colClasses = classes,
                    check.names = FALSE)
  }) %>%
    dplyr::bind_rows() %>%
    dplyr::distinct(!!sym("Matr\u00edcula"), .keep_all = TRUE)
}
