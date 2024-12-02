# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django app code into the container
COPY . /app/

# Expose the port the app runs on
EXPOSE 8000

# Run migrations and start the server
CMD python /app/manage.py runserver 0.0.0.0:8000
