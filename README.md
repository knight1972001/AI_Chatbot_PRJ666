# Chatbot Deployment with Flask, Docker and Azure

Demo: [https://aichatbot6.azurewebsites.net/](https://aichatbot6.azurewebsites.net/)

Serve only the Flask prediction API. The used html and javascript files can be included in any Frontend application (with only a slight modification) and can run completely separate from the Flask App then.
 

## About chatbot.
Simple chatbot implementation with PyTorch.

-   The implementation should be easy to follow for beginners and provide a basic understanding of chatbots.
-   The implementation is straightforward with a Feed Forward Neural net with 2 hidden layers.
-   Customization for your own use case is super easy. Just modify  `intents.json`  with possible patterns and responses and re-run the training (see below for more info).

The approach is inspired by this article and ported to PyTorch:  [https://chatbotsmagazine.com/contextual-chat-bots-with-tensorflow-4391749d0077](https://chatbotsmagazine.com/contextual-chat-bots-with-tensorflow-4391749d0077) of [patrickloeber](https://github.com/patrickloeber/pytorch-chatbot).

## Initial Setup:
**Create an environment**
`python3 -m venv venv`

**Activate it**
Mac / Linux:
`. venv/bin/activate`
Windows:
`venv\Scripts\activate`

**Install [PyTorch](https://pytorch.org/)**
Install nltk using `pip`
`pip install nltk`

**Generate `data.pth` file and run**
`python train.py`
We create a list of documents (sentences), each sentence is a list of  _stemmed_  _words_  and each document is associated with an intent (a class).

**27 documents**  
**9 classes** `['goodbye', 'greeting', 'hours', 'mopeds', 'opentoday', 'payments', 'rental', 'thanks', 'today']  `
**44 unique stemmed words** `["'d", 'a', 'ar', 'bye', 'can', 'card', 'cash', 'credit', 'day', 'do', 'doe', 'good', 'goodby', 'hav', 'hello', 'help', 'hi', 'hour', 'how', 'i', 'is', 'kind', 'lat', 'lik', 'mastercard', 'mop', 'of', 'on', 'op', 'rent', 'see', 'tak', 'thank', 'that', 'ther', 'thi', 'to', 'today', 'we', 'what', 'when', 'which', 'work', 'you']`

The stem ‘tak’ will match ‘take’, ‘taking’, ‘takers’, etc. We could clean the words list and remove useless entries but this will suffice for now.

**This will dump  `data.pth`  file. And then run using**
`python chat.py`

**Demo** using anaconda - Windows power shell to interactive with chatbot: 

## Turning to API using Flask!
`app.py` is the api server file.

    from flask import  Flask, render_template, request, jsonify
    from flask_cors import  CORS
    from chat import  get_response
    
    app  =  Flask(__name__)
    CORS(app, resources={r"/*": {"origins": "*"}})
    
    @app.get("/")
    def  index_get():
    return  jsonify({"answer": "Hi, How can I help you today?"})
    
    @app.post("/predict")
    def  predict():
    text  =  request.get_json().get("message")
    #check text valid
    response  =  get_response(text)
    message  = {"answer": response}
    return  jsonify(message)
    
    if  __name__  ==  "__main__":
    app.run(host='0.0.0.0', port=5500)

## Deploy to Azure using Docker
**Prepare**

You need to create `Resource Group`, `Container Registry`, `App Service plan`, and `App Service`. 
- In `App Service`, Deployemnt - Deployment Center, `Source` should be `Container Registry: Set up your app to pull the container image from a registry.`, and Under `Registry Setting` should be `Single Container` for `Container Type` with `Continuous deployement` is `ON`

**Need to login az acr**
`az acr login` or `docker login myregistry.azurecr.io`
Show `az acr list` and find `loginServer` in json responsed.
 
Generate `requirements.txt` using PyCharm, write Dockerfile
  
    FROM  python:3.9
    WORKDIR  /app
    COPY  .  .
    RUN  pip  install  -r  requirements.txt
    RUN  python  -m  nltk.downloader  punkt
    ENTRYPOINT  ["python"]
    EXPOSE  8080
    CMD  ["app.py"]

Build Docker image
`docker build -t aichatbot .`

Tag image same as loginServer and image:tag
`docker tag aichatbot aibotchat.azurecr.io/chatbot:1.6`

**Push** the docker image to ACR. then that's all.

## Demo
API: [https://aichatbot6.azurewebsites.net/](https://aichatbot6.azurewebsites.net/)
