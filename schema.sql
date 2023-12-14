CREATE TABLE tblpersons (
  id int unsigned NOT NULL AUTO_INCREMENT,
  name varchar(200) NOT NULL DEFAULT '',
  age int NOT NULL,
  occupation varchar(200) DEFAULT NULL,
  email varchar(200) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblusers (
  id int unsigned NOT NULL AUTO_INCREMENT,
  person_id int NOT NULL,
  username varchar(200) NOT NULL DEFAULT '',
  password varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE dbeventmanagement.tblorganizers (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    contact_number VARCHAR(20)
);

CREATE TABLE dbeventmanagement.tblvenues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_name VARCHAR(255),
    location VARCHAR(255),
    capacity INT
);

CREATE TABLE dbeventmanagement.tblevents (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255),
    event_date DATE,
    venue_id INT,
    organizer_id INT,
    FOREIGN KEY (venue_id) REFERENCES tblvenues(venue_id),
    FOREIGN KEY (organizer_id) REFERENCES tblorganizers(organizer_id)
);

CREATE TABLE dbeventmanagement.tblattendees (
    attendee_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    contact_number VARCHAR(20),
    FOREIGN KEY (event_id) REFERENCES tblevents(event_id)
);

CREATE VIEW get_users AS
SELECT
  p.name,
  p.age,
  p.occupation,
  p.email,
  u.id,
  u.username,
  u.password
FROM tblpersons p
INNER JOIN tblusers u ON u.person_id = p.id;

DELIMITER $$
CREATE PROCEDURE create_user(
  IN p_name varchar(200),
  IN p_age int,
  IN p_occupation varchar(200),
  IN p_email varchar(200),
  IN p_username varchar(200),
  IN p_password varchar(200)
)
BEGIN
  DECLARE v_person_id int;
  INSERT INTO tblpersons(name, age, occupation, email) VALUES(p_name, p_age, p_occupation, p_email);
  SET v_person_id = LAST_INSERT_ID();
  INSERT INTO tblusers(person_id, username, password) VALUES(v_person_id, p_username, p_password);
  SELECT LAST_INSERT_ID() AS id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_user(
  IN user_id int,
  IN p_name varchar(200),
  IN p_age int,
  IN p_occupation varchar(200),
  IN p_email varchar(200),
  IN p_username varchar(200),
  IN p_password varchar(200)
)
BEGIN
  UPDATE tblpersons
  INNER JOIN tblusers ON tblusers.person_id = tblpersons.id
  SET name = p_name, age = p_age, occupation = p_occupation, email = p_email
  WHERE tblusers.id = user_id;
  UPDATE tblusers SET username = p_username, password = p_password
  WHERE id = user_id;
  SELECT user_id AS id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_user(IN user_id int)
BEGIN
  DELETE FROM tblpersons WHERE id = (SELECT person_id FROM users WHERE id = user_id);
  DELETE FROM tblusers WHERE id = user_id;
  SELECT user_id AS id;
END$$
DELIMITER ;

-- View to get all organizers
CREATE VIEW get_organizers AS
SELECT
  organizer_id,
  name,
  email,
  contact_number
FROM dbeventmanagement.tblorganizers;

-- Stored Procedure to create an organizer
DELIMITER $$
CREATE PROCEDURE create_organizer(
  IN p_name VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_contact_number VARCHAR(20)
)
BEGIN
  INSERT INTO dbeventmanagement.tblorganizers(name, email, contact_number) 
  VALUES(p_name, p_email, p_contact_number);
  SELECT LAST_INSERT_ID() AS organizer_id;
END$$
DELIMITER ;

-- Stored Procedure to update an organizer
DELIMITER $$
CREATE PROCEDURE update_organizer(
  IN p_organizer_id INT,
  IN p_name VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_contact_number VARCHAR(20)
)
BEGIN
  UPDATE dbeventmanagement.tblorganizers
  SET name = p_name, email = p_email, contact_number = p_contact_number
  WHERE organizer_id = p_organizer_id;
  SELECT p_organizer_id AS organizer_id;
END$$
DELIMITER ;

-- Stored Procedure to delete an organizer
DELIMITER $$
CREATE PROCEDURE delete_organizer(IN p_organizer_id INT)
BEGIN
  DELETE FROM dbeventmanagement.tblorganizers WHERE organizer_id = p_organizer_id;
  SELECT p_organizer_id AS organizer_id;
END$$
DELIMITER ;

-- View to get all venues
CREATE VIEW get_venues AS
SELECT
  venue_id,
  venue_name,
  location,
  capacity
FROM dbeventmanagement.tblvenues;

