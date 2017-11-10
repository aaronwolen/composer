context("Metadata Discovery")

# use included test YAML files
op <- options()
options(composer.composer_file = "composer.yaml")

test_that("test composer file is set", {
  expect_equal(options()$composer.composer_file, "composer.yaml")
})

test_that("return NULL if nothing is found", {
  expect_null(load_defaults(paths = ""))
})

test_that("settings are loaded", {
  expect_is(load_defaults(paths["home"]),    "list")
  expect_is(load_defaults(paths["project"]), "list")
  expect_is(load_defaults(paths["local"]),   "list")
})

test_that("settings are loaded without matching package/template", {
  # verify the reference values do not contain package settings
  expect_false(any(sapply(ref$local, is.list)))

  expect_is(
    load_defaults(paths[3], template = "t1", package = "p1"),
    "list"
  )
})

context("Metadata Scoping")

test_that("project settings overwrite home settings", {
  md <- load_defaults(paths[1])
  expect_equal(md$key2, ref$home$key2)

  md <- load_defaults(paths[1:2])
  expect_equal(md$key2, ref$project$key2)
})

test_that("local settings overwrite home/project settings", {
  md <- load_defaults(paths)
  expect_equal(md$key2, ref$local$key2)
})

test_that("package/template values are ignored by default", {
  md <- load_defaults(paths)
  expect_null(md$key4)
})

test_that("template values are ignored without specifying package", {
  md <- load_defaults(paths, template = "template1")
  expect_null(md$key4)
})

test_that("package values are loaded and overwrite matching values", {
  md <- load_defaults(paths, package = "package2")
  expect_equal(md$key5, ref$home$package2$key5)
  expect_equal(md$key2, ref$home$package2$key2)
})

test_that("template values are loaded and overwrite matching values", {
  md <- load_defaults(paths, package = "package1", template = "template1")
  expect_equal(md$key4, ref$home$package1$template1$key4)
  expect_equal(md$key1, ref$home$package1$template1$key1)
})

options(op)