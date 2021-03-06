@SmokeTestFeature
Feature: API Contacts v2 Contact Page

  Background:
    Given let variable "basePath" equal to "/v2/contacts"
    Given overwrite header Authorization with value "Bearer {(token)}"

@testing
    Scenario: Successful login
      Given request body from static file "contactsModulePage/requests/login.json"
      And content type is "application/json"
      When the client performs POST request on "login"
      Then let variable "token" equal to property "access_token" value
      Then status code is 200
  
@testing
    Scenario: Get all contact information
      When the client performs GET request on "{(basePath)}"
      And content type is "application/json"
      Then status code is 200
      And response is not empty

@testing
    Scenario: Export contact 
      When the client performs POST request on "{(basePath)}/export/contacts"
      And content type is "application/json"
      Then status code is 202
      And response is not empty
      
@testing
    Scenario: Export contact label
      When the client performs POST request on "{(basePath)}/export/labels"
      And content type is "application/json"
      Then status code is 202
      And response is not empty

@testing
    Scenario: Get all contact information with filters
      When the client performs GET request on "{(basePath)}?include=interactions&sort=-interactions.interaction_at&filter[interactions.interaction_type][in]=9,10"
      And content type is "application/json"
      Then status code is 200
      And response is not empty

@testing
Scenario: Create, update, show and delete Contact
	Given request body from static file "contactsModulePage/requests/createContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}"
    Then status code is 201
    And response is not empty
    And let variable "contactID" equal to property "data.id" value
    Given request body from static file "contactsModulePage/requests/updateContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs PATCH request on "{(basePath)}/{(contactID)}"
    Then status code is 200
    And response is not empty
    When the client performs GET request on "{(basePath)}/{(contactID)}" 
	Then status code is 200
	And response is not empty
    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
	Then status code is 204
	
	
@testing
Scenario: Create, send sms and delete Contact
	Given request body from static file "contactsModulePage/requests/createContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}"
    Then status code is 201
    And response is not empty
    And let variable "contactID" equal to property "data.id" value
    Given request body from static file "contactsModulePage/requests/sendSMSContact.json"
    And content type is "application/json"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}/{(contactID)}/sms"
    Then status code is 203
    And response is not empty
    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
	Then status code is 204


@testing
Scenario Outline: Create, update and delete Batch Contact
	Given request body from static file "contactsModulePage/requests/createBatchContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}/multiple-store"
    Then status code is 201
    And response is not empty
    And let variable "contactId1" equal to property "data[0].id" value
    And let variable "contactId2" equal to property "data[1].id" value
	    
    Given request body from file "contactsModulePage/requests/updateBatchContact.json" with values "<ContactId1>,<ContactId2>"
		| %contactID1% | %contactID2% |
	And content type is "application/json"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs PATCH request on "{(basePath)}/multiple-update"
    Then status code is 202
    And response is not empty
   
    Given request body from file "contactsModulePage/requests/deleteBatchContact.json" with values "<ContactId1>,<ContactId2>"
		| %contactID1% | %contactID2% |
	And content type is "application/json"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs DELETE request on "{(basePath)}"
    Then status code is 200
    And response is not empty
       Examples: 
		| ContactId1	  |ContactId2 	   |
		| {(contactId1)}  |{(contactId2)}  |
    
@testing
Scenario: Create and delete Contact Lead
	Given request body from static file "contactsModulePage/requests/createContactLead.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}"
    Then status code is 201
    And response is not empty
    And let variable "contactID" equal to property "data.id" value
    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
	Then status code is 204
	
@testing
Scenario: Create delete Contact archived
	Given request body from static file "contactsModulePage/requests/createContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}"
    Then status code is 201
    And response is not empty
    And let variable "contactID" equal to property "data.id" value
    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
	Then status code is 204
	
 @Positive @testing
Scenario: Create delete Contact permanent
	Given request body from static file "contactsModulePage/requests/createContact.json"
    And content type is "application/json"
    And header "X-Api-Override-Phone" with value "1"
    And header "x-Api-Override-Email" with value "1"
    And header "X-Partial-Record-Validation" with value "1"
    And header "X-API-PERMANENT-DELETE" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}"
    Then status code is 201
    And response is not empty
    And let variable "contactID" equal to property "data.id" value
    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
	Then status code is 204	
	
# @Positive @testing
# Scenario: Create soft Contact permanent
#	Given request body from static file "contactsModulePage/requests/createContact.json"
#    And content type is "application/json"
#    And header "X-Api-Override-Phone" with value "1"
#    And header "x-Api-Override-Email" with value "1"
#    And header "x-api-sync" with value "1"
#    And header "X-API-RESTORE" with value "1"
#    And header "cache-control" with value "no-cache"
#    And header "Accept" with value "application/vnd.api+json"
#    When the client performs POST request on "{(basePath)}"
#    Then status code is 201
#    And response is not empty
#    And let variable "contactID" equal to property "data.id" value
#    When the client performs DELETE request on "{(basePath)}/{(contactID)}" 
#	Then status code is 204	
##    When the client performs GET request on "{(basePath)}/{(contactID)}" 
##	Then a failure is expected
#    When the client performs PATCH request on "{(basePath)}/{(contactID)}" 
#	Then status code is 200	
