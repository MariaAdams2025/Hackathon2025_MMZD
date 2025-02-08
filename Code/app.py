from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

ROXIE_URL = "http://<roxie-server>:8002/WsEcl/submit/query"

@app.route('/search', methods=['GET'])
def search_music():
    search_term = request.args.get('q')
    if not search_term:
        return jsonify({"error": "Missing query parameter"}), 400

    # Call HPCC Roxie API
    response = requests.get(f"{ROXIE_URL}?query=SearchMusic&searchTerm={search_term}")

    return response.json()

if __name__ == '__main__':
    app.run(debug=True, port=5000)
