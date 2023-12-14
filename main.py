import os
from flask import Flask, jsonify, request, render_template, redirect, url_for
from flask_mysqldb import MySQL
from attendees import create_attendee, get_event_attendees, get_attendee, update_attendee, delete_attendee
from events import create_event, get_events, get_event, update_event, delete_event
from organizers import create_organizer, get_organizers, get_organizer, update_organizer, delete_organizer
from users import create_user, get_users, get_user, update_user, delete_user
from venues import create_venue, get_venues, get_venue, update_venue, delete_venue
from database import set_mysql
from dotenv import load_dotenv

app = Flask(__name__)

load_dotenv()
# Required
app.config["MYSQL_HOST"] = os.getenv("MYSQL_HOST")
app.config["MYSQL_PORT"] = int(os.getenv("MYSQL_PORT"))
app.config["MYSQL_USER"] = os.getenv("MYSQL_USER")
app.config["MYSQL_PASSWORD"] = os.getenv("MYSQL_PASSWORD")
app.config["MYSQL_DB"] = os.getenv("MYSQL_DB")
# Extra configs, optional but mandatory for this project:
app.config["MYSQL_CURSORCLASS"] = os.getenv("MYSQL_CURSORCLASS")
app.config["MYSQL_AUTOCOMMIT"] = True if os.getenv("MYSQL_AUTOCOMMIT") == "true" else False

mysql = MySQL(app)
set_mysql(mysql)

@app.route("/")
def home():
  return jsonify({"message": "Hello, CSIT327!"})

@app.route("/users", methods=["GET", "POST"])
def users():
  if request.method == "POST":
    data = request.get_json()
    user_id = create_user(
      data["name"], data["age"], data["occupation"],
      data["email"], data["password"]
    )
    return jsonify({"id": user_id})
  else:
    users = get_users()
    return jsonify(users)

@app.route("/users/<int:id>", methods=["GET", "PUT", "DELETE"])
def user(id):
  if request.method == "PUT":
    data = request.get_json()
    user_id = update_user(
      id,
      data["name"], data["age"], data["occupation"],
      data["email"], data["password"]
    )
    return jsonify({"id": user_id})
  elif request.method == "DELETE":
    user_id = delete_user(id)
    return jsonify({"id": user_id})
  else:
    user = get_user(id)
    return jsonify(user)
  
@app.route("/organizers", methods=["GET", "POST"])
def organizers():
  if request.method == "POST":
    data = request.get_json()
    organizer_id = create_organizer(
      data["name"], data["email"], data["contact_number"]
    )
    return jsonify({"organizer_id": organizer_id})
  else:
    organizers = get_organizers()
    return jsonify(organizers)

##########
@app.route("/organizersui", methods=["GET", "POST"])
def organizers_ui():
    if request.method == "POST":
        name = request.form.get('name')
        email = request.form.get('email')
        contact_number = request.form.get('contact_number')
        create_organizer(name, email, contact_number)  # this should now return the new organizer
        return redirect(url_for('organizers_ui'))  # redirect to the same page
    else:
        organizers = get_organizers()  # function to fetch all organizers from your database
        return render_template('organizers.html', organizers=organizers)

@app.route("/organizers/update/<int:id>", methods=["GET"])
def update_organizer_ui(id):
    organizer = get_organizer(id)
    return render_template('update_organizer.html', organizer=organizer)

@app.route("/organizers/update/<int:id>", methods=["POST"])
def update_organizer_record(id):
    name = request.form.get('name')
    email = request.form.get('email')
    contact_number = request.form.get('contact_number')
    update_organizer(id, name, email, contact_number)
    return redirect(url_for('organizers_ui'))

##########

@app.route("/organizers/<int:id>", methods=["GET", "PUT", "DELETE"])
def organizer(id):
  if request.method == "PUT":
    data = request.get_json()
    organizer_id = update_organizer(
      id,
      data["name"], data["email"], data["contact_number"]
    )
    return jsonify({"organizer_id": organizer_id})
  elif request.method == "DELETE":
    organizer_id = delete_organizer(id)
    return jsonify({"organizer_id": organizer_id})
  else:
    organizer = get_organizer(id)
    return jsonify(organizer)

@app.route("/venues", methods=["GET", "POST"])
def venues():
  if request.method == "POST":
    data = request.get_json()
    venue_id = create_venue(
      data["venue_name"], data["location"], data["capacity"]
    )
    return jsonify({"venue_id": venue_id})
  else:
    venues = get_venues()
    return jsonify(venues)

@app.route("/venues/<int:venue_id>", methods=["GET", "PUT", "DELETE"])
def venue(venue_id):
  if request.method == "PUT":
    data = request.get_json()
    venue_id = update_venue(
      venue_id,
      data["venue_name"], data["location"], data["capacity"]
    )
    return jsonify({"venue_id": venue_id})
  elif request.method == "DELETE":
    venue_id = delete_venue(venue_id)
    return jsonify({"venue_id": venue_id})
  else:
    venue = get_venue(venue_id)
    return jsonify(venue)

@app.route("/events", methods=["GET", "POST"])
def events():
  if request.method == "POST":
    data = request.get_json()
    event_id = create_event(
      data["event_name"], data["event_date"], data["venue_id"],
      data["organizer_id"]
    )
    return jsonify({"event_id": event_id})
  else:
    events = get_events()
    return jsonify(events)

@app.route("/events/<int:event_id>", methods=["GET", "PUT", "DELETE"])
def event(event_id):
  if request.method == "PUT":
    data = request.get_json()
    event_id = update_event(
      event_id,
      data["event_name"], data["event_date"], data["venue_id"],
      data["organizer_id"]
    )
    return jsonify({"event_id": event_id})
  elif request.method == "DELETE":
    event_id = delete_event(event_id)
    return jsonify({"event_id": event_id})
  else:
    event = get_event(event_id)
    return jsonify(event)

@app.route("/attendees", methods=["GET", "POST"])
def attendees():
  if request.method == "POST":
    data = request.get_json()
    attendee_id = create_attendee(
      data["event_id"], data["name"], data["email"], data["contact_number"]
    )
    return jsonify({"id": attendee_id})
  else:
    attendees = get_event_attendees()
    return jsonify(attendees)

@app.route("/attendees/<int:id>", methods=["GET", "PUT", "DELETE"])
def attendee(id):
  if request.method == "PUT":
    data = request.get_json()
    attendee_id = update_attendee(
      id,
      data["name"], data["email"], data["contact_number"]
    )
    return jsonify({"id": attendee_id})
  elif request.method == "DELETE":
    attendee_id = delete_attendee(id)
    return jsonify({"id": attendee_id})
  else:
    attendee = get_attendee(id)
    return jsonify(attendee)
