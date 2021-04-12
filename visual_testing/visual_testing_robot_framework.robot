*** Settings ***
Library   SeleniumLibrary
Library   OperatingSystem

*** Variables ***
${OriginalShotDir}   original/
#Define name for directory where the screenshot will be stored
${TestShotDir}   test

*** Test Cases ***
Open the browser and accept cookies
   Open browser   https://www.sueddeutsche.de/
   Maximize browser window
   # Wait to load the page
   Page should contain   Zeitung
   Wait until element is visible   xpath:/html/body/div[7]/iframe
   Select frame   xpath:/html/body/div[7]/iframe
   # Click Accept button for cookies
   Click element   xpath:/html/body/div/div[2]/div[3]/div/div/button[1]
   Unselect frame 

*** Test Cases ***
Create directory to store screenshot
   # Create directory to store screenshot if it is not exists
   Create directory   ${TestShotDir}
Take screenshot from the Süddeutsche Zeitung element and save it to make modification on that
   Set screenshot directory   ${TestShotDir}
   # Delete all content of the given directory
   Empty directory   ${TestShotDir}
   Capture element screenshot   css:html body.homepage header#szde.sz-header div.sz-header-logo h1#header-logo-img.product-title.sz-header-logo--desktop a.product-link svg

*** Test Cases ***
Compare elements using magick
   #Set path for where the screenshot is located and where the result of the comparison will we saved
   ${path}=   set variable   ${TestShotDir}/
   
   # Compare images and get store the result into and variable - will be an array
   ${diffvalue}=   Run and return rc and output   magick ${OriginalShotDir}Original_element.png ${path}selenium-element-screenshot-1.png -metric RMSE -compare -format "%[distortion]" info:
   
   # Select the second item from the list to get the value of the difference
   ${diffvalue}=   set variable   ${diffvalue}[1]
   
   # If the value is more, than zero it means there is difference and we use (again) magick to detect the differences and save a picture which highlights the differences
   Run keyword if   ${diffvalue}>0   run   magick ${OriginalShotDir}Original_element.png ${path}selenium-element-screenshot-1.png -metric RMSE -compare ${path}difference.png

*** Test Cases ***
Compare css properties of elements
   # Create variables for the attributes to be tested
   ${attribute_color}=   set variable   color
   ${attribute_font_family}=   set variable   font-family

   # Get color and font-family for the first element
   ${first_element}=    Get webelement   xpath:/html/body/div[3]/main/section[3]/ul/li[1]/div
   ${color_of_first_element}=   Call method   ${first_element}   value_of_css_property   ${attribute_color}
   ${font_of_first_element}=   Call method   ${first_element}   value_of_css_property   ${attribute_font_family}
   
   # Count how much similar element can be found on the page   
   ${count}=  Get element count   xpath:/html/body/div[3]/main/section[3]/ul/li[*]/div
   
   # Iterate through on elements and and check if the css properties are matching with the properties of the first element
   # Since we want to compare the with the first element we start the iteration with the second element (in range 2)
   FOR   ${INDEX}  IN RANGE  2   ${count}+1   
      ${current_element}=    Get webelement   xpath:/html/body/div[3]/main/section[3]/ul/li[${INDEX}]/div
      ${color_of_current_element}=   Call method   ${current_element}   value_of_css_property   ${attribute_color}
      ${font_of_current_element}=   Call method   ${current_element}   value_of_css_property   ${attribute_font_family}
   
      Should be equal   ${color_of_first_element}   ${color_of_current_element}
      Should be equal   ${font_of_first_element}   ${font_of_current_element}
   END

*** Test Cases ***
Compare css properties of buttons
    # Get two buttons and save into a variable the css attribute to be tested
    ${first_button}=  Get webelement  xpath:/html/body/div[3]/main/section[1]/div[2]/div[3]/div/div/a[1]
    ${second_button}=  Get webelement  xpath:/html/body/div[3]/main/section[1]/div[2]/div[3]/div/div/a[2]
    ${attribute}=   set variable   background-color
    
    # Get the css property for both element and compare them
    ${bg_color_of_first_btn}=  Call method   ${first_button}   value_of_css_property   ${attribute}
    ${bg_color_of_second_btn}=  Call method   ${second_button}   value_of_css_property   ${attribute}
    Should be equal   ${bg_color_of_first_btn}   ${bg_color_of_second_btn} 

*** Test Cases ***
Compare the horizontal position of images with class=sz-teaser__image sz-teaser__image--s lazyloaded
   # Make sure the window has been loaded
   Page should contain   Zeitung
   #${first_image_horizontal_position}=   Get horizontal position   xpath:/html/body/div[3]/main/section[1]/div[1]/div/div[4]/a/div/div[1]/picture/img
   
   # Get all elements with the required classname mentioned in the task description
   ${images}=   Get webelements   xpath:/html/body/div[3]/main/section[1]/div[1]/div/div[*]/a/div/div[1]/picture/img
   
   # Get horizontal position of first image
   ${first_image_horizontal_position}=   Get horizontal position   ${images}[0]
   
   # Get how much similar element are there to get to knoww how many times we have to repeat the for loop
   ${count}=   Get length   ${images}
   FOR   ${INDEX}   IN RANGE  1  ${count}
      ${current_image_horizontal_position}=   Get horizontal position    ${images}[${INDEX}]
      Should be equal   ${first_image_horizontal_position}   ${current_image_horizontal_position}
   END