*** Settings ***
Library   SeleniumLibrary
Library   Collections
Library   OperatingSystem
Library   String

*** Variables ***
#Give the path which points to the file containing the information for inputs 
#(which has been converted from the downloaded xlsx file from rpachallenge.com )
${path}   ./challenge.txt

*** Test Cases ***
Get entries and save into a variable
   #Read the challenge.txt file to store into a variable the information about 10 people 
   ${personalInfo}=   Get file   ${path}
   #Split string by rows
   @{resultList}=   Split string   ${personalInfo}   \n
   #Get how many people information can be found in list
   ${count}=   Get length   ${resultList}
   set global variable   ${resultList}
   set global variable   ${count}

*** Keywords ***
Get dictionary for each person containing their information
    #This keyword receives a parameter which includes the information of the current person 
    [Arguments]  ${InfoOfCurrentPerson}
    #Split string to list, to get separated information and get and array of those
    @{resultList}=   Split string   ${InfoOfCurrentPerson}   ,
    #Create dictionary using the elements of the result list
    ${dict}   Create dictionary   First Name=${resultList}[0]   Last Name=${resultList}[1]   Company Name=${resultList}[2]   Role in Company=${resultList}[3]   Address=${resultList}[4]   Email=${resultList}[5]   Phone Number=${resultList}[6] 
    #Make the variable available for other keywords or test cases
    set global variable   ${dict}
    
Fill out form  
    FOR   ${i}   IN RANGE  1  ${count2}+1
       #Get to know the belonging label of the current input
       ${label}=   Get text  xpath:/html/body/app-root/div[2]/app-rpa1/div/div[2]/form/div/div[${i}]/rpa1-field/div/label
       #Input the corresponding information based on the label of the input field
       Input text   xpath:/html/body/app-root/div[2]/app-rpa1/div/div[2]/form/div/div[${i}]/rpa1-field/div/input   ${dict}[${label}]   
    END

*** Test Cases ***
Fill out form
   Open browser   http://www.rpachallenge.com/  
   Maximize browser window
   #Get how many input field are there and make it available for any testcase/keyword
   ${count2}=   Get element count   xpath:/html/body/app-root/div[2]/app-rpa1/div/div[2]/form/div/div[*]/rpa1-field/div/label
   set global variable    ${count2}
   #Click START button
   Click button   xpath:/html/body/app-root/div[2]/app-rpa1/div/div[1]/div[6]/button
   #Go through on list and create dictionary for entries person by person
   FOR   ${j}   IN RANGE   ${count}
      Run keyword   Get dictionary for each person containing their information   ${resultList}[${j}]
      Run keyword   Fill out form
      Click button   xpath:/html/body/app-root/div[2]/app-rpa1/div/div[2]/form/input
   END