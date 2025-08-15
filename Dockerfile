# Step 1: Base image (use 3.11 to match scipy requirement)
FROM python:3.11-slim

# Step 2: Set work directory
WORKDIR /app

# Step 3: Install system dependencies (for ML libraries and scipy build)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libgl1 \
    libglib2.0-0 \
    gfortran \
    libatlas-base-dev \
    liblapack-dev \
    libblas-dev \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

# Step 4: Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy project code
COPY . .

# Step 6: Collect static files
RUN python manage.py collectstatic --noinput

# Step 7: Expose port for Render
EXPOSE 8000

# Step 8: Start Django with Gunicorn
CMD ["gunicorn", "lemonquality.wsgi:application", "--bind", "0.0.0.0:8000"]
