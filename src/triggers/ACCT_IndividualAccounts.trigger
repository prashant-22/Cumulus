/*
    Copyright (c) 2009, Salesforce.com Foundation
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Salesforce.com Foundation nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
trigger ACCT_IndividualAccounts on Contact (before insert, before update, after insert, after update,after delete) {

    npe01__Contacts_and_Orgs_Settings__c cos = CAO_Constants.getContactsSettings();
    
    if (!cos.npe01__DISABLE_IndividualAccounts_trigger__c) {
    	CAO_Constants.triggerAction ta;
        if (Trigger.isInsert && Trigger.isBefore) 
            ta = CAO_Constants.triggerAction.beforeInsert;
        else if (Trigger.isUpdate && Trigger.isBefore) 
            ta = CAO_Constants.triggerAction.beforeUpdate;
        else if (Trigger.isAfter && Trigger.isInsert ) 
            ta = CAO_Constants.triggerAction.afterInsert;
        else if (Trigger.isAfter && Trigger.isUpdate ) 
            ta = CAO_Constants.triggerAction.afterUpdate;
        else if (Trigger.isAfter && Trigger.isDelete ) 
            ta = CAO_Constants.triggerAction.afterDelete;

        //ceiroa: I had to add this here because this trigger has not yet been converted into the TDTM design, and
        //I need to test the error handler. This trigger was throwing the first exception.
        try {
            ACCT_IndividualAccounts process = new ACCT_IndividualAccounts(Trigger.new, Trigger.old, ta);
        } catch(Exception e) {
        	System.debug('****Catching exception in ACCT_IndividualAccounts trigger');
        	ERR_Handler.saveError(e);
        	//throw e; //@TODO: should we re-throw it to notify the user throwugh the UI? If we do that
        	//the error won't be saved to the database... an automatic rollback will occur 
        }
    }        
}