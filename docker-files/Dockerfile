# Use Node.js LTS image as base
FROM node:lts

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the application source code
COPY . .

# Expose the required port
EXPOSE 80

# Start the application
CMD ["npm", "start"]
