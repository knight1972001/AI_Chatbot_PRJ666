from flask import Flask, render_template, request, jsonify

from chat import get_response

app = Flask(__name__)

@app.get("/")
def index_get():
    return jsonify({"answer": "Hi, How can I help you today?"})

@app.post("/predict")
def predict():
    text = request.get_json().get("message")
    #check text valid
    response = get_response(text)
    message = {"answer": response}
    return jsonify(message)

if __name__ == "__main__":
    app.run(debug=True)




