# Use the latest Node.js 20.x version on Alpine
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy the application files to the container
COPY . /app

# Set locale environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install glibc for compatibility with applications requiring it
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.34-r0
RUN set -ex && \
    apk --no-cache add libstdc++ curl ca-certificates && \
    curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -o /tmp/glibc.apk && \
    curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -o /tmp/glibc-bin.apk && \
    apk add --no-cache --allow-untrusted /tmp/glibc.apk /tmp/glibc-bin.apk && \
    rm -rf /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# Install prerequisites and helper packages
RUN apk add --no-cache \
    bash \
    dpkg \
    xeyes

# Install Chrome dependencies and download Chrome
RUN apk add --no-cache \
    alsa-lib \
    atk \
    at-spi2-atk \
    expat \
    glib \
    gtk+3.0 \
    libdrm \
    libx11 \
    libxcomposite \
    libxcursor \
    libxdamage \
    libxext \
    libxi \
    libxrandr \
    libxscrnsaver \
    libxshmfence \
    libxtst \
    mesa-gbm \
    nss \
    pango && \
    curl -SL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /google-chrome-stable_current_amd64.deb && \
    dpkg -x /google-chrome-stable_current_amd64.deb google-chrome-stable && \
    mv /google-chrome-stable/usr/bin/* /usr/bin && \
    mv /google-chrome-stable/usr/share/* /usr/share && \
    mv /google-chrome-stable/etc/* /etc && \
    mv /google-chrome-stable/opt/* /opt && \
    rm -r /google-chrome-stable

# Install additional packages
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
    freetype \
    harfbuzz \
    ttf-freefont

# Set the Puppeteer executable path environment variable (if needed)
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Node.js dependencies
RUN npm install

# Link the resolver library (if needed)
RUN ln -s /lib/libresolv.so.2 /usr/lib/libresolv.so.2

# Expose the application port
EXPOSE 7860

# Start the application
CMD ["node", "beta.js"]
