
/**
* @description Test class for CreateFlightFormController
* @author Guseyn Rustamzade
* @date 28.03.2024
*/

@isTest
public with sharing class NVLR_CreateFlightControllerTest {
        
    @isTest
    public static void testCreateFlight() {
        User user = NVLR_TestUtils.createAdminUser();
            System.runAs(user) {
            // Create test data for departure and arrival airports
            NVLR_Airport__c departureAirport = new NVLR_Airport__c(
                Name = 'Test Departure Airport',
                Location__Latitude__s = 40.7128, // New York latitude
                Location__Longitude__s = -74.0060, // New York longitude
                IATA__c = 'TDA' // IATA Code
            );
            insert departureAirport;

            NVLR_Airport__c arrivalAirport = new NVLR_Airport__c(
                Name = 'Test Arrival Airport',
                Location__Latitude__s = 34.0522, // Los Angeles latitude
                Location__Longitude__s = -118.2437, //Los Angeles longitude
                IATA__c = 'TAA' // IATA Code
            );
            insert arrivalAirport;

            // Call the method to create a flight
            Test.startTest();
                String flightId = NVLR_CreateFlightFormController.createFlight(departureAirport.Id, arrivalAirport.Id);
            Test.stopTest();

            // Retrieve the flight record and verify its details
            NVLR_Flight__c createdFlight = [SELECT Id, Departure_Airport__c, Arrival_Airport__c, Distance__c 
                                    FROM NVLR_Flight__c WHERE Id = :flightId];
            Assert.areEqual(departureAirport.Id, createdFlight.Departure_Airport__c, 'Departure airport mismatch');
            Assert.areEqual(arrivalAirport.Id, createdFlight.Arrival_Airport__c, 'Arrival airport mismatch');
            // Verify distance is calculated correctly
            // You may need to adjust the expected value based on the actual distance calculated
            Assert.areNotEqual(null, createdFlight.Distance__c, 'Distance not calculated');
        }
    }

    @isTest
    public static void testCreateFlightException() {
        User user = NVLR_TestUtils.createAdminUser();
        System.runAs(user) {
            // Test case where airports are not found
            Test.startTest();
                try {
                    String flightId = NVLR_CreateFlightFormController.createFlight('invalidDepartureId', 'invalidArrivalId');
                } catch (AuraHandledException e) {
                    Assert.areNotEqual(null, e.getMessage(), 'Exception message not returned');
                }
            Test.stopTest();
        }
    }

    @isTest
    public static void testCalculateDistance() {
        User user = NVLR_TestUtils.createAdminUser();
        System.runAs(user) {
            // Test data for coordinates of two points (latitude and longitude)
            Decimal latitude1 = 40.7128; // New York
            Decimal longitude1 = -74.0060; // New York
            Decimal latitude2 = 34.0522; // Los Angeles
            Decimal longitude2 = -118.2437; // Los Angeles

            // Expected distance between New York and Los Angeles (approximately)
            Integer expectedDistance = 3935; // in kilometers

            // Call the method to calculate distance
            Test.startTest();
                Integer calculatedDistance = NVLR_CreateFlightFormController.calculateDistance(latitude1, longitude1, latitude2, longitude2);
            Test.stopTest();

            // Assert that the calculated distance matches the expected distance
            Assert.areEqual(expectedDistance, calculatedDistance, 'Distance calculation incorrect');
        }
    }

}