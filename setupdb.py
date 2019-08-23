from db import db Doctor
from flask_migrate import Migrate

# connect application with database in order to add migration capabilities to run terminal commands
Migrate(app, db)