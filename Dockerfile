#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["09game/09game.csproj", "09game/"]
RUN dotnet restore "09game/09game.csproj"
COPY . .
WORKDIR "/src/09game"
RUN dotnet build "09game.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "09game.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "09game.dll"]