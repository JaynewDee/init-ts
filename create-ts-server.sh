#!/bin/bash

set -e # Shell will exit if any command returns non-zero status

if [ -z "$1" ]; then
   echo "You must pass your project's name as the first argument."
   exit
fi

project_name=$1

mkdir $project_name
cd $project_name

# Init node and install dependencies
npm i express
npm i -D typescript @types/node @types/express concurrently

# Write server boilerplate to server.ts
cat << EOF > server.ts
import express, { Express, Request, Response } from 'express';

const app: Express = express();
const PORT: number = 3001;

app.get('/', (req: Request, res: Response) => {
    res.send('Typescript-Express server initialized');
});

app.listen(PORT, () => {
    console.log('Server listening @ 3001');
});
EOF

# Write basic tsconfig with ./dist outDir
cat << EOF > tsconfig.json
{
  "compilerOptions": {
    "target": "es2016",
    "module": "commonjs",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true,
    "outDir": "./dist"
  }
}
EOF

# Compile typescript and start server
npx tsc
nodemon dist/server.js

echo "Successfully initialized Typescript-Express server"

exit
