# Build stage: install dependencies and mock tools
FROM golang:1.15 AS builder
# Install make
RUN apt-get update && \
    apt-get install -y make slurm-client

# Minimal Slurm configuration to allow `sinfo` to run
RUN mkdir -p /etc/slurm-llnl && \
    echo -e "SlurmdPort=7003\nSlurmctldPort=7002\nAuthType=auth/none\nControlMachine=localhost\nMpiDefault=none\nProctrackType=proctrack/pgid\nReturnToService=2\nSlurmdLogFile=/var/log/slurmd.log\nSlurmdSpoolDir=/var/spool/slurmd\nStateSaveLocation=/var/spool/slurmctld\nSwitchType=switch/none\nTaskPlugin=task/none" \
    > /etc/slurm-llnl/slurm.conf
    
# Create mock sinfo, squeue, and sdiag scripts (only in the build stage)
RUN printf '#!/bin/sh\n\necho "100/200/50/350"\n' > /usr/local/bin/sinfo && \
    chmod +x /usr/local/bin/sinfo && \
    printf '#!/bin/sh\n\necho "running:10 pending:5"\n' > /usr/local/bin/squeue && \
    chmod +x /usr/local/bin/squeue && \
    printf '#!/bin/sh\n\necho "mocked scheduler diagnostic data"\n' > /usr/local/bin/sdiag && \
    chmod +x /usr/local/bin/sdiag

# Set up environment variables for Go
ENV GO111MODULE=on

# Set the working directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY . .

# Build the application binary using the Makefile
RUN make

# Final stage
FROM debian:stable-slim

# Set up environment variables
ENV SLURM_EXPORTER_PORT=8080

# Copy the binary from the builder stage
COPY --from=builder /app/bin/prometheus-slurm-exporter /prometheus-slurm-exporter

# Expose the default port
EXPOSE 8080

# Command to run the exporter
ENTRYPOINT ["/prometheus-slurm-exporter"]
CMD ["--listen-address=0.0.0.0:8080"]