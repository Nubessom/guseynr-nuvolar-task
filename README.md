* Download Repository
    git clone https://github.com/Nubessom/guseynr-nuvolar-task
    cd guseynr-nuvolar-task
* Create Scratch Org
   sf org create scratch --definition-file config/project-scratch-def.json --alias MyScratchOrg
* Push Source to Scratch Org
   sf project start deploy
* Open Scratch Org
    sf org open
* Data Upload
    1. In "data" folder locate iata-icao.csv file, that was used to generate airport data for this exercise.
    2. In Scratch org From Setup navigate to Data Import Wizard
    3. Use csv file to create new records.
    4. Object should be NVLR_Airport__c.
    5. Fields mapping (CSV (left) To Object(right)):
        country_code -> Country Code
        iata -> IATA Code
        airport -> Airport Name
        region -> Region
        location -> Location
    6. Validate Records Created
* Navigate to the Sales Applications Home Page
    After your scratch org opens in your browser, use the App Launcher to navigate to the "Sales Applications" app.
    Here, you should find the Create_a_Flight Flexipage. LWC component named nvlr_createFlightForm should be visible on this page.
