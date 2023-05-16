*** Settings ***
Documentation       An Assistant Robot.

Library             OperatingSystem
Library             RPA.Assistant
Library             RPA.Windows
Library    Process
Library    RPA.Tasks


*** Tasks ***
Main
    [Documentation]
    ...    The Main task running the Assistant.
    ...    Inserts inputs from the dialog box into notepad.exe.
    ...    If Notepad is not open, it will first launch notepad.exe.
    ...    The bot will run until the button 'Stop' is pushed.
    ...    TODO: Put the but inside a While Loop or something to keep it running after
    ...    and Input has been given

    Display Main Menu
    ${result}=    RPA.Assistant.Run Dialog
    ...    title=Assistant Template
    ...    on_top=True
    ...    height=450
    
    IF    '${result.submit}' == 'Stop'    Pass Execution    Button 'Stop' was pushed

    ${status}    Run Keyword And Return Status    Control Window    executable:Notepad.exe
    IF    ${status} == ${False}    Launch App    Notepad.exe
    Send Keys    keys=${result.text_input}
    Log    message


*** Keywords ***
Display Main Menu
    [Documentation]
    ...    Main UI of the bot. We use this to get our user input.

    Clear Dialog
    Add Heading    Assistant Tutorial
    Add Text Input    text_input    Insert Case Order
    Add Submit Buttons    Submit
    Add Submit Buttons    Stop
Launch App
    [Arguments]    ${executable}
    Windows Run    ${executable}