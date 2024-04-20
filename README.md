# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

### `npm test`

Launches the test runner in the interactive watch mode.\

### `npm run build`

Builds the app for production to the `build` folder.\

### `docker compose up --build -d` and `docker run -d -p 80:80 boilerplate-boilerplate`

Builds the app using docker.\
After the application start, navigate to http://localhost in your browser:

### `docker ps`

Listing containers, must show containers running and the port mapping

### `docker compose down`

Stop and remove docker image

### `docker-compose down --remove-orphans`

Remove orphans if any containers was killed before

### `docker images` and `docker rmi <image_id1> <image_id2>`

To remove unused old images
