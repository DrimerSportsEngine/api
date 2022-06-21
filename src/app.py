from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'


app.wsgi_app = ProxyFix(app.wsgi_app)
