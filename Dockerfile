# syntax=docker/dockerfile:1
# Usar a imagem oficial do SDK do .NET 8.0
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Definir o diretório de trabalho no container
WORKDIR /app

# Copiar o arquivo .csproj e restaurar as dependências
COPY *.csproj ./
RUN dotnet restore

# Copiar o restante dos arquivos do projeto
COPY . ./

# Publicar a aplicação
RUN dotnet publish -c Release -o out

# Usar a imagem de runtime do .NET 8.0 para a fase final
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Definir o diretório de trabalho no container final
WORKDIR /app

# Copiar os arquivos publicados da fase de build
COPY --from=build-env /app/out .

# Expor a porta 80 para o tráfego HTTP
EXPOSE 80

# Comando para rodar a aplicação
ENTRYPOINT ["dotnet", "CareMiNet.dll"]