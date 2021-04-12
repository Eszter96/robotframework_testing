*** Settings ***
Library   DatabaseLibrary
Library   Collections
Library   String
Library   OperatingSystem

*** Variables ***
#it needed only to create the connections but after that other db can be used
${dbname}   <someexistingdatabaseinyourmysqlserver> 
${dbuser}   <username>
${dbpass}   <password>
${dbhost}   localhost
${dbport}   3306
@{TablesInDataBase}   aine   kurssi   opettaja   oppilas   suoritus
@{ColumnsInOppilas}   oppilasnro   etunimi   sukunimi   syntpvm   lahiosoite   postinro   postitmp   sukupuoli

#Define a databasename what will be created by the first test case
${dbToBeCreatedAndTested}   test

*** Keywords ***

Make connection
    Connect to database   pymysql   ${dbname}  ${dbuser}  ${dbpass}  ${dbhost}   ${dbport}
   
Create database to be tested
    [Arguments]   ${databasename}
    #Drop the database first in order to avoid implications with insertion (if we want to test multiple times)
    Execute sql string   drop database if exists ${databasename}
    Execute sql string   create database ${databasename};
    Execute sql string   use ${databasename};
    #Use commands from "createtables" text file to execute commands on the database
    ${GetCommands}=   Get file  ./createtables.txt 
    ${CreationCommands}=  split string   ${GetCommands}   ;
    ${TableCount}=   get length   ${CreationCommands}
    ${IndexToBeRemoved}=   evaluate   ${TableCount}-1
    Remove from list   ${CreationCommands}   ${IndexToBeRemoved}
    ${TableCount}=   Get length  ${CreationCommands}
    FOR   ${INDEX}   IN RANGE   ${TableCount}
       Execute sql string   ${CreationCommands}[${INDEX}]
    END
    
Insert records into tables
    [Arguments]   ${databasename}
    #select the created database for further use
    Execute sql string   use ${databasename};
    #Use commands from "insertrecords" text file to execute commands on the tables
    ${GetCommands}=   Get file  ./insertrecords.txt 
    ${CreationCommands}=  split string   ${GetCommands}   ;
    ${InsertCount}=   get length   ${CreationCommands}
    ${IndexToBeRemoved}=   evaluate   ${InsertCount}-1
    Remove from list   ${CreationCommands}   ${IndexToBeRemoved}
    ${Insertcount}=   Get length  ${CreationCommands}
    FOR   ${INDEX}   IN RANGE   ${InsertCount}
       Execute sql string   ${CreationCommands}[${INDEX}]
    END
    set global variable   ${InsertCount}

#This test case will create the database for later use
*** Test Cases ***
Create database and insert data
    Make connection
    Create database to be tested   ${dbToBeCreatedAndTested}
    Insert records into tables   ${dbToBeCreatedAndTested}

*** Test Cases ***
Insert column into aine
    Make connection
    Execute sql string   use ${dbToBeCreatedAndTested};
    Execute sql string   ALTER TABLE aine ADD COLUMN osallistuja INT NOT NULL;

*** Test Cases ***
Remove column from aine
    Make connection
    Execute sql string   use ${dbToBeCreatedAndTested};
    Execute sql string   ALTER TABLE aine DROP COLUMN osallistuja;

*** Test Cases ***
Attempt to insert wrong entry into table aine
    #In this test case we are supposed to get some error due to wrongly defined command arguments
    Make connection
    Execute sql string   use ${dbToBeCreatedAndTested};
    Execute sql string   INSERT INTO aine VALUES('a720', 'Kielen alkeet', 'h256', 'wrong data');