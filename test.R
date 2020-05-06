b <- ifpe::check_database("C:/Pesquisa/dados/qacademico/")
a <- ifpe:::read_qacademico("C:/Pesquisa/dados/qacademico/")
ifpe::write_incomplete_cases("C:/Pesquisa/dados/qacademico/")

matricula <- "20151C31RC0233"

# recent year
b[[1]] %>%
  filter(Matrícula == matricula) %>%
  select(Situação.Matrícula, Situação.Período)

# most recent Matricula
b %>%
  bind_rows() %>%
  filter(Matrícula == matricula) %>%
  distinct(Matrícula, .keep_all = TRUE) %>%
  select(Situação.Matrícula, Situação.Período)

# all records
b %>%
  bind_rows() %>%
  filter(Matrícula == matricula) %>%
  select(Situação.Matrícula, Situação.Período)

#################################################
b1 <- b == "" | is.na(b)
vars <- names(b)

incomplete <- NULL
for(i in 1:nrow(b)){
  incomplete[i] <- paste0(vars[b1[i,]], collapse = ", ")
}

result <- data.frame(Matricula = b$Matrícula, Incompletos = incomplete,
                     stringsAsFactors = FALSE)
#################################################


path <- "C:/Pesquisa/dados/qacademico"

campus <- unique(b$Campus)
campus[campus == ""] <- "SEM CAMPUS"



for(i in 1:length(campus)){
  b1 <- b %>%
    dplyr::filter(Campus == campus[i])

  cursos <- unique(b1$Curso)
  cursos[cursos == ""] <- "SEM CURSO"

  for(j in 1:length(cursos)){

    openxlsx::write.xlsx(b1 %>% dplyr::filter(Curso == cursos[j]),
                         paste0(path, "/IFPE/", campus[i], "/",
                                cursos[j], ".xlsx")
                         )
  }
}






