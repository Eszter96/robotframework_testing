*** Settings ***
Library   String
Library   OperatingSystem
Library   Collections

*** Variables ***
# Get path for the textfile
${path}   ./webpages.txt

*** Keywords ***
Split text
    [Arguments]   ${text}
    @{list}=   split string  ${text}
    [Return]   ${list}

#Get first the ping result to see more clearly how it looks like
*** Test Cases ***

Read the webpages.txt information into a variable
   ${output}=   Get file  ${path}
   set global variable   ${output}
   
Ping each address found in the text file
   @{list}=   Split text   ${output}
   FOR   ${WEBPAGE}   IN   @{list}
      ${output}=   Run and return rc and output   ping ${WEBPAGE}
      ${resultList}=   Split text   ${output}[1]
   END

#Improve the testcases based on the result above
*** Test Cases ***

Read the webpages.txt information into a variable
   #Get webpages for pings
   ${webpages}=   Get file  ${path}
   set global variable   ${webpages}
   
Ping each address found in the text file
   #Get the webpages in list format, by splitting the string which contains the webpages
   @{list}=   Split text   ${webpages}
   
   #Create a(n empty) text file where we write out information about of the pings
   Touch  ./result.txt
   
   #Loop through on each website the list contains
   FOR   ${WEBPAGE}   IN   @{list}
      
      #First add the webpage itself to the text file (\n is needed to get the next string we want to write out into a new line)
      Append to file  ./result.txt   ${WEBPAGE} \n
      
      #Make ping 
      @{output}=   Run and return rc and output   ping ${WEBPAGE}
      
      #According to the log output at this stage contains a 0 and a list about the outcome of the ping, and we want to get that so we need to use index 1 ([1])
      @{resultList}=   Split text   ${output}[1]
      
      #Get the index of from in order to get later the IP according to the result
      ${INDEX1}=   Get index from list   ${resultList}   from
      
      #Since the ip comes after the "from" (check the output of the previous cell) we need to increase the index of "from" by 1
      ${INDEX1}=   evaluate   ${INDEX1}+1
      
      #Get IP using the index from above
      ${IP}=   Set variable   ${resultList}[${INDEX1}]
      
      #Remove the : from the end of the IP
      ${IP}=   remove string   ${IP}   :
      
      #Create a string which includes the IP and can be inserted to the text file
      ${IPResult}=  set variable   IP is ${IP}
      
      #Add the result to the text file
      Append to file  ./result.txt   ${IPResult} \n
      
      
      #Get the index of Average to be able to find the actual value of it
      ${INDEX2}=   Get index from list   ${resultList}   Average
      
      #We have to increase the index by two in order to get time
      ${INDEX2}=   evaluate   ${INDEX2}+2
      ${avgTime}=   set variable   ${resultList}[${INDEX2}]
      ${avgResult}=  set variable   Average time is ${avgTime}
      Append to file  ./result.txt   ${avgResult} ${\n}
      
      #Convert the result to a numeric value: first remove unwanted character then convert it to number
      ${avgTime}=   remove string   ${avgTime}   ms
      ${avgTime}=   Convert to number   ${avgTime}
      
      #Compare the average time to 50
      Should be true  ${avgTime} < 50  
   END 