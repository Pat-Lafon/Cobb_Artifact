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
outputted results for RQ's 1-4 (specifically Tables 1, Figure 11, Figure 12,
Figure 13, and Figure 14). We provide our modified version of Poirot (from
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
  additional evaluations/studies/deliverables which will be completed by the July
  29 - Submission of Revisions R2 deadline. The following is the set of changes
  that were proposed and then accepted by reviewers. We do not expect there to
  be any major changes to the algorithm/artifact other than setup to run the following:
  - Conduct an ablation study on the effectiveness of Cobb's best-effort
    strategy when the solution space is incomplete.
  - Run an ablation study on the sensitivity of Cobb to superfluous components.
  - Add a table with the percentage of non-unique terms from the benchmarks to
    the appendix.

### Getting a lay of the land

This artifact is divided into two projects:
  1. `Cobb`: the implementation of our type-guided input repair algorithm. `Cobb`
    uses a modified version of `Poirot`, the coverage-type checker described in
    `Covering All the Bases: Type-Based Verification of Test Input Generators` by Zhou et al.
  2. `Cobb_PBT`: the scripts needed to reproduce the evaluation of Cobb presented
    in the paper.


## Build/Install

### Docker

We provide a docker image with the sufficient dependencies install which can be
constructed from the included dockerfile with a docker installation.

(Change the platform flag to one appropriate for your setup).

```sh
docker load < <(gunzip -c opam-z3.tar.gz) # We supply a base image with opam and z3 4.15.1 installed given the higher ram requirements to compile z3 inside of doc on macs TODO: Store this instead on dockerhub since I can't commit to github
docker build --platform linux/amd64 -t cobb_artifact .
docker run --pull never --platform linux/amd64 -it cobb_artifact
```

### Locally Installing Dependencies

The set of dependencies Cobb expects are an installation of `ocaml`, it's
package manager `dune`, an installation of `z3`(which must be available on your
path as it is called via a shell process), and an installation of `ghc` with
its package manager `cabal`.

```sh
ocaml --version
The OCaml toplevel, version 5.1.0

dune --version
3.17.2

ghc --version
The Glorious Glasgow Haskell Compilation System, version 9.6.6

cabal --version
cabal-install version 3.12.1.0
compiled using version 3.12.1.0 of the Cabal library

z3 --version
Z3 version 4.15.1 - 64 bit
```

For running the data processing scripts, we assume a `python3` installation with
the `tabulate`, `numpy` and `matplotlib` packages. We suggest `uv`, `uv venv && uv pip install numpy tabulate matplotlib && source .venv/bin/activate`

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

We can now reuse the same switch for Cobb_PBT by just adding 2 dependencies:

```sh
cd ../../Cobb_PBT
opam install alcotest fileutils
dune build
```

Note that `dune` may raise the following error when building part of the `qcheck` library.

```
File "qcheck/src/ppx_deriving_qcheck/ppx_deriving_qcheck.ml", line 60, characters 18-59:
60 |   | Pexp_function (fargs, _constraint, Pfunction_body expr) ->
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: This pattern matches values of type 'a * 'b * 'c
       but a pattern was expected which matches values of type
         cases = case list
```
Not to worry, this artifact does not depend on the code that throws this error,
and the build succeeds despite it, so this error message can be safely disregarded.

## Running

### RQ1

The results in Table 1 can be reproduced by running Cobb on each of the
benchmark files in `data/validation/*`. We provide a helpful script for this as
`python3 scripts/synth.py underapproximation_type/data/validation/sizedlist/`
(TODO: currently doesn't work because it's multithreading is clashing with the
solver file) or each file can be run manually for easy inspection.

Once all of the data has been collected(or just using the results files
currently included), just run `make results` and view the produced latex table.

### RQ2/3

The data for Figure 11, Figure 12, and Figure 13 is produced by running the
following commands in the `Cobb_PBT` directory:

```sh
export QCHECK_MSG_INTERVAL=2000.0 && dune exec Cobb_PBT -- eval2
export QCHECK_MSG_INTERVAL=2000.0 && dune exec Cobb_PBT -- eval3
```

This will take a few minutes (potentially longer if running inside of docker).
For some longer running benchmarks, e.g., `unique_list`, it may look like
the script is stuck, but just be patient.

The results are then visualized into the Figures 11, 12, 13 by

```sh
make results
```

and then viewing the graphs located in `Cobb_PBT/graphs/`. The consolidated csv
tables of the results from which the graphs are derived are located in `Cobb_PBT/csv/*`

### RQ4

Figure 14 is generated from running Luck and a simple enumerator for each of the
initial parameter sets.

In `Cobb_PBT`

```sh
python3 scripts/run_luck.py
```

Note the at the latter will take much longer because we expect the default
generators to time out for many of the runs. (The timeout is set to 5 minutes
per variation, which will be hit in 8 variations).

```sh
opam exec -- dune exec enumeration
```

Then to generate Figure 14 in `Cobb_PBT/graphs/table3_graph.png`

```sh
python3 scripts/line_graph.py
```
