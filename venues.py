from database import fetchone, fetchall

def create_venue(venue_name, location, capacity):
  query = "CALL create_venue(%s, %s, %s)"
  params = (venue_name, location, capacity)
  result = fetchone(query, params)
  return result["venue_id"]

def get_venues():
  query = "SELECT * FROM get_venues"
  result = fetchall(query)
  return result

def get_venue(venue_id):
  query = "SELECT * FROM get_venues WHERE venue_id = %s"
  params = (venue_id,)
  result = fetchone(query, params)
  return result

def update_venue(venue_id, venue_name, location, capacity):
  query = "CALL update_venue(%s, %s, %s, %s)"
  params = (venue_id, venue_name, location, capacity)
  result = fetchone(query, params)
  return result["venue_id"]

def delete_venue(venue_id):
  query = "CALL delete_venue(%s)"
  params = (venue_id,)
  result = fetchone(query, params)
  return result["venue_id"]

