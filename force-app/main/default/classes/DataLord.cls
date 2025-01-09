public with sharing class DataLord {
    public DataLord() {

    }

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
}