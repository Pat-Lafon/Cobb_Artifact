FROM opam-z3:latest

# We are checking out specific commits, ignore the detachedHead warning
RUN git config --global advice.detachedHead false

# Pull in my code projects
RUN git clone https://github.com/Pat-Lafon/Cobb.git && cd Cobb && git submodule update --init --recursive

RUN git clone https://github.com/Pat-Lafon/Cobb_PBT.git && cd Cobb_PBT && git submodule update --init --recursive

RUN opam install fileutils --yes

RUN opam install pomap --yes

RUN opam install async --yes

RUN opam install ocolor --yes

RUN opam install dolog --yes

RUN opam install yojson --yes

RUN opam install alcotest --yes

RUN opam install ounit2 --yes

RUN eval $(opam env)

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

RUN python3 get-pip.py

RUN pip3 install matplotlib numpy tabulate