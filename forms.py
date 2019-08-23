from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField, IntegerField
from wtforms.validators import DataRequired, Email, EqualTo, Length


class RegistrationForm(FlaskForm):
    """ A base registration form. """
    first_name = StringField('First Name', validators = [DataRequired()])
    last_name = StringField('Last Name', validators=[DataRequired()])
    email = StringField('Email', validators = [DataRequired(), Email()])
    password = PasswordField('Password', validators = [DataRequired(), EqualTo('password_confirm', message =
                                                                               'Passwords must match!')])
    password_confirm = PasswordField('Confirm Password', validators = [DataRequired()])
    submit = SubmitField('Register')

class DoctorRegistrationForm(RegistrationForm):
    """ Registration form for doctors. """
    license_number = StringField('License Number', validators = [DataRequired()])

class PatientRegistrationForm(RegistrationForm):
    """ Registration form for patients. """
    age = IntegerField('Age', validators = [DataRequired()])
    gender = StringField('Gender', validators = [DataRequired()])
    blood_type = StringField('Blood Type', validators = [DataRequired()])
    telephone_number = IntegerField('Telephone Number', validators = [DataRequired(), Length(10)])

class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])


