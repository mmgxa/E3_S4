FROM python:3.8-slim-buster

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt && pip install -e .

VOLUME /app/outputs

CMD dlearn_train