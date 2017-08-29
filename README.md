
Install from github
-------------------

``` r
install_github( "ThinkR-open/uni" )
```

Examples
--------

Full unicode table, as a tibble, extracted from <https://github.com/unicode-table/unicode-table-data>

``` r
uni::code
#> # A tibble: 82,719 x 7
#>       id   rune                                              description
#>    <int>  <chr>                                                    <chr>
#>  1     0 U+0000                                               Null : NUL
#>  2     1 U+0001                                   Start of Heading : SOH
#>  3     2 U+0002                                      Start of Text : STX
#>  4     3 U+0003                                        End of Text : ETX
#>  5     4 U+0004                                End of Transmission : EOT
#>  6     5 U+0005                                            Enquiry : ENQ
#>  7     6 U+0006                                        Acknowledge : ASK
#>  8     7 U+0007                                               Bell : BEL
#>  9     8 U+0008                                           Backspace : BS
#> 10     9 U+0009  Horizontal Tabulation : ht : character tabulation : TAB
#> # ... with 82,709 more rows, and 4 more variables: block <chr>,
#> #   countries <chr>, languages <chr>, type <chr>
```

How many characters are used by each language

``` r
uni::code %>%
  filter( !is.na( languages ) ) %>%
  mutate( lang = languages %>% str_split(", ") ) %>%
  select(id, lang) %>%
  unnest() %>%
  count(lang, sort = TRUE) 
#> # A tibble: 89 x 2
#>          lang     n
#>         <chr> <int>
#>  1     korean 31825
#>  2    chinese 20851
#>  3   japanese 20574
#>  4 vietnamese 20369
#>  5    cia-cia 11171
#>  6         yi  1220
#>  7       cree   710
#>  8     arabic   380
#>  9   sanskrit   378
#> 10       kurd   303
#> # ... with 79 more rows
```
