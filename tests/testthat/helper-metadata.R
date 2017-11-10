# Example YAML files designed to simulate metadata defined in a
# home directory file, project directory file and within the function call
origins <- c("home", "project", "local")
# paths <- list.dirs(path = "tests/testthat/metadata")
paths <- list.dirs("metadata")
names(paths) <- origins

# load reference metadata
ref <- lapply(file.path(paths, "composer.yaml"), yaml::yaml.load_file)
names(ref) <- origins
