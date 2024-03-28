/**
 * @description Controller for the CreateFlightForm component
 * @author Guseyn Rustamzade
 * @date 28.03.2024
 */

public with sharing class NVLR_CreateFlightFormController {

    /**
    * @description Method to create a new flight record
    * @param departureId - Id of the departure airport
    * @param arrivalId - Id of the arrival airport
    */
    @AuraEnabled
    public static String createFlight(String departureId, String arrivalId) {
        try {
            List<NVLR_Airport__c> airports = [SELECT Id, Name, Location__Latitude__s, Location__Longitude__s FROM NVLR_Airport__c 
                                        WHERE Id IN :new List<String>{departureId, arrivalId} 
                                        WITH USER_MODE LIMIT 2];
            Map<Id, NVLR_Airport__c> airportMap = new Map<Id, NVLR_Airport__c>(airports);
            
            NVLR_Airport__c departureAirport = airportMap.get(departureId);
            NVLR_Airport__c arrivalAirport = airportMap.get(arrivalId);

            NVLR_Flight__c flight = new NVLR_Flight__c();
            flight.Departure_Airport__c = departureId;
            flight.Arrival_Airport__c = arrivalId;
            flight.Distance__c = calculateDistance(departureAirport.Location__Latitude__s, departureAirport.Location__Longitude__s, arrivalAirport.Location__Latitude__s, arrivalAirport.Location__Longitude__s);
            insert as user flight;
            return flight.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Method to calculate the distance between two airports
    * @param latitude1 - Latitude of the departure airport
    * @param longitude1 - Longitude of the departure airport
    * @param latitude2 - Latitude of the arrival airport
    * @param longitude2 - Longitude of the arrival airport
    * @return Integer - Distance between two airports in kilometers
    */
    @TestVisible
    private static Integer calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        // Haversine formula
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
        Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
        Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in metres
        Integer distanceInKm = distance.intValue() / 1000;
        return distanceInKm;
    }
}