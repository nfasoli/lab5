 # Start using the .NET 8.0 SDK container image
 FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

 # Change current working directory
 WORKDIR /app

 # Copy existing files from host machine
 COPY . ./

 # Publish application to the "out" folder
 RUN dotnet publish --configuration Release --output /app/out

 
# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .


 # Start container by running application DLL
 ENTRYPOINT ["dotnet", "ipcheck.dll"]