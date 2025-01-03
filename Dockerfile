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
RUN apt-get install -y -qq npm
RUN npm install n -g
RUN n lts
RUN npm install npm@latest -g
RUN npm install pnpm -g

# Setup rust cross-compilation
RUN rustup target add x86_64-pc-windows-msvc
RUN rustup target add aarch64-pc-windows-msvc
RUN cargo install xwin
RUN xwin --accept-license --arch x86_64,aarch64 splat --output /.xwin || true
RUN mkdir /.cargo
ADD docker/Cargo.toml /.cargo/Cargo.toml

# Install Make tool
RUN cargo install cargo-make

# Install dotnet and wix
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y dotnet-sdk-9.0
RUN dotnet tool install --global wix

ENV PATH="${PATH}:/root/.dotnet/tools"