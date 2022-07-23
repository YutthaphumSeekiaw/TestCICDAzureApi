#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
RUN mkdir /tmp/TemplateMachine
COPY ./PPP_Planning_Service/TemplateMachine/* /tmp/TemplateMachine/
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["PPP_Planning_Service/PPP_Planning_Service.csproj", "PPP_Planning_Service/"]
RUN dotnet restore "PPP_Planning_Service/PPP_Planning_Service.csproj"
COPY . .
WORKDIR "/src/PPP_Planning_Service"
RUN dotnet build "PPP_Planning_Service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PPP_Planning_Service.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PPP_Planning_Service.dll"]