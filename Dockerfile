FROM node AS build

WORKDIR /app 

# copy package.json and package-lock.json
COPY *.json . 

RUN npm ci 

COPY . .
RUN npm run build

FROM build AS staging

# docker build -t react-vite .
# docker run -d --rm -p 5173:5173 react-vite
ENTRYPOINT ["npm", "run", "dev"]

FROM nginx:stable-alpine

# prepare bundled frontend
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# docker build -t react-nginx .
# docker run -d --rm -p 8080:8080 react-nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
