FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgomp1 \
    build-essential \
    cmake \
    git \
    pax-utils \
    && rm -rf /var/lib/apt/lists/*

ENV YOLO_CONFIG_DIR=/tmp/Ultralytics

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && execstack -c /usr/local/lib/python3.11/site-packages/onnxruntime/capi/*.so

COPY . .

RUN mkdir -p uploads

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
