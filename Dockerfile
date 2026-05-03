# shell-time-format test environment.

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    findutils \
    grep \
    sed \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /shell-time-format

COPY . .

RUN chmod +x ./tests/*.test.sh ./submodules/shelltest/tools/*.sh

ENV SHELLTEST_LIB=/shell-time-format/submodules/shelltest/src/shelltest.sh

CMD ["./submodules/shelltest/tools/test.sh", "tests"]
