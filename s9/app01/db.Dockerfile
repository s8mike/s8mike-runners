FROM postgres:15

RUN useradd -m appuser
USER appuser