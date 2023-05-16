*** Settings ***
Documentation       An Assistant Robot.

Library             OperatingSystem
Library             RPA.Assistant
Library             RPA.Windows
Library             Process
Library             RPA.Tasks
Library             RPA.Browser.Selenium    auto_close=${False}


*** Tasks ***
Main
    [Documentation]
    ...    The Main task running the Assistant.
    ...    Inserts inputs from the dialog box into notepad.exe.
    ...    If Notepad is not open, it will first launch notepad.exe.
    Prepare Assistant Run

    ${run}=    Set Variable    ${True}
    WHILE    ${run}
        Display Main Menu
        ${result}=    Run Dialog
        ...    timeout=1000
        ...    title=Assistant Template
        ...    on_top=False
        ...    height=450

        IF    '${result.submit}' == 'Stop'            BREAK

        Look Up Case Number Notepad    ${result}
        Look Up Case Number Chrome    ${result}
    END
    Log    Robot was stopped by user


*** Keywords ***
Prepare Assistant Run
    Open Available Browser    https://www.rpachallenge.com/
    ${res}=    Run Keyword And Return Status    Control Window    executable:Notepad.exe
    IF    ${res} == ${False}    Launch App    Notepad.exe

Display Main Menu
    [Documentation]    Main UI of the bot. We use this to get our user input.
    Clear Dialog
    Add Heading    Assistant Tutorial
    Add Text Input    text_input    Insert Case Order
    Add Submit Buttons    Submit, Stop

Launch App
    [Arguments]    ${executable}
    Windows Run    ${executable}

Look Up Case Number Notepad
    [Arguments]    ${result}
    Send Keys    executable:Notepad.exe    keys={CTRL}{a}{BACK}    wait_time=0.1
    Send Keys    executable:Notepad.exe    keys=${result.text_input}    wait_time=0.1    send_enter=True

Look Up Case Number Chrome
    [Arguments]    ${result}
    ${res}=    Is Element Visible    xpath://*[@ng-reflect-name="labelCompanyName"]
    IF    ${res} == ${False}    Go To    https://www.rpachallenge.com/
    Input Text When Element Is Visible    xpath://*[@ng-reflect-name="labelCompanyName"]    text=${result.text_input}
