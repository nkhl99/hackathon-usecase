FROM node:18-alpine

WORKDIR /app

# Copy dependency files first (layer caching best practice)
COPY package.json ./

RUN npm install --only=production

# Copy app source
COPY src ./src

EXPOSE 3001

CMD ["npm", "start"]
