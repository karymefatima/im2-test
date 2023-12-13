from database import fetchone, fetchall

def create_event(event_name, event_date, venue_id, organizer_id):
  query = "CALL create_event(%s, %s, %s, %s)"
  params = (event_name, event_date, venue_id, organizer_id)
  result = fetchone(query, params)
  return result["event_id"]

def get_events():
  query = "SELECT * FROM get_events"
  result = fetchall(query)
  return result

def get_event(event_id):
  query = "SELECT * FROM get_events WHERE event_id = %s"
  params = (event_id,)
  result = fetchone(query, params)
  return result

def update_event(event_id, event_name, event_date, venue_id, organizer_id):
  query = "CALL update_event(%s, %s, %s, %s, %s)"
  params = (event_id, event_name, event_date, venue_id, organizer_id)
  result = fetchone(query, params)
  return result["event_id"]

def delete_event(event_id):
  query = "CALL delete_event(%s)"
  params = (event_id,)
  result = fetchone(query, params)
  return result["event_id"]
