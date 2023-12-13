from database import fetchone, fetchall

def create_attendee(event_id, name, email, contact_number):
  query = "CALL create_attendee(%s, %s, %s, %s)"
  params = (event_id, name, email, contact_number)
  result = fetchone(query, params)
  return result["attendee_id"]

def get_event_attendees():
  query = "SELECT * FROM get_event_attendees"
  result = fetchall(query)
  return result

def get_attendee(attendee_id):
  query = "SELECT * FROM get_event_attendees WHERE attendee_id = %s"
  params = (attendee_id,)
  result = fetchone(query, params)
  return result

def update_attendee(attendee_id, name, email, contact_number):
  query = "CALL update_attendee(%s, %s, %s, %s)"
  params = (attendee_id, name, email, contact_number)
  result = fetchone(query, params)
  return result["attendee_id"]

def delete_attendee(attendee_id):
  query = "CALL delete_attendee(%s)"
  params = (attendee_id,)
  result = fetchone(query, params)
  return result["attendee_id"]
