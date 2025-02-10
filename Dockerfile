# Usa una imagen base de Python (puedes elegir la versión que prefieras)
FROM python:3.9-slim

# Instala dependencias del sistema necesarias para Chrome y Selenium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    && rm -rf /var/lib/apt/lists/*

# Agrega la clave de Google y el repositorio de Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable && rm -rf /var/lib/apt/lists/*

# Establece el display para que Chrome corra en modo headless
ENV DISPLAY=:99

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo de requerimientos e instálalos
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto de la aplicación
COPY . /app/

# Comando para ejecutar tu script de scraping
CMD ["python", "scrape_promodescuentos.py"]
