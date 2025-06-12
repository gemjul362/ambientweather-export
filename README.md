
# 🌦️ AmbientWeather Export System

Este proyecto permite **extraer datos históricos y actuales** desde una estación climática de [AmbientWeather.net](https://ambientweather.net/), almacenarlos en una base de datos PostgreSQL y visualizarlos en Grafana.

Incluye:
- Extracción automática desde la API
- Carga inicial desde CSV (histórico completo)
- Backend en Python
- Docker para contenerización
- Dashboard en Grafana
- Preparado para despliegue en Render/Fly.io (100% gratuito)

---

## 🚀 Funcionalidades

- Consulta datos cada hora desde la API de AmbientWeather
- Inserta automáticamente nuevos registros sin duplicados
- Soporte para histórico desde CSV
- Compatible con Solar Radiation y UV Index si están disponibles
- Visualización lista en Grafana

---

## 📁 Estructura del Proyecto

```
ambientweather-export/
├── .env.example            # Variables de entorno
├── docker-compose.yml      # Orquestación de servicios
├── Dockerfile              # Contenedor de ETL
├── main.py                 # Script que consulta la API
├── insert_csv.py           # Script para cargar datos históricos
├── requirements.txt        # Librerías Python necesarias
├── README.md               # Este archivo
└── data/
    └── ambient-weather-20240726-20250611.csv
```

---

## 🔧 Variables de entorno

Copia `.env.example` y nómbralo `.env`. Completa tus claves:

```env
API_KEY=tu_api_key_de_usuario
APP_KEY=tu_app_key
MAC_ADDRESS=MAC_de_tu_estación
POSTGRES_PASSWORD=tu_contraseña_postgres
```

---

## 🐳 Instalación local con Docker

```bash
# 1. Clona el repositorio
git clone https://github.com/tuusuario/ambientweather-export.git
cd ambientweather-export

# 2. Configura tu .env
cp .env.example .env
# Edita .env con tus claves

# 3. Construye e inicia los servicios
docker compose up --build -d

# 4. Inserta el histórico CSV (opcional)
docker exec -it weather_etl python insert_csv.py
```

---

## 📊 Acceder a Grafana

- URL: [http://localhost:3000](http://localhost:3000)
- Usuario: `admin`
- Contraseña: `admin`

> Añade una **fuente de datos PostgreSQL** con:
- Host: `weather_db`
- Base de datos: `weather`
- Usuario: `postgres`
- Contraseña: lo que tengas en `.env`

Luego crea paneles con consultas como:

```sql
SELECT date, outdoor_temperature_c
FROM weather_data
WHERE $__timeFilter(date)
ORDER BY date
```

---

## ☁️ Despliegue en Render.com (100% gratuito)

1. Crea una cuenta en [https://render.com](https://render.com)
2. Crea un nuevo **Background Worker**
3. Conecta este repositorio
4. Configura las siguientes variables de entorno:

```
API_KEY
APP_KEY
MAC_ADDRESS
POSTGRES_PASSWORD
```

5. Comando a ejecutar:

```bash
python main.py
```

---

## 🧪 Scripts disponibles

- `main.py`: ejecuta la consulta a la API y guarda en PostgreSQL
- `insert_csv.py`: carga un CSV con histórico
- `Dockerfile`: imagen para ejecutar ambos scripts
- `docker-compose.yml`: orquesta PostgreSQL, ETL y Grafana

---

## 🗃️ Estructura de la base de datos

La tabla principal es `weather_data`, con estos campos clave:

| Columna                    | Tipo                | Descripción                     |
|---------------------------|---------------------|----------------------------------|
| `date`                    | timestamp           | Fecha con hora (clave primaria) |
| `outdoor_temperature_c`   | real                | Temperatura exterior (°C)       |
| `uv_index`                | real                | Índice UV                       |
| `solar_radiation_wm2`     | real                | Radiación solar (W/m²)          |
| ...                       | ...                 | Otros campos del CSV/API        |

---

## 📅 Cron recomendado

Para que se ejecute cada hora, usa el cron de Render.com o configura `cron` en Linux así:

```cron
0 * * * * docker exec -t weather_etl python main.py
```

---

## ✅ Créditos y agradecimientos

- AmbientWeather API: [https://ambientweather.docs.apiary.io](https://ambientweather.docs.apiary.io)
- Basado en la librería `ambient_api` de [@avryhof](https://github.com/avryhof/ambient_api)
- Dashboard y visualización: Grafana

---

## 🛠️ Licencia

MIT — libre para usar, modificar y compartir.
