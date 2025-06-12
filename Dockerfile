FROM python:3.10-slim

WORKDIR /app
COPY . /app

# Instalar dependencias del sistema necesarias para compilar algunas librerías
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    libffi-dev \
    cron \
    bash \
 && apt-get clean

# Instalar librerías Python
RUN pip install --no-cache-dir -r requirements.txt

# Configurar cron
COPY crontab.txt /etc/cron.d/weather-cron
RUN chmod 0644 /etc/cron.d/weather-cron
RUN crontab /etc/cron.d/weather-cron

# Crear log
RUN touch /var/log/cron.log

# Ejecutar cron y mostrar logs
CMD ["bash", "-c", "cron && tail -f /var/log/cron.log"]
