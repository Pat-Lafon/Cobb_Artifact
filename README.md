# Cobb_Artifact

## Introduction

This is the accompanying artifact for `We've Got You Covered: Type-Guided Repair
of Incomplete Input Generators`. A PDF of this paper is included in the root directory.

Submissions to OOPSLA'25 required a Data-Availability Statement which describes
the expectations of this artifact and is included below. This artifact is the
code and benchmark part of what was provided in the supplementary materials,
provided in a form that is evaluable and reproducible.

```text
Data-Availability Statement

Our supplementary material includes an anonymized artifact. This artifact contains the OCaml
source code for Cobb and of the modified dependencies, our suite of benchmark programs with results and scripts used to produce our experimental results. We intend to submit this artifact for
evaluation by the artifact evaluation committee should this paper be accepted.
```

### Contents and Claims

This artifact will contain the source code for Cobb, the benchmark files and
outputted results for RQ's 1-4(specifically Tables 1, Figure 11, Figure 12,
Figure 13, and Figure 14). We provided our modified version of Poirot(from
`Covering All the Bases: Type-Based Verification of Test Input Generators`). We
will provide a docker image of this with the necessary dependencies and a
sufficient set of package management files to compile this project locally.

Note that this project uses the following Z3 version and was run on an 2020 M1
13-inch MacBook Pro with 8 GB of memory. Getting as close to this setup as
possible, such as using this exact version of Z3, is crucial to reliable
producing these results. SMT solvers are notoriously
unstable(<https://www.contrib.andrew.cmu.edu/~bparno/papers/mariposa.pdf>) along
multiple dimensions and small differences can cause the solver to run for a
different amount of time or return an inconclusive result(Which will alter the
steps/result of the synthesis procedure).

```sh
z3 --version
Z3 version 4.15.1 - 64 bit
```

### Differences since initial submission.

- Since the initial submission, Cobb's use of a smt solver portfolio has
  improved with an additional solver variation and a `first-to-succeed`
  approach. While the algorithm has not changed, the overall runtime is on
  average reduced.
- This paper is under minor revision and as such will be extended with 3
  additional evaluations/studies/deliverables which will be submitted by July
  29 - Submission of Revisions R2 deadline. The following is the set of changes
  that were proposed and then accepted by reviewers. We do not expect there to
  be any major changes to the algorithm/artifact other than setup to run the following:
  - Conduct an ablation study on the effectiveness of Cobb's best-effort
    strategy when the solution space is incomplete.
  - Run an ablation study on the sensitivity of Cobb to superfluous components.
  - Add a table with the percentage of non-unique terms from the benchmarks to
    the appendix.

### Getting a lay of the land

This artifact is divided into two projects: Cobb which is the program
synthesizer and Cobb_PBT which evaluates the produced generators.

Cobb contains:
`underapproximation_type`

## Build/Install

### Docker

We provide a docker image with the sufficient dependencies install which can be
constructed from the included dockerfile with a docker installation.

(Change the platform flag to one appropriate for your setup).

```sh
docker build --platform linux/arm64 -t cobb_artifact .
docker run --pull never --platform linux/arm64 -it cobb_artifact
```

### Locally Installing Dependencies

The set of dependencies Cobb expects are an installation of `ocaml`, it's
package manager `dune`, an installation of `z3`(which must be available on your
path as it is called via a shell process), and an installation of `ghc` with
its package manager `cabal`.

```sh
ocaml --version
The OCaml toplevel, version 4.14.2

dune --version
3.17.2

ghc --version
The Glorious Glasgow Haskell Compilation System, version 9.6.6
```

For running the data processing scripts, we assume a `python3` installation with
the `tabulate` package.

FOR RUNNING THIS FROM GITHUB:
- clone with the `--recursive flag`
- or use `git submodule update --init --recursive` after cloning

### Building

Set up a switch and install the specified dependencies in the opam file. This
should be sufficient to build the project.

```sh
cd Cobb && opam switch create ./ --deps-only
eval $(opam env)
dune build
```

Verify Cobb by running the simplest synthesis benchmark:

```sh
cd underapproximation_type/ && dune exec Cobb -- synthesis data/validation/sizedlist/prog1.ml
```

We can now reuse the same switch for Cobb_PBT by just adding 2 dependencies

```sh
cd Cobb_PBT
opam install qcheck fileutils
dune build
```

## Running

The results in Table 1 can be reproduced by running Cobb on each of the
benchmark files in `data/validation/*`. We provide a helpful script for this as
`python scripts/synth.py underapproximation_type/data/validation/sizedlist/`
(TODO: currently doesn't work because it's multithreading is clashing with the
solver file) or each file can be run manually for easy inspection.

Once all of the data has been collected(or just using the results files
currently included), just run `make results` and view the produced latex table.


Figure 11

Figure 12

Figure 13

Figure 14
