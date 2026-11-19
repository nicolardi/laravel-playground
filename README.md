# Laravel Playground

Template minimale con Laravel 13, PHP 8.4, Composer 2 e SQLite in un solo container. Il server di sviluppo Laravel ascolta sulla porta 8181. È destinato a esperimenti locali, non alla produzione.

## Prerequisiti

- Codespaces: un account GitHub con Codespaces disponibile.
- Server Linux: Docker con il plugin Docker Compose, Git e VS Code con Remote SSH. Sul computer locale basta VS Code con Remote SSH. PHP, Composer e SQLite sono nel container.
- Per usare `make`, serve anche Make. In alternativa si possono eseguire direttamente i comandi `docker compose`.

## GitHub Codespaces

Apri il repository su GitHub e scegli **Code → Codespaces → Create codespace**. Il Dev Container costruisce l'immagine, apre `src/`, installa le dipendenze se mancano, crea `.env` e il database al primo avvio e inoltra privatamente la porta 8181. Apri la scheda **Ports** e usa il link della porta 8181. Puoi aprire il Codespace anche da VS Code sul Mac.

Nel terminale del Dev Container sei già in `src/`: usa `php artisan ...` e `composer ...` direttamente.

## Server Linux con VS Code Remote SSH

Clona il repository sul server, collegati con Remote SSH e apri la cartella `laravel-playground`. Dal terminale remoto:

```sh
make up
```

Il Makefile passa UID e GID dell'utente Linux a Compose: i file creati nel bind mount restano modificabili da VS Code. Senza Make:

```sh
HOST_UID=$(id -u) HOST_GID=$(id -g) docker compose up -d --build
```

Compose pubblica la porta solo su `127.0.0.1:8181` del server. Usa la scheda **Ports** di VS Code Remote SSH per inoltrare la porta 8181 verso il computer locale; poi apri `http://localhost:8181`. Se sei già sul server, usa lo stesso indirizzo. Non aprire la porta sul firewall pubblico.

## Comandi

| Comando | Effetto |
| --- | --- |
| `make up` | Costruisce e avvia il container |
| `make down` | Arresta il container senza cancellare il database |
| `make shell` | Apre una shell nel container |
| `make artisan` | Mostra la sintassi per Artisan |
| `make migrate` | Applica nuove migration |
| `make fresh` | Ricrea tutte le tabelle: **cancella i dati** |
| `make test` | Esegue i test Laravel |
| `make logs` | Segue i log |

Esempi: `docker compose exec app php artisan route:list` e `docker compose exec app composer require nome/pacchetto`. Le dipendenze sono in `src/vendor/`, non versionato. Dopo modifiche a `composer.json`, versiona anche `src/composer.lock`.

SQLite usa `src/database/database.sqlite`, un file locale persistente ed escluso da Git. Il primo avvio crea il file ed esegue le migration iniziali; i riavvii conservano database, `APP_KEY` e dipendenze. Per applicare migration aggiunte dopo il primo avvio usa `make migrate`. Per ripartire da tabelle vuote usa esplicitamente `make fresh`. `make down` e `make up` fermano e riavviano l'ambiente senza rimuovere il database.

## Usare il template

Su GitHub, dopo aver pubblicato il repository, abilita **Settings → General → Template repository**. Per un nuovo esperimento scegli **Use this template → Create a new repository**. Ogni repository creato ha il proprio `.env` e database SQLite locale; scegli una cartella distinta per ciascun esperimento. Se esegui più esperimenti sullo stesso server, modifica la porta host in `compose.yaml` per evitare conflitti. Non copiare `.env` o il database tra esperimenti salvo che tu voglia condividere deliberatamente i dati.
