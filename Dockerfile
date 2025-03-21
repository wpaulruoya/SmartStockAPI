# Use official .NET SDK image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5168
EXPOSE 7122

# Use SDK image to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["SmartStockAPI.csproj", "./"]
RUN dotnet restore "SmartStockAPI.csproj"

# Copy the entire project and build the application
COPY . .
WORKDIR "/src"
RUN dotnet publish -c Release -o /app/publish

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SmartStockAPI.dll", "--urls", "http://+:5168"]
