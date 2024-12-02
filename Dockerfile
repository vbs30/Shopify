# Use an official lightweight Python image
FROM python:3.9-slim

# Set environment variables to avoid buffer issues and bytecode generation
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/vbs30/Shopify.git .

# Set up a virtual environment and activate it
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip

# Install project dependencies if `requirements.txt` exists
RUN if [ -f "requirements.txt" ]; then \
    pip install -r requirements.txt; \
    fi

# Apply database migrations
RUN python3 manage.py migrate

# Expose the application's port
EXPOSE 8000

# Define the default command to run the Django app
CMD ["sh", "-c", ". venv/bin/activate && python3 manage.py runserver 0.0.0.0:8000"]
