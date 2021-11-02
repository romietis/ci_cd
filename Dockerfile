# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.8-alpine

# Allow statements and log messages to immediately appear in the Knative logs.
ENV PYTHONUNBUFFERED True

# Set up python venv.
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Update pip.
RUN python -m pip install --upgrade pip

# Install production dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Run the web service on container startup.
# CMD exec gunicorn --bind :8080 --workers 1 --threads 8 --timeout 0 app.main:app
ENTRYPOINT ["gunicorn", "--workers", "1", "--threads", "8", "-b", ":8080", "app.main:app"]
