# Step 1: Base image (Python 3.11 with Debian Trixie slim)
FROM python:3.11-slim

# Step 2: Set working directory
WORKDIR /app

# Step 3: Install system dependencies (for ML libraries & SciPy build)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libgl1 \
    libglib2.0-0 \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libblas-dev \
    python3-dev \
 && rm -rf /var/lib/apt/lists/*

# Step 4: Copy requirements first (cache layer optimization)
COPY requirements.txt .

# Step 5: Upgrade pip & install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy project code
COPY . .

# Step 7: Collect static files
RUN python manage.py collectstatic --noinput

# Step 8: Expose port for Render
EXPOSE 8000

# Step 9: Start Django with Gunicorn
CMD ["gunicorn", "lemonquality.wsgi:application", "--bind", "0.0.0.0:8000"]
