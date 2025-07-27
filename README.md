
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
```

## 🐳 Comandi per creare archivio GIT

```
git init
git remote add origin https://<secret>>@github.com/nfasoli/lab5.git
git add .
git commit -m "Primo commit"
git branch -M main
git push origin main
```

## Comandi per la build  di test in locale
```
docker build -t ipcheck:v1.0 .
docker run --rm ipcheck:v1.0
```
## Comando per collegare il repository di test da github a acr
```
az acr task create --name lab5-task --registry conregistry12710 --image lab5:{{.Run.ID}} --context https://github.com/nfasoli/lab5.git#main  --file Dockerfile --git-access-token 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 --base-image-trigger-type Runtime --resource-group Lab05 --output table
```

## Automazione con GitHub Actions
Puoi usare un GitHub Actions workflow che:

Si attiva al termine del task ACR (tramite webhook o manual trigger)
Elimina l’ACI esistente
La ricrea con l’ultima immagine
🧩 Step 1: Creare un Service Principal per autenticarsi su Azure

Salva:

appId → client ID
password → client secret
tenant
🧩 Step 2: Aggiungi i segreti nel repo GitHub
Vai su Settings > Secrets and variables > Actions e aggiungi:

```
Nome	Valore
AZURE_CLIENT_ID	appId
AZURE_CLIENT_SECRET	password
AZURE_TENANT_ID	tenant
AZURE_SUBSCRIPTION_ID	il tuo subscription ID
ACI_NAME	es. lab5-aci
ACI_RG	Lab05
ACI_IMAGE	conregistry12710.azurecr.io/lab5:latest
```

🧩 Step 3: Crea il workflow update-aci.yml

## Da implementare: webhook per riavviare 

🧩 Step 1: Crea il webhook create-acr-webhook.sh

