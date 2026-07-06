import os
from flask import Flask
from redis import Redis

app = Flask(__name__)

redis_host = os.environ.get("REDIS_HOST", "redis")
app_name = os.environ.get("APP_NAME", "Compose Redis App")

redis_client = Redis(host=redis_host, port=6379, decode_responses=True)

@app.route("/")
def home():
    count = redis_client.incr("visit_count")
    return f"{app_name}! Visit count: {count}\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
