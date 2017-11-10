.onLoad <- function(libname, pkgname) { # nolint
  op <- options()
  op.composer <- list(
    composer.composer_file = ".composer"
  )
  toset <- !(names(op.composer) %in% names(op))
  if (any(toset)) options(op.composer[toset])
}
