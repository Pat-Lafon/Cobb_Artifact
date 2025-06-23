FROM poirot23/poirot:pldi-2023

USER opam

# We are checking out specific commits, ignore the detachedHead warning
RUN git config --global advice.detachedHead false

# Pull in my code projects
RUN git clone https://github.com/Pat-Lafon/Cobb.git && cd Cobb && git checkout c168849875f915ce0d474c03581f0ff9b22f198d && git submodule update --init --recursive

RUN git clone https://github.com/Pat-Lafon/Cobb_PBT.git && cd Cobb_PBT && git checkout 8349c2938d68c925c2c630ff2cba145a65fe5ea6

RUN opam install fileutils --yes

RUN opam install pomap --yes

RUN opam install async --yes