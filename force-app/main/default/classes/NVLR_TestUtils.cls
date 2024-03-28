/**
* @description Test Utils class
* @author Guseyn Rustamzade
* @date 28.03.2024
*/

@isTest
public with sharing class NVLR_TestUtils {
    
    /**
    * @description Creates a new admin user with a unique username and assigns the SalesDNA_Admin permission set to the user.
    * @return The new admin user that was created.
    */
    public static User createAdminUser() {
        User u = createUser();
        insert new PermissionSetAssignment(AssigneeId = u.Id,
                                           PermissionsetId = [SELECT Id FROM PermissionSet
                                                              WHERE Name = 'NVLR_Admin' ].Id);
        return u;
    }

    /**
    * @description Creates a new  user with a unique username 
    * @return The new user that was created.
    */
    public static User createUser() {
        String username = 'nvlradmin' + System.now().getTime() + '@test' + UserInfo.getOrganizationId() + '.org';
        User u = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
                          LastName = 'last',
                          Email = username,
                          Username = username,
                          Alias = 'nvlrUser',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          EmailEncodingKey = 'UTF-8',
                          LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US');
        insert u;
        return u;
    }
}