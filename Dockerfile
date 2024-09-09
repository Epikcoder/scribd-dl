# Use a Debian-based Node.js image
FROM node:20-buster

# Set the working directory
WORKDIR /app

# Copy the application files to the container
COPY . /app

# Install prerequisites and helper packages
RUN apt-get update && apt-get install -y \
    bash \
    dpkg \
    x11-apps \
    libnss3 \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-extra \
    libstdc++6 \
    libuuid1 \
    libvips-dev \
    build-essential \
    libjpeg-dev \
    libpango1.0-dev \
    libcairo2-dev \
    imagemagick \
    libssl1.1 \
    giflib-tools \
    librsvg2-dev \
    chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js dependencies
RUN npm install

# Expose the application port
EXPOSE 7860

# Start the application
CMD ["node", "beta.js"]
