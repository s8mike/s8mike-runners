FROM nginx:alpine

# Create a non-root user (Alpine-compatible)
RUN adduser -D -h /home/appuser appuser

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY ./frontend/ .

USER appuser

COPY . .

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
