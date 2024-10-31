# Use Node.js base image
FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Copy app source code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Run the app
CMD ["npm", "start"]