FROM python:3.8-slim-buster as base
RUN pip install poetry
EXPOSE 5000
WORKDIR /code

FROM base as dev
COPY ./pyproject.toml ./
COPY ./todo_app /code/todo_app/
RUN poetry install
ENTRYPOINT poetry run flask run --host=0.0.0.0

FROM base as prod
COPY pyproject.toml .
RUN poetry install
COPY ./todo_app /code/todo_app/
ENV FLASK_ENV=production
ENTRYPOINT poetry run gunicorn "todo_app.app:create_app()" --bind 0.0.0.0:5000

