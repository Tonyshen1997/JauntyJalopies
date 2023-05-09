USE master
GO
DROP DATABASE IF EXISTS Jaunty_Jalopies

CREATE DATABASE Jaunty_Jalopies
GO

USE Jaunty_Jalopies;
GO

CREATE TABLE Users (   

user_name VARCHAR(100) NOT NULL,   

first_name VARCHAR(50) NOT NULL,   

last_name VARCHAR(50) NOT NULL,   

password VARCHAR(50) NOT NULL,   

PRIMARY KEY(user_name)  

);  

  

CREATE TABLE ServiceWriter (  

user_name VARCHAR(100) NOT NULL,  

PRIMARY KEY(user_name),  

FOREIGN KEY (user_name) REFERENCES Users(user_name)  

);  


CREATE TABLE SalesPeople(  

user_name VARCHAR(100) NOT NULL,  

PRIMARY KEY(user_name),  

FOREIGN KEY (user_name) REFERENCES Users(user_name)  

);  


CREATE TABLE Owner(  

user_name VARCHAR(100) NOT NULL,  

PRIMARY KEY(user_name),  

FOREIGN KEY (user_name) REFERENCES Users(user_name)  

);  

  

CREATE TABLE Manager(  

user_name VARCHAR(100) NOT NULL,  

PRIMARY KEY(user_name),  

FOREIGN KEY (user_name) REFERENCES Users(user_name)  

);  


CREATE TABLE InventoryClerk(  

user_name VARCHAR(100) NOT NULL,  

PRIMARY KEY(user_name),  

FOREIGN KEY (user_name) REFERENCES Users(user_name)  

);  

  

CREATE TABLE Customer(   

customerID INTEGER IDENTITY(1,1) NOT NULL,   

email VARCHAR(50) NULL,   

phone_number VARCHAR(20) NOT NULL,   

street_Address VARCHAR(255) NOT NULL,  

city VARCHAR(50) NOT NULL,  

state VARCHAR(20) NOT NULL,   

postal_code VARCHAR(5) NOT NULL,  

PRIMARY KEY(customerID),  
 

);  

CREATE TABLE Individual (   

driver_license VARCHAR(20) NOT NULL,   

first_name VARCHAR(50) NOT NULL,   

last_name VARCHAR(50) NOT NULL,  

customerID INTEGER NOT NULL,   

PRIMARY KEY (driver_license),   

FOREIGN KEY (customerID) REFERENCES Customer(customerID)  

);   


CREATE TABLE Business (   

tax_ID VARCHAR(20) NOT NULL,   

contact_title VARCHAR(30) NOT NULL,   

contact_name VARCHAR(50) NOT NULL,   

business_name VARCHAR(50) NOT NULL,   

customerID INTEGER NOT NULL,   

PRIMARY KEY (tax_ID),   

FOREIGN KEY (customerID) REFERENCES Customer(customerID)   

);   


CREATE TABLE Manufacturer(   

name VARCHAR(255) NOT NULL   

PRIMARY KEY (name)   

);   

  
CREATE TABLE Vehicle (   

VIN VARCHAR(20) NOT NULL,   

description VARCHAR(max) NULL,   

model_year INTEGER NOT NULL,   

model_name VARCHAR(50) NOT NULL,   

invoice_price DECIMAL(10,2) NOT NULL,   

manufacturer_name VARCHAR(255) NOT NULL,   

inv_writer_user_name VARCHAR(100) NOT NULL,   

add_date DATE NOT NULL,   

PRIMARY KEY(VIN),   

FOREIGN KEY (manufacturer_name) REFERENCES Manufacturer(name),  

FOREIGN KEY (inv_writer_user_name) REFERENCES InventoryClerk(user_name) 

);   

CREATE TABLE Car (   

number_of_doors INTEGER NOT NULL,	   

VIN VARCHAR(20) NOT NULL,   

PRIMARY KEY(VIN),  

FOREIGN KEY(VIN) REFERENCES Vehicle(VIN)  

);   

CREATE TABLE Convertible(   

roof_type VARCHAR(50) NOT NULL,   

back_Seat_Count INTEGER NOT NULL,   

VIN VARCHAR(20) NOT NULL,   

PRIMARY KEY(VIN),  

FOREIGN KEY(VIN) REFERENCES Vehicle(VIN)  

);   


CREATE TABLE Truck(   

cargo_capacity	 DECIMAL(5,2) NOT NULL,   

cargo_cover_type VARCHAR(20) NULL,	   

number_of_rear_axies INTEGER NOT NULL,   

VIN VARCHAR(20) NOT NULL,   

PRIMARY KEY(VIN),  

FOREIGN KEY(VIN) REFERENCES Vehicle(VIN)   

);   


CREATE TABLE Van (   

VIN VARCHAR(20) NOT NULL,   

has_driver_side_back_door BIT NOT NULL,   

PRIMARY KEY(VIN),   

FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)   

);   

  

CREATE TABLE SUV (    

VIN VARCHAR(20) NOT NULL,   

number_of_cupholder INTEGER NOT NULL,   

drivetrain_type VARCHAR(255) NOT NULL,   

PRIMARY KEY(VIN),  

FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)   

);   

CREATE TABLE Color (  

name VARCHAR(10) NOT NULL,  

PRIMARY KEY (name)  

);   


CREATE TABLE VehicleHasColor (  

VIN VARCHAR(20) NOT NULL,  

color VARCHAR(10) NOT NULL,  

PRIMARY KEY (VIN, color),  

FOREIGN KEY (VIN) REFERENCES Vehicle(VIN),	  

FOREIGN KEY (color) REFERENCES Color (name) 

);  



CREATE TABLE SalesTransaction (   

VIN VARCHAR(20) NOT NULL,   

customerID INTEGER NOT NULL,   

sales_writer_user_name VARCHAR(100) NOT NULL,  

sold_price DECIMAL(10,2) NOT NULL,   

transaction_date DATE NOT NULL,   

PRIMARY KEY (VIN),   

FOREIGN KEY (VIN) REFERENCES Vehicle(VIN),  

FOREIGN KEY (customerID) REFERENCES Customer(customerID),  

FOREIGN KEY (sales_writer_user_name) REFERENCES SalesPeople(user_name)  

);   

CREATE TABLE RepairDetails(   

VIN VARCHAR(20) NOT NULL,   

start_date DATE NOT NULL,   

customerID INTEGER NOT NULL,   

repair_starter VARCHAR(100) NOT NULL,   

odometer_value INTEGER NOT NULL,   

description VARCHAR(max) NULL,   

labor_charge DECIMAL(10,2) DEFAULT 0,   

complete_date DATE NULL,   

PRIMARY KEY (VIN, start_date),   

FOREIGN KEY (VIN) REFERENCES Vehicle(VIN),  

FOREIGN KEY (repair_starter) REFERENCES ServiceWriter(user_name)  

);   


CREATE TABLE Part(   

VIN VARCHAR(20) NOT NULL,  

start_date DATE NOT NULL,   

part_number VARCHAR(50) NOT NULL,   

quantity INTEGER NOT NULL,   

price DECIMAL(10,2) NOT NULL,   

vendor VARCHAR(20) NOT NULL,   

PRIMARY KEY (VIN, start_date, part_number),   

FOREIGN KEY (VIN,start_date) REFERENCES RepairDetails(VIN,start_date) 

); 