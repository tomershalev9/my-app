FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN apt-get update && apt-get install -y mongo-tools
COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
