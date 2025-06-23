FROM nginx:alpine
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Add version file (for CI/CD tracking)
RUN echo "BUILD_DATE=$(date +'%Y-%m-%d %H:%M:%S')" > /usr/share/nginx/html/version.txt
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
