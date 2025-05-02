#!/bin/bash

echo "Starting backend server"
cd backend
npm run dev &
BACKEND_PID=$!
cd ..

echo "Launching Flutter app in Chrome"
cd flutterfrontend
flutter run -d chrome

echo "Stopping backend"
kill $BACKEND_PID
