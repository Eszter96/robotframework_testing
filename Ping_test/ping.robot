*** Settings ***
Library   String
Library   OperatingSystem
Library   Collections
Library   ./ping.py
Variables   var_ping.py

*** Test Cases ***
Read the webpages.txt information into a variable
   ${webpages}=   Get file  ${path}
   set global variable   ${webpages}
   
Ping each address found in the text file
   @{list}=   Split text   ${webpages}
   Touch  ./result.txt
   FOR   ${WEBPAGE}   IN   @{list}
      
      Append to file  ./result.txt   ${WEBPAGE} \n
      
      @{output}=   Run and return rc and output   ${PING_CMD} ${WEBPAGE}
      @{resultList}=   Split text   ${output}[1]
      @{response}=  Add To List  @{resultList}
      set global variable   ${response}
   END 
   LOG   ${response}


*** Keywords ***
Split text
    [Arguments]   ${text}
    @{list}=   split string  ${text}
    [Return]   ${list}