-- Stored procedure to create a venue
DELIMITER $$
CREATE PROCEDURE create_venue(
  IN p_venue_name varchar(255),
  IN p_location varchar(255),
  IN p_capacity int
)
BEGIN
  INSERT INTO dbeventmanagement.tblvenues(venue_name, location, capacity) VALUES(p_venue_name, p_location, p_capacity);
  SELECT LAST_INSERT_ID() AS venue_id;
END$$
DELIMITER ;

-- Stored procedure to update a venue
DELIMITER $$
CREATE PROCEDURE update_venue(
  IN p_venue_id int,
  IN p_venue_name varchar(255),
  IN p_location varchar(255),
  IN p_capacity int
)
BEGIN
  UPDATE dbeventmanagement.tblvenues
  SET venue_name = p_venue_name, location = p_location, capacity = p_capacity
  WHERE venue_id = p_venue_id;
  SELECT p_venue_id AS venue_id;
END$$
DELIMITER ;

-- Stored procedure to delete a venue
DELIMITER $$
CREATE PROCEDURE delete_venue(IN p_venue_id int)
BEGIN
  DELETE FROM dbeventmanagement.tblvenues WHERE venue_id = p_venue_id;
  SELECT p_venue_id AS venue_id;
END$$
DELIMITER ;

-- VIEW: Get all events
CREATE VIEW get_events AS
SELECT
    e.event_id,
    e.event_name,
    e.event_date,
    v.venue_name,
    o.name AS organizer_name
FROM tblevents e
INNER JOIN tblvenues v ON e.venue_id = v.venue_id
INNER JOIN tblorganizers o ON e.organizer_id = o.organizer_id;

-- PROCEDURE: Create event
DELIMITER $$
CREATE PROCEDURE create_event(
  IN p_event_name VARCHAR(255),
  IN p_event_date DATE,
  IN p_venue_id INT,
  IN p_organizer_id INT
)
BEGIN
  INSERT INTO tblevents(event_name, event_date, venue_id, organizer_id) VALUES(p_event_name, p_event_date, p_venue_id, p_organizer_id);
  SELECT LAST_INSERT_ID() AS event_id;
END$$
DELIMITER ;

-- PROCEDURE: Update event
DELIMITER $$
CREATE PROCEDURE update_event(
  IN p_event_id INT,
  IN p_event_name VARCHAR(255),
  IN p_event_date DATE,
  IN p_venue_id INT,
  IN p_organizer_id INT
)
BEGIN
  UPDATE tblevents
  SET event_name = p_event_name, event_date = p_event_date, venue_id = p_venue_id, organizer_id = p_organizer_id
  WHERE event_id = p_event_id;
  SELECT p_event_id AS event_id;
END$$
DELIMITER ;

-- PROCEDURE: Delete event
DELIMITER $$
CREATE PROCEDURE delete_event(IN p_event_id INT)
BEGIN
  DELETE FROM tblevents WHERE event_id = p_event_id;
  SELECT p_event_id AS event_id;
END$$
DELIMITER ;

-- View to get all attendees for an event
CREATE VIEW get_event_attendees AS
SELECT
  a.attendee_id,
  a.name,
  a.email,
  a.contact_number,
  e.event_name,
  e.event_date,
  v.venue_name,
  o.name AS organizer_name
FROM dbeventmanagement.tblattendees a
INNER JOIN dbeventmanagement.tblevents e ON a.event_id = e.event_id
INNER JOIN dbeventmanagement.tblvenues v ON e.venue_id = v.venue_id
INNER JOIN dbeventmanagement.tblorganizers o ON e.organizer_id = o.organizer_id;

-- Stored procedure to create an attendee
DELIMITER $$
CREATE PROCEDURE create_attendee(
  IN p_event_id INT,
  IN p_name VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_contact_number VARCHAR(20)
)
BEGIN
  INSERT INTO dbeventmanagement.tblattendees(event_id, name, email, contact_number)
  VALUES(p_event_id, p_name, p_email, p_contact_number);
  SELECT LAST_INSERT_ID() AS attendee_id;
END$$
DELIMITER ;

-- Stored procedure to update an attendee
DELIMITER $$
CREATE PROCEDURE update_attendee(
  IN p_attendee_id INT,
  IN p_name VARCHAR(255),
  IN p_email VARCHAR(255),
  IN p_contact_number VARCHAR(20)
)
BEGIN
  UPDATE dbeventmanagement.tblattendees
  SET name = p_name, email = p_email, contact_number = p_contact_number
  WHERE attendee_id = p_attendee_id;
  SELECT p_attendee_id AS attendee_id;
END$$
DELIMITER ;

-- Stored procedure to delete an attendee
DELIMITER $$
CREATE PROCEDURE delete_attendee(IN p_attendee_id INT)
BEGIN
  DELETE FROM dbeventmanagement.tblattendees WHERE attendee_id = p_attendee_id;
  SELECT p_attendee_id AS attendee_id;
END$$
DELIMITER ;

