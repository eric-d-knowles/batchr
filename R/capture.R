#' @export
capture_code <- function(notebook,
                         mode  = c("exclude", "include"),
                         start = "#\\| ?batch:start",
                         end   = "#\\| ?batch:end") {
  mode <- match.arg(mode)
  code <- if (length(notebook) > 1 || !file.exists(notebook[1])) notebook
          else switch(tolower(tools::file_ext(notebook)),
            rmd = , qmd = { o <- tempfile(fileext = ".R")
                            knitr::purl(notebook, o, documentation = 0, quiet = TRUE); readLines(o) },
            ipynb = { nb <- jsonlite::fromJSON(notebook, simplifyVector = FALSE)
                      cc <- Filter(\(c) c$cell_type == "code", nb$cells)
                      unlist(lapply(cc, \(c) c(unlist(c$source), ""))) },
            readLines(notebook))
  s <- grep(start, code); e <- grep(end, code)
  if (!length(s)) {
    if (mode == "include")
      stop("include mode, but no batch:start/end markers found — nothing to capture.")
    return(code)
  }
  if (length(s) != length(e))
    stop("Unbalanced batch markers: ", length(s), " start(s), ", length(e), " end(s).")
  if (any(e <= s)) stop("A batch:end precedes its start — check marker order.")
  if (mode == "exclude") {
    code[-unlist(Map(seq, s, e))]
  } else {
    code[unlist(Map(\(a, b) if (b > a + 1) (a + 1):(b - 1), s, e))]
  }
}