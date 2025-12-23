FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Install native AOT prerequisites (clang/llvm)
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN dotnet publish rt4k_pi.csproj -c Release -r linux-arm64 -o /out

FROM scratch AS export
COPY --from=build /out /
