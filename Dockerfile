# Base Image
FROM nginx:alpine
# Add user and Group non-root user
RUN addgroup -S netflixgroup && adduser -S netflixuser -G netflixgroup
# Remove exixting nginx config
RUN rm /etc/nginx/conf.d/default.conf
# copy your config 
COPY nginx.conf /etc/nginx/nginx.conf
# Copy website files
COPY . /usr/share/nginx/html
# Give permission to non-root user
RUN chown -R netflixuser:netflixgroup /usr/share/nginx/html \
    && chown -R netflixuser:netflixgroup /var/cache/nginx \
    && chown -R netflixuser:netflixgroup /var/run \
    && chown -R netflixuser:netflixgroup /etc/nginx
# Switch to non-root user
USER netflixuser

# Expose non-privileged port
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --spider http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
