#FROM python:3.9.13
#
#WORKDIR /user/src/app
#
#COPY "requirements.txt" .
#
#RUN pip install -r requirements.txt
#
#COPY . .
#
#CMD ["train.py"]
#
##ENTRYPOINT ["python", "app.py"]
#
#CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

FROM python:3.9

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

RUN python -m nltk.downloader punkt

ENTRYPOINT ["python"]

EXPOSE 8080

CMD ["app.py"]