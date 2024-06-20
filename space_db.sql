SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS space_db;
USE space_db;

CREATE TABLE Sector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(255) NOT NULL,
    light_intensity DECIMAL(10, 2) NOT NULL,
    foreign_objects TEXT,
    star_objects_count INT NOT NULL,
    undefined_objects_count INT NOT NULL,
    defined_objects_count INT NOT NULL,
    notes TEXT
);

CREATE TABLE Objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    accuracy DECIMAL(5, 2) NOT NULL,
    quantity INT NOT NULL,
    time TIME NOT NULL,
    date DATE NOT NULL,
    note TEXT,
    date_update DATETIME
);

CREATE TABLE NaturalObjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    galaxy VARCHAR(100) NOT NULL,
    accuracy DECIMAL(5, 2) NOT NULL,
    light_flux DECIMAL(10, 2) NOT NULL,
    associated_objects TEXT,
    note TEXT
);

CREATE TABLE Positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_position VARCHAR(255) NOT NULL,
    sun_position VARCHAR(255) NOT NULL,
    moon_position VARCHAR(255) NOT NULL
);

CREATE TABLE Links (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    position_id INT,
    FOREIGN KEY (sector_id) REFERENCES Sector(id),
    FOREIGN KEY (object_id) REFERENCES Objects(id),
    FOREIGN KEY (natural_object_id) REFERENCES NaturalObjects(id),
    FOREIGN KEY (position_id) REFERENCES Positions(id)
);

INSERT INTO Sector (coordinates, light_intensity, foreign_objects, star_objects_count, undefined_objects_count, defined_objects_count, notes) VALUES
('12.345, 67.890', 100.50, 'Debris', 1000, 50, 950, 'Notes about sector 1'),
('23.456, 78.901', 200.75, 'Satellite', 1500, 100, 1400, 'Notes about sector 2'),
('34.567, 89.012', 300.25, 'Asteroid', 2000, 150, 1850, 'Notes about sector 3'),
('45.678, 90.123', 400.50, 'Comet', 2500, 200, 2300, 'Notes about sector 4'),
('56.789, 01.234', 500.75, 'Spacecraft', 3000, 250, 2750, 'Notes about sector 5');

INSERT INTO Objects (type, accuracy, quantity, time, date, note) VALUES
('Star', 99.99, 100, '12:00:00', '2024-06-19', 'Notes about object 1'),
('Planet', 98.75, 200, '13:00:00', '2024-06-20', 'Notes about object 2'),
('Nebula', 97.50, 300, '14:00:00', '2024-06-21', 'Notes about object 3'),
('Galaxy', 96.25, 400, '15:00:00', '2024-06-22', 'Notes about object 4'),
('Black Hole', 95.00, 500, '16:00:00', '2024-06-23', 'Notes about object 5');

INSERT INTO NaturalObjects (type, galaxy, accuracy, light_flux, associated_objects, note) VALUES
('Star', 'Milky Way', 99.99, 1000.50, 'Planet', 'Notes about natural object 1'),
('Planet', 'Andromeda', 98.75, 2000.75, 'Moon', 'Notes about natural object 2'),
('Nebula', 'Triangulum', 97.50, 3000.25, 'Star', 'Notes about natural object 3'),
('Galaxy', 'Whirlpool', 96.25, 4000.50, 'Black Hole', 'Notes about natural object 4'),
('Black Hole', 'Sombrero', 95.00, 5000.75, 'Galaxy', 'Notes about natural object 5');

INSERT INTO Positions (earth_position, sun_position, moon_position) VALUES
('Earth Position 1', 'Sun Position 1', 'Moon Position 1'),
('Earth Position 2', 'Sun Position 2', 'Moon Position 2'),
('Earth Position 3', 'Sun Position 3', 'Moon Position 3'),
('Earth Position 4', 'Sun Position 4', 'Moon Position 4'),
('Earth Position 5', 'Sun Position 5', 'Moon Position 5');

INSERT INTO Links (sector_id, object_id, natural_object_id, position_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5);

DELIMITER $$
CREATE TRIGGER before_update_objects
BEFORE UPDATE ON Objects
FOR EACH ROW
BEGIN
    SET NEW.date_update = NOW();
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE JoinTables(IN table1 VARCHAR(64), IN table2 VARCHAR(64))
BEGIN
    SET @query = CONCAT('SELECT * FROM ', table1, ' t1 JOIN ', table2, ' t2 ON t1.id = t2.id');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

COMMIT;