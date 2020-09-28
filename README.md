# Statistical Rethinking: Rethought

> A repository of worked problems and examples from _Statistical Rethinking,
> 2nd Edition_ (McElreath, 2020), mainly in Julia and R.


## Introduction

This repository was created out of a desire to better understand Bayesian
statistics by learning from Richard McElreath's
[_Statistical Rethinking_][sr-book] textbook. Here, you will find (in progress!)
worked problems and example from the text. _Statistical Rethinking's_ language
of choice is [R][r-site], but this repo also attempts to replicate some of the
book using [Julia][julia-site].


## Structure

The code in this repo is organized by book chapter. Within each chapter folder
is code for both the textbook examples and problems, in each language.

### Chapters

 1) The Golem of Prague (_no code_)
 2) [Small Worlds and Large Worlds](chapters/ch02)


## Environments

The programming environments used to work through _Statistical Rethinking_ can
be recreated using the following methods:

### R

The R environment is managed with [**renv**][renv-site]. To recreate the
environment locally, simply open `statistical-rethinking.Rproj` in Rstudio then
run:

```r
renv::restore()
```

and the rest should be taken care of. One pacakge, **Rstan**, may require
additional setup described on the [Rstan Getting Started Wiki][rstan-wiki].
Another package of note is the companion package for this textbook:
[**rethinking**][rethinking-github].

### Juila

The Julia environment is managed by the native package manager and included
`Project.toml` file. The environment can be activated by setting Julia's
working directory to this repo then running either:

```julia
julia> using Pkg; Pkg.activate(pwd()) # From the Julia REPL
```
or

```julia
pkg> activate . # From the package REPL (type `]` in the Julia REPL)
```


-----

_Note: this repository uses the 2nd edition of the book, published in March,
2020._


[sr-book]: https://xcelab.net/rm/statistical-rethinking/
[r-site]: https://www.r-project.org
[julia-site]: https://julialang.org
[renv-site]: https://rstudio.github.io/renv/
[rstan-wiki]: https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
[rethinking-github]: https://github.com/rmcelreath/rethinking
