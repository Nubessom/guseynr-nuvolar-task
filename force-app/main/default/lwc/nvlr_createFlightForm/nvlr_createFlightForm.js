import { LightningElement } from "lwc";
import FLIGHT_OBJECT from "@salesforce/schema/NVLR_Flight__c";
import AIRPORT_OBJECT from "@salesforce/schema/NVLR_Airport__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import DEPARTURE_FIELD from "@salesforce/schema/NVLR_Flight__c.Departure_Airport__c";
import ARRIVAL_FIELD from "@salesforce/schema/NVLR_Flight__c.Arrival_Airport__c";
import DISTANCE_FIELD from "@salesforce/schema/NVLR_Flight__c.Distance__c";
import createFlight from "@salesforce/apex/NVLR_CreateFlightFormController.createFlight";

export default class CreateFlightForm extends LightningElement {

    objectApiName = FLIGHT_OBJECT;
    airportObjectApiName = AIRPORT_OBJECT;
    departureField = DEPARTURE_FIELD;
    arrivalField = ARRIVAL_FIELD;
    distanceField = DISTANCE_FIELD;
    flightId;
    // Store selected Ids
    departureId;
    arrivalId;
    // Visibility variables
    showSpinner;
    flightCreated;

    get cardHeader() {
        return this.flightCreated ? 'Flight Created' : 'Create Flight';
    }


    matchingInfo = {
        primaryField: { fieldPath: 'IATA__c' },
        additionalFields: [{ fieldPath: 'Name' }],
    };

    displayInfo = {
        primaryField: 'Name',
        additionalFields: ['IATA__c'],
    };

    handleDepartureChange(event) {
        this.departureId = event.detail.recordId;
    }

    handleArrivalChange(event) {
        this.arrivalId = event.detail.recordId;
    }

    handleSave(event) {
        this.showSpinner = true;
        createFlight({ departureId: this.departureId, arrivalId: this.arrivalId })
            .then((result) => {
                this.flightId = result;
                this.flightCreated = true;
                this.showSpinner = false;
            })
            .catch((error) => {
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: 'Error while creating flight. Please try again.',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            })
            .finally(() => {
                this.showSpinner = false;
            });
    }
}