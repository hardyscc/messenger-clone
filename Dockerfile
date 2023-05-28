# Use an official Node.js runtime as a base image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Arguments for build
ARG NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME
ARG NEXT_PUBLIC_PUSHER_APP_KEY

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./
COPY prisma/schema.prisma ./prisma/

# Install the dependencies
RUN npm ci

# Copy the rest of the application files to the container
COPY . .

# Build the Next.js app for production
RUN npm run build

# Expose the port that the app will be served on
EXPOSE 3000

# Set the environment variables
ENV NODE_ENV=production

# Start the app
CMD npm start