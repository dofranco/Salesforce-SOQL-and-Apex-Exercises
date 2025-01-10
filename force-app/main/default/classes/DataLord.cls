public with sharing class DataLord {
    public DataLord() {

    }

    //SOQL Challenges
    public static Integer NumAccounts(){
        return [SELECT COUNT() FROM Account];
    }

    public static Integer NumHot(){
        return [SELECT COUNT() FROM Account WHERE Rating = 'Hot'];
    }

    public static Integer NumComplex(){
        return [SELECT COUNT() FROM Account WHERE Name LIKE '%&%'];
    }

    public static List<Account> BigFive() {
        return [SELECT Name, AnnualRevenue FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 5];
    }

    public static Opportunity LastBigOpportunity() {
        return [SELECT Name, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate DESC LIMIT 1];
    }

    public static List<Contact> MajorPlayers() {
        return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Account.Rating = 'Hot'];
    }

    public static String MostPopularAccount() {
        AggregateResult result = [SELECT Account.Name, COUNT(Id) totalContacts 
                                  FROM Contact 
                                  GROUP BY Account.Name 
                                  ORDER BY COUNT(Id) DESC 
                                  LIMIT 1];
        return (String) result.get('Name');
    }

    //SOSL Challenges
    public static List<List<SObject>> findTomContactsAndLeads() {
        return [FIND 'Tom' IN NAME FIELDS RETURNING Contact(Id, FirstName, LastName), Lead(Id, FirstName, LastName)];
    }

    public static List<Account> findAccountsWithAandO() {
        List<List<SObject>> results = [FIND '*a* AND *o*' IN ALL FIELDS RETURNING Account(Name)];
        return (List<Account>) results[0];
    }

    //DML Challenges
    public static void SpawnContacts() {
        List<Contact> contactsToInsert = new List<Contact>();
    
        for (Integer i = 1; i <= 200; i++) {
            Contact newContact = new Contact(
                FirstName = 'ContactFirst' + i,
                LastName = 'ContactLast' + i
            );
            contactsToInsert.add(newContact);
        }
    
        insert contactsToInsert;
    }
    
    public static void CreateHomes() {
        List<Account> accountsToInsert = new List<Account>();
    
        for (Integer i = 1; i <= 3; i++) {
            Account newAccount = new Account(
                Name = 'HomeAccount' + i
            );
            accountsToInsert.add(newAccount);
        }
    
        insert accountsToInsert;
    }
    
    public static void Relocate() {
        List<Contact> recentContacts = [SELECT Id FROM Contact ORDER BY CreatedDate DESC LIMIT 50];
    
        delete recentContacts;
    }
    
    public static void AssignHomes() {
        // Query the 3 Accounts created in CreateHomes
        List<Account> homeAccounts = [SELECT Id FROM Account WHERE Name LIKE 'HomeAccount%' LIMIT 3];
    
        // Query all Contacts created in SpawnContacts
        List<Contact> contactsToAssign = [SELECT Id FROM Contact WHERE FirstName LIKE 'ContactFirst%' AND LastName LIKE 'ContactLast%'];
    
        // Randomly assign each Contact to one of the 3 Accounts
        for (Contact contact : contactsToAssign) {
            Integer randomIndex = Math.floor(Math.random() * homeAccounts.size()).intValue();
            contact.AccountId = homeAccounts[randomIndex].Id;
        }
    
        // Update the Contacts with their assigned Account
        update contactsToAssign;
    }    
}