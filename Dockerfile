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

RUN chmod +x ./Tests/*.test.sh ./Submodules/shelltest/Tools/*.sh

ENV SHELLTEST_LIB=/shell-time-format/Submodules/shelltest/Source/ShellTest.sh

CMD ["./Submodules/shelltest/Tools/RunTests.sh", "Tests"]
