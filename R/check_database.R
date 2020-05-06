#' @export
check_database <- function(path){
  qacademico <- read_qacademico(path)
  vars <- names(qacademico)

  total_cells <-  nrow(qacademico)*ncol(qacademico)
  incomplete_cells <- sum(rowSums(qacademico == "" | is.na(qacademico)))

  qacademico_check <- qacademico == "" | is.na(qacademico)

  incomplete <- NULL
  for(i in 1:nrow(qacademico)){
    incomplete[i] <- paste0(vars[qacademico_check[i,]], collapse = ", ")
  }

  data.frame("Matr\u00edcula" = qacademico[["Matr\u00edcula"]], Incompletos = incomplete,
             Curso = qacademico[["Curso"]],
             "Campus" = sub("IFPE / ",  "", qacademico[["Institui\u00e7\u00e3o"]]) ,
             stringsAsFactors = FALSE)
}

#' @export
write_incomplete_cases <- function(path){

  qacademico <- check_database(path) %>%
    dplyr::mutate(Campus = ifelse(Campus == "", "SEM CAMPUS", Campus),
                  Curso = ifelse(Curso == "", "SEM CURSO", Curso))

  campus <- unique(qacademico$Campus)

  for(i in 1:length(campus)){
    #browser()
    dir.create(paste0(path,"/IFPE/", campus[i]), recursive = TRUE)
    qacademico_campus <- qacademico %>%
      dplyr::filter(Campus == campus[i]) %>%
      dplyr::arrange(Matrícula)

    cursos <- unique(qacademico_campus$Curso)
    cursos <- gsub("/|:", "_", cursos)

    for(j in 1:length(cursos)){
      openxlsx::write.xlsx(qacademico_campus %>%
                             dplyr::filter(Curso == cursos[j]) %>%
                             dplyr::select(Matrícula, Incompletos),
                           paste0(path, "/IFPE/", campus[i], "/",
                                  cursos[j], ".xlsx")
      )
    }
  }


}
