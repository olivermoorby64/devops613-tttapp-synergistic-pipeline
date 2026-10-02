# This Dockerfile will help configure the app before we push it

# Base image to place app within

FROM node:20

# Label
LABEL description="Container used to run Sparta's test TTTApp in a synergistic pipeline."

# Set default working directory of the container to /usr/src/app 
WORKDIR /usr/src/app
RUN rm -rf /var/lib/apt/lists/*

# Copy local app folder into app folder in container 
# COPY <local path> <container path>
COPY app /usr/src/app
COPY entrypoint.sh /usr/src/app/

# Install dependencies
RUN npm install

# Expose application port
EXPOSE 3000

# Make script executable
RUN chmod +x /usr/src/app/entrypoint.sh

# Execute startup script when container starts
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]