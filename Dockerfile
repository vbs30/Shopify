FROM python:3.9

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 8000

CMD python manage.py makemigrations
CMD python manage.py migrate 
CMD python3 manage.py collectstatic --noinput 
CMD python manage.py runserver  0.0.0.0:8000 --noreload
