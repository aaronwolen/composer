#' Recursively merge values from list y into list x
#' @importFrom purrr list_modify
merge_metadata <- function(x, y) purrr::list_modify(list(x), y)[[1]]
