FROM node:18.20.4-alpine3.20

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
    libssl1.1 \
    giflib-dev \
    librsvg-dev \
    cairo \
    pango

# Install npm dependencies
RUN npm install

# Link the resolver library
RUN ln -s /lib/libresolv.so.2 /usr/lib/libresolv.so.2

# Expose the application port
EXPOSE 7860

# Start the application
CMD ["node", "beta.js"]