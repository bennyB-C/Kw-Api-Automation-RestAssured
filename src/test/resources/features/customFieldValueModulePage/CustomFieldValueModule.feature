@SmokeTestFeature
Feature: API custom field value v2 

  Background:
    Given let variable "basePath" equal to "/v2/contacts"
    Given overwrite header Authorization with value "Bearer {(token)}"

@POST @testing
    Scenario: Successful login
      Given request body from static file "customFieldValueModulePage/requests/login.json"
      And content type is "application/json"
      When the client performs POST request on "login"
      Then let variable "token" equal to property "access_token" value
      Then status code is 200
  
 @GET @testing
    Scenario: Get all custom field value information
      When the client performs GET request on "{(basePath)}/custom-field-values"
      And content type is "application/json"
      Then status code is 200
      And response is not empty

 
 @Positive @testing
Scenario Outline: Create, update and delete custom Field value
	Given request body from file "customFieldValueModulePage/requests/createCustomField.json" with values "<customField>"  
		|%nameCustomField%|
    And content type is "application/json"
    And header "x-api-sync" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}/custom-fields"
    Then status code is 201
    And response is not empty
    And let variable "customFieldID" equal to property "data.id" value
    
    Given request body from file "customFieldValueModulePage/requests/createCustomFieldValue.json" with values "<customFieldValue>"  
	|%idCustomFieldValue%|
    And content type is "application/json"
    And header "x-api-sync" with value "1"
    And header "Accept" with value "application/vnd.api+json"
    When the client performs POST request on "{(basePath)}/custom-field-values"
    Then status code is 201
    And response is not empty
    And let variable "customFieldValueID" equal to property "data.id" value
    
    Given request body from file "customFieldValueModulePage/requests/updateCustomfieldValue.json" with values "<customFieldValue>"
    |%idCustomFieldValue%|
    And content type is "application/json"
    And header "x-api-sync" with value "1"
    And header "Accept" with value "application/vnd.api+json"
      When the client performs PATCH request on "{(basePath)}/custom-field-values/{(customFieldValueID)}"
    Then status code is 200
    And response is not empty
    
    When the client performs GET request on "{(basePath)}/custom-field-values/{(customFieldValueID)}"
	Then status code is 200
    And response is not empty

    When the client performs DELETE request on "{(basePath)}/custom-field-values/{(customFieldValueID)}" 
	Then status code is 204
    
	When the client performs DELETE request on "{(basePath)}/custom-fields/<customFieldValue>" 
	Then status code is 204
	    Examples: 
		| customField		        |customFieldValue  |
		| CustomFieldValueEma1  	|{(customFieldID)} |
