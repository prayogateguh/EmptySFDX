public with sharing class UnitOfWork {
    public static void createObjects() {
        // Create a Unit of Work
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{ Account.SObjectType, Contact.SObjectType, Note.SObjectType }
        );

        // Do some work!
        for (Integer o = 0; o < 100; o++) {
            Account acc = new Account();
            acc.Name = 'UoW Test Acc Name ' + o;
            uow.registerNew(acc);
            for (Integer i = 0; i < 5; i++) {
                Contact con = new Contact();
                con.FirstName = 'First';
                con.LastName = 'Last ' + i;
                uow.registerNew(con, Contact.AccountId, acc);
                Note cat = new Note();
                cat.Title = 'Catatan First Last ' + i;
                uow.registerRelationship(cat, Note.ParentId, con);
                uow.registerNew(cat);
            }
        }

        // Commit the work to the database!
        uow.commitWork();
    }
}
