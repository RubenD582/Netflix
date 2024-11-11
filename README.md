# A Netflix clone

A Netflix clone made with Flutter and Python using TMDB(The Moive Database) to display all the latest and most popular movies.

## Step 1: Create a TMDB API Key

1. Go to https://www.themoviedb.org and log in or sign up.
2. Create a new API key by navigating to your profile settings and selecting API.
3. Follow the steps to request an API key. Copy the key provided, as you'll need it in the next step.

## Step 2: Set Up the .env File

1. Navigate to the api directory `cd api`
2. Create a `.env` file by copying the .env.example file `cp .env.example .env`
3. Open the `.env` file and paste your TMDB API key here `API_KEY="your_tmdb_api_key_here"`


## Step 3: Run the Project

Run the python server (In the root directory)

1. `cd api`
2. `python main.py`

Run the flutter app (In the root directory)

1. `cd app`
2. `flutter run`
