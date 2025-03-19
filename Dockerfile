# Use official .NET SDK image for building the API
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Use SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["SmartStockAPI/SmartStockAPI.csproj", "SmartStockAPI/"]
RUN dotnet restore "SmartStockAPI/SmartStockAPI.csproj"

COPY . .
WORKDIR "/src/SmartStockAPI"
RUN dotnet publish -c Release -o /app/publish

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SmartStockAPI.dll"]
