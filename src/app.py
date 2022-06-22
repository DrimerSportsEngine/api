from flask import Flask

app = Flask(__name__)


@app.route('/<param>/')
def hello(param: str):
    print(f'Responding to {param}')
    return f'Hello: {param}'
