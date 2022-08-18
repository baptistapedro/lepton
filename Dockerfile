FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev pkg-config openssl libssl-dev curl libcurl4-openssl-dev
RUN git clone https://github.com/dropbox/lepton.git
WORKDIR /lepton
RUN ./autogen.sh
RUN CC=afl-clang CXX=afl-clang++ ./configure
RUN make
RUN mkdir /leptonCorpus
RUN wget https://download.samplelib.com/jpeg/sample-clouds-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-red-400x300.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-200x200.jpg
RUN wget https://download.samplelib.com/jpeg/sample-green-100x75.jpg
RUN mv *.jpg /leptonCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/leptonCorpus", "-o", "/leptonOut"]
CMD ["/lepton/lepton", "@@", "out.lep"]
