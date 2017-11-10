#' Compose a new Rmarkdown document based on a template
#'
#' @inheritParams rmarkdown::draft
#' @param ... additional metadata variables to include in the YAML front matter.
#'   NOTE: dots within variable names will be replaced with hyphens in the
#'   output (e.g., \code{font.family} will become \code{font-family}).
#'
#' @examples
#' compose("report.Rmd", author = "Aaron Wolen")
#'
#' @importFrom rmarkdown draft
#' @export
compose <- function(file,
                  template,
                  package = NULL,
                  create_dir = "default",
                  edit = TRUE, ...) {

  # default to included rmd template
  if (missing(template)) {
    template <- "report"
    package  <- "composer"
  }

  file <- rmarkdown::draft(file, template, package, create_dir, edit = FALSE)

  args <- list(...)
  names(args) <- gsub("\\.", replacement = "-", names(args))

  letter <- readLines(file, encoding = getOption("encoding"))
  body <- rmarkdown:::partition_yaml_front_matter(letter)$body

  # merge arguments and user files into document metadata
  metadata <- rmarkdown::yaml_front_matter(file) %>%
    merge_metadata(load_defaults(template = template, package = package)) %>%
    merge_metadata(args)

  metadata <- paste0(
      "---\n",
      yaml::as.yaml(metadata, indent.mapping.sequence = TRUE),
      "---\n",
      collapse = ""
  )

  writeLines(c(metadata, body), con = file)

  # invoke the editor if requested
  if (edit)
    utils::file.edit(normalizePath(file))

  # return the name of the file created
  invisible(file)
}
