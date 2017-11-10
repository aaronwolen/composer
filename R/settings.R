#' Load user defined defaults for metadata values
#'
#' Check the user's home directory and current working directory for a
#' \code{.composer} YAML file.
#'
#' @param file YAML file containing metadata values
#' @param paths paths containing YAML files (for testing purposes)
#'
#' @importFrom purrr map map_chr discard reduce "%>%"
#' @importFrom yaml yaml.load_file
load_defaults <- function(
  paths = NULL,
  file = getOption("composer.composer_file"),
  template = NULL,
  package = NULL
  ) {

  # check home and working directory
  if (is.null(paths)) paths <- c(path.expand("~"), getwd())

  files <- map_chr(paths,
    ~ list.files(.x, pattern = file, all.files = TRUE, full.names = TRUE)[1])

  if (all(is.na(files))) return(NULL)

  metadata <- map(na.omit(files), yaml.load_file)
  metadata <- reduce(metadata, merge_metadata)

  # merge package- and template-specific values
  # (template nodes must belong to a package or are ignored)
  if (!is.null(package)) {
    if (!is.null(metadata[[package]])) {
      metadata <- merge_metadata(
        metadata,
        discard(metadata[[package]], .p = is.list)
      )
    }
    if (!is.null(template)) {
      if (!is.null(metadata[[package]][[template]])) {
        metadata <- merge_metadata(
          metadata,
          metadata[[package]][[template]]
        )
      }
    }
  }

  # drop unused package-specific values
  discard(metadata, .p = is.list)
}
