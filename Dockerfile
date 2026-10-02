# This Dockerfile will help configure the app before we push it

# Base image to place app within

FROM node:20

# Label

LABEL description="Container used to run Sparta's test TTTApp."

# Set default working directory of the container to /usr/src/app 

WORKDIR /usr/src/app

# Copy local app folder into app folder in container 

# COPY <local path> <container path>
COPY app /usr/src/app

# Install dependencies with npm 

RUN npm install

# Expose port 

EXPOSE 3000

# When this container is started, run this command by default

CMD ["npm", "start"]
# CMD ["<command to run>", "<parameters>"]