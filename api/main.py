import requests
import random
import concurrent.futures
from flask import Flask, jsonify, request
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

genre_mapping = {
    28: 'Action', 12: 'Adventure', 16: 'Animation', 35: 'Comedy', 80: 'Crime', 
    99: 'Documentary', 18: 'Drama', 10751: 'Family', 14: 'Fantasy', 36: 'History',
    27: 'Horror', 10402: 'Music', 9648: 'Mystery', 10749: 'Romance', 878: 'Science Fiction', 
    10770: 'TV Movie', 53: 'Thriller', 10752: 'War', 37: 'Western'
}

API_KEY = os.getenv("API_KEY")

def get_shows(url, isRandom=False):
    response = requests.get(url)
    if response.status_code == 200:
        trending_data = response.json()
    else:
        print(f"Failed to retrieve data: {response.status_code}")
        return {}

    if trending_data.get("results"):
        if isRandom:
            show = random.choice(trending_data["results"])
            try:
                return {
                    "id": show['id'],
                    "title": show['title'],
                    "release_date": show['release_date'],
                    "poster_path": f"https://image.tmdb.org/t/p/original{show['poster_path']}",
                    "overview": show['overview'],
                    "genre": [genre_mapping[genre_id] for genre_id in show['genre_ids']],
                    "logo": get_show_logo(show['id'])
                }
            except Exception as e:
                print(f"Error extracting show data: {e}")
                return {}
        else:
            # If random is False, return the first 10 shows
            shows = trending_data["results"][:10]
            show_list = []
            for show in shows:
                try:
                    show_list.append({
                        "id": show['id'],
                        "title": show['title'],
                        "release_date": show['release_date'],
                        "poster_path": f"https://image.tmdb.org/t/p/original{show['poster_path']}",
                        "overview": show['overview'],
                        "genre": [genre_mapping[genre_id] for genre_id in show['genre_ids']],
                        "logo": get_show_logo(show['id'])
                    })
                except Exception as e:
                    print(f"Error extracting show data: {e}")
            return show_list
    else:
        print("No trending shows found.")
        return {}

def get_show_logo(show_id):
    url = f"https://api.themoviedb.org/3/movie/{show_id}/images?api_key={API_KEY}&language=en"
    response = requests.get(url)
    if response.status_code == 200:
        images_data = response.json()
        logos = images_data.get('logos', [])
        if logos:
            logo_path = logos[0].get('file_path')
            if logo_path:
                return f"https://image.tmdb.org/t/p/original{logo_path}"
    return None

def fetch_multiple_shows():
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = {
            "trending": executor.submit(get_shows, f"https://api.themoviedb.org/3/trending/all/day?api_key={API_KEY}&language=en-US", True),
            "now_showing": executor.submit(get_shows, f"https://api.themoviedb.org/3/movie/now_playing?api_key={API_KEY}&language=en-US"),
            "top_rated": executor.submit(get_shows, f"https://api.themoviedb.org/3/movie/top_rated?api_key={API_KEY}&language=en-US"),
            "upcoming": executor.submit(get_shows, f"https://api.themoviedb.org/3/movie/upcoming?api_key={API_KEY}&language=en-US")
        }
        
        results = {key: future.result() for key, future in futures.items()}
    return results

@app.route('/fetch_all', methods=['GET'])
def fetch_all_shows():
    try:
        results = fetch_multiple_shows()
        return jsonify(results)
    except Exception as e:
        return jsonify({"error": f"Failed to fetch shows: {e}"}), 500


@app.route('/trailer_url', methods=['GET'])
def trailer():
    try:
        movie_id = request.args.get('movie_id')
        if not movie_id:
            return jsonify({"error": "movie_id parameter is required"}), 400

        url = f"https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key={API_KEY}&language=en-US"
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()

            if "results" in data and len(data["results"]) > 0:
                for video in data["results"]:
                    if video["type"] == "Trailer" and video["site"] == "YouTube":
                        youtube_trailer_url = f"{video['key']}"
                        return jsonify({"trailer_url": youtube_trailer_url})

            # If no trailer is found
            return jsonify({"error": "No YouTube trailer found for this movie"}), 404

        else:
            return jsonify({"error": "Failed to fetch data from TMDB API"}), 500

    except Exception as e:
        return jsonify({"error": "Error fetching URL", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
