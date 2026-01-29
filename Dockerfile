# Use SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the csproj first (for caching)
COPY VaultPay.API/VaultPay.API.csproj VaultPay.API/

# Restore dependencies
RUN dotnet restore VaultPay.API/VaultPay.API.csproj

# Copy the rest of the source code
COPY VaultPay.API/ VaultPay.API/

# Publish the project
WORKDIR /src/VaultPay.API
RUN dotnet publish -c Release -o /app/publish

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "VaultPay.API.dll"]
