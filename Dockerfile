FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy the application files to the container
ADD . /app

# Install necessary packages
RUN apk add --no-cache \
    font-noto \
    font-noto-cjk \
    font-noto-extra \
    gcompat \
    libstdc++ \
    libuuid \
    vips-dev \
    build-base \
    jpeg-dev \
    pango-dev \
    cairo-dev \
    imagemagick \
    libssl3 \
    giflib-dev \
    librsvg-dev \
    cairo \
    pango \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont

# Set environment variable for Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install npm dependencies
RUN npm install
RUN npm install


# Link the resolver library
RUN ln -s /lib/libresolv.so.2 /usr/lib/libresolv.so.2

# Expose the application port
EXPOSE 7860

# Start the application
CMD ["node", "beta.js"]