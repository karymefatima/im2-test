from database import fetchone, fetchall

def create_organizer(name, email, contact_number):
  query = "CALL create_organizer(%s, %s, %s)"
  params = (name, email, contact_number)
  result = fetchone(query, params)
  return result["organizer_id"]

def get_organizers():
  query = "SELECT * FROM get_organizers"
  result = fetchall(query)
  return result

def get_organizer(id):
  query = "SELECT * FROM get_organizers WHERE organizer_id = %s"
  params = (id,)
  result = fetchone(query, params)
  return result

def update_organizer(id, name, email, contact_number):
  query = "CALL update_organizer(%s, %s, %s, %s)"
  params = (id, name, email, contact_number)
  result = fetchone(query, params)
  return result["organizer_id"]

def delete_organizer(id):
  query = "CALL delete_organizer(%s)"
  params = (id,)
  result = fetchone(query, params)
  return result["organizer_id"]
