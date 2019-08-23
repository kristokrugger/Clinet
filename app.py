from flask import Flask, render_template, request, redirect, url_for, session
from forms import PatientRegistrationForm, DoctorRegistrationForm, RegistrationForm

app = Flask(__name__)
app.config['SECRET_KEY'] = 'mykey'

@app.route('/')
def homepage():
    """ Return the website's homepage to the client """
    return render_template('homepage.html')

@app.route('/about_us')
def about_us():
    """ Return the website's about us page to the client """
    return render_template('about_us.html')

@app.route('/location')
def location():
    """ Return the website's location page to the client """
    return render_template('location.html')

@app.route('/patient_registration', methods = ['GET', 'POST'])
def patient_registration():
    """ Return the website's patient registration page to the client """
    form = PatientRegistrationForm()
    return render_template('patient_registration.html', form=form)

@app.route('/doctor_registration', methods = ['GET', 'POST'])
def doctor_registration():
    """ Return the website's doctor registration page to the client """
    form = DoctorRegistrationForm()
    return render_template('doctor_registration.html', form=form)

@app.route('/receptionist_registration', methods = ['GET', 'POST'])
def receptionist_registration():
    """ Return the website's receptionist registration page to the client """
    form = RegistrationForm()
    return render_template('receptionist_registration.html', form=form)

@app.route('/technician_registration', methods = ['GET', 'POST'])
def technician_registration():
    """ Return the website's technician registration page to the client """
    form = RegistrationForm()
    return render_template('technician_registration.html', form=form)



if __name__ == '__main__':
    app.run(debug=True)