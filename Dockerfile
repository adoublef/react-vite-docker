FROM node AS base

WORKDIR /app 

# copy package.json and package-lock.json
COPY *.json . 

RUN npm ci 

COPY . .

# 
FROM base AS staging
# docker build -t react-vite . --target staging
# docker run -d --rm -p 5173:5173 react-vite
ENTRYPOINT ["npm", "run", "dev"]

# build the javascript bundle
FROM base as build
RUN npm run build

# deploy using nginx
FROM nginx:stable-alpine AS final

# prepare bundled frontend
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# docker build -t react-nginx .
# docker run -d --rm -p 8080:8080 react-nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
