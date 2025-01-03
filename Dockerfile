FROM rust:bullseye
WORKDIR /root

RUN apt-get update -y -qq && apt-get upgrade -y -qq
RUN apt-get install build-essential -y -qq
RUN apt-get install lsb-release wget software-properties-common gnupg -y -qq

# Install LLVM tools
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 18

# Install Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN nvm install node
RUN nvm use node
RUN npm install pnpm

# Setup rust cross-compilation
RUN rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
RUN rustup target add x86_64-pc-windows-msvc
RUN rustup target add aarch64-pc-windows-msvc
RUN cargo install xwin
RUN xwin --accept-license --arch x86_64,aarch64 splat --out /xwin
RUN mkdir /.cargo

ADD docker/Cargo.toml /.cargo/Cargo.toml
