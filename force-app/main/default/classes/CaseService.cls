global with sharing class CaseService {
    global static void closeCases(Set<Id> caseIds, String reason) {
        // Validate parameters
        if (caseIds == null || caseIds.size() == 0)
            throw new CaseServiceException('Cases not specified.');
        if (reason == null || reason == '')
            throw new CaseServiceException('Reason not specified.');
        // Query Cases
        List<Case> cases = [SELECT Id FROM Case WHERE Id IN :caseIds];
        // Update Cases
        List<Case> casesToUpdate = new List<Case>();
        for (Case caseObj : cases) {
            caseObj.Reason = reason;
            caseObj.Status = 'Closed';
            casesToUpdate.add(caseObj);
        }
        SavePoint sp = Database.setSavePoint();
        // Update the database
        try {
            update casesToUpdate;
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    global class CaseServiceException extends Exception {
    }
}
