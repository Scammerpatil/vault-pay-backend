FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY backend.sln .
COPY VaultPay.API/VaultPay.API.csproj VaultPay.API/
RUN dotnet restore backend.sln

COPY VaultPay.API/ VaultPay.API/
WORKDIR /app/VaultPay.API
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "VaultPay.API.dll"]
