## load from python
FROM python
## copy all files
COPY . . 
## run requirements to install packages
RUN pip install --no-cache-dir -r requirements.txt
## when you run , run app.py
CMD ["python3", "app.py"]