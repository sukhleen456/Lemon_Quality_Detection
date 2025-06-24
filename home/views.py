from django.shortcuts import render,HttpResponse
import pickle
import numpy as np
from PIL import Image
from io import BytesIO
import tensorflow as tf
import os

model = tf.keras.models.load_model("./lemon.h5")
class_name = ['bad_quality', 'empty_background', 'good_quality']

def read_file_as_image(data):
    image = np.array(Image.open(BytesIO(data)))
    return image
# Create your views here.
def home(request):
    #return HttpResponse("this is our home page")
    return render(request,'index.html')
def about(request):
    #return HttpResponse("this is our about page")
    return render(request,'about.html')
def contact(request):
    #return HttpResponse("this is our contact page")
    return render(request,'contact.html')
def login(request):
    #return HttpResponse("this is our contact page")
    return render(request,'login.html')
def register(request):
    #return HttpResponse("this is our contact page")
    return render(request,'register.html')
def prediction(request):
    
    context = {
        "status": False
    }
    # return HttpResponse("This is the our registration page")
    if request.method == "POST":
        f = request.FILES['lemon']
        # print(str(f))
        data = f.read()
        image = read_file_as_image(data)
        img_batch = np.expand_dims(image, 0)

        predictions = model.predict(img_batch)
        predicted_class = class_name[np.argmax(predictions[0])]
        confidence = np.max(predictions[0])
        # print(predictions, predicted_class, confidence)
        # print("lemon")
        context = {
            "Actual_image": str(f),
            "confidence": str(confidence * 100),
            "prediction": str(predicted_class),
            "status" : True
        }
        return render(request, "prediction.html", context)
    else:
    
        return render(request, 'prediction.html', context)
    
def faq(request):
    return render(request, 'faq.html')