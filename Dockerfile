# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy solution and csproj
COPY backend.sln .
COPY VaultPay.API/VaultPay.API.csproj VaultPay.API/

# Restore dependencies
RUN dotnet restore backend.sln

# Copy source
COPY VaultPay.API/ VaultPay.API/

# Publish
WORKDIR /app/VaultPay.API
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE 8080

ENTRYPOINT ["dotnet", "VaultPay.API.dll"]
