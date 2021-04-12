*** Settings ***
Library   Collections
Library   String

*** Keywords ***
list contains only numbers
   [Arguments]   @{numbers}
   FOR   ${number}   IN   @{numbers}
      Should be true   isinstance(${number}, (int, float))  
   END   
sum is calculated for numbers
   [Arguments]   @{numbers} 
   ${result}=   set variable   0
   FOR   ${number}   IN   @{numbers}
      ${result}=   evaluate   ${result}+${number}
   END   
   set global variable   ${result}
get result
   [return]  ${result}

*** Test Cases ***
User wants to calculate the total of numbers
   #Define numbers for calculation - fails if list contains string value
   @{numbers}=   set variable   456.6   544   1000
   Given list contains only numbers   @{numbers}
   When sum is calculated for numbers   @{numbers} 
   Then get result 

*** Keywords ***
Calculate the sum of ${num1} and ${num2}
   Given only numbers   ${num1}  ${num2}
   When sum is calculated for numbers:   ${num1}  ${num2}
   Then print result 
only numbers
   [Arguments]   ${num1}  ${num2}
   Should be true   isinstance(${num1}, (int, float))
   Should be true   isinstance(${num2}, (int, float))
sum is calculated for numbers:
   [Arguments]   ${num1}  ${num2}
   ${result2}=   Evaluate   ${num1}+${num2}
   set global variable   ${result2}
print result
   Log   ${result2}

*** Test Cases ***
User wants to get the sum of two numbers
   [Template]   Calculate the sum of ${num1} and ${num2}
   ${1500.5}  ${3468}
   ${1}   ${-1}
   ${1.5}   two