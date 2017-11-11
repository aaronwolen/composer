# composer

Composer automatically inserts values into the YAML frontmatter of RMarkdown documents. Use the `compose()` function to create a new document and specify the variables you would like to be defined in the frontmatter. 

```r
library(composer)
compose("my-report.Rmd", 
        author = "Aaron Wolen",
        title = "My Important Report")
```

This produces a standard RMardown template with the following frontmatter values:

```yaml
---
title: My Important Report
author: Aaron Wolen
output: html_document
---
```

You can also store value definitions in a YAML file called `.composer` located in either your user or project directory. For example:

```yaml
author: Aaron Wolen

linl:
  return-address: 
    - 456 Road St.
    - New York, NY
  closing: Thanks,

pinp:
  author: Aaron R. Wolen
  affiliation: Virginia Commonwealth University
```

This defines one global value, `author`, for use in *all* new RMarkdown documents, and a few other template-specific defintions, which are selectively applied to the appropriate template.

```r
compose("my-letter.Rmd", 
        template = "pdf", 
        package = "linl",
        address = c("Lars Homestead",
                    "Jundland Wastes, Tatooine"),
        opening = "Dear Luke,")
```

This creates a new letter with the following fontmatter:

```yaml
---
author: Aaron Wolen
opening: Dear Luke,
closing: Sincerely,
address:
  - Lars Homestead
  - Jundland Wastes, Tatooine
return-address:
  - 456 Road St.
  - New York, NY
output: linl::linl
---
```
