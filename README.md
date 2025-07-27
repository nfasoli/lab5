
# ipcheck – Progetto C# Dockerizzato

Questo progetto è una applicazione C# containerizzata con Docker, pronta per essere compilata, eseguita localmente e distribuita tramite GitHub e Azure Container Registry.

---

## 📁 Struttura del progetto

- Codice sorgente C# (es. `Program.cs`, `.csproj`)
- `Dockerfile` per la build e l'esecuzione
- `.dockerignore` per escludere file non necessari
- `.gitignore` per evitare di tracciare file temporanei
- `README.md` (questo file)

---

## 🛠️ .gitignore

Abbiamo incluso un file `.gitignore` per escludere:

- Cartelle di build (`bin/`, `obj/`, `out/`)
- File temporanei di Visual Studio
- Configurazioni IDE locali
- File di sistema

---

## 🐳 Dockerfile

Il `Dockerfile` utilizza un approccio multi-stage:

1. **Stage di build**: compila e pubblica l'applicazione
2. **Stage di runtime**: esegue solo l'app pubblicata in un'immagine leggera

```dockerfile
# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app
COPY . ./
RUN dotnet publish --configuration Release --output /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "ipcheck.dll"]

## Azioni per la creazione del repository
```comandi git

git init
git remote add origin https://<secret>@github.com/nfasoli/lab5.git
git add .
git commit -m "Primo commit"
git branch -M main
git push origin main

## Azioni per il test in locale dell'immagine docker
```comandi per il test locale dell''immagine
docker build -t ipcheck:v1.0 .
docker images
docker run --rm ipcheck:v1.0


## Ho poi creato un link fra le github actions e l'acr
az acr task create --name lab5-task --registry conregistry12710 --image lab5:{{.Run.ID}} --context https://github.com/nfasoli/lab5.git#main  --file Dockerfile --git-access-token <secret> --base-image-trigger-type Runtime --resource-group Lab05 --output table 

