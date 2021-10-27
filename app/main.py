import os

from flask import Flask
from http import HTTPStatus

app = Flask(__name__)


@app.route('/')
def index():
    return 'Hello, World!', HTTPStatus.OK


if __name__ == '__main__':
    app.run(
        debug=False,
        host='0.0.0.0',
        port=int(os.environ.get('PORT', 8080))
    )

