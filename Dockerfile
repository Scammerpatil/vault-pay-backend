# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.sln .
COPY VaultPay.API/*.csproj ./VaultPay.API/
RUN dotnet restore

# Copy all source files
COPY VaultPay.API/. ./VaultPay.API/

# Publish the app
WORKDIR /app/VaultPay.API
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

# Tell ASP.NET to listen on the port Render provides
ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE $PORT

# Entry point
ENTRYPOINT ["dotnet", "VaultPay.API.dll"]
