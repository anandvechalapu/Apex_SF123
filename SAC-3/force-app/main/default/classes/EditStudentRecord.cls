Apex Class
public with sharing class EditStudentRecordsController{
    @AuraEnabled
    public static void updateStudentRecord(Id studentId, String studentName, String studentGrade){
        //Perform validation
        if(studentName == null || studentName.isEmpty() || 
           studentGrade == null || studentGrade.isEmpty()){
            //Throw an exception if there is a validation error
            throw new AuraHandledException('Validation Error: Student Name and Grade must be provided');
        }
        
        //Query the Student record
        Student__c studentToUpdate = [SELECT Id, Name, Grade__c
                                     FROM Student__c 
                                     WHERE Id = :studentId];
        
        //Update the Student record with the new values
        studentToUpdate.Name = studentName;
        studentToUpdate.Grade__c = studentGrade;
        
        //Perform DML operation to update the record
        update studentToUpdate;
    }
}

Lightning Web Component
<template>
    <lightning-record-edit-form object-api-name="Student__c" record-id={studentId}>
        <lightning-input-field field-name="Name" value={studentName}></lightning-input-field>
        <lightning-input-field field-name="Grade__c" value={studentGrade}></lightning-input-field>
        <lightning-button variant="brand" type="submit" label="Save" onclick={handleSave}>
        </lightning-button>
    </lightning-record-edit-form>
</template>

import { LightningElement, api } from 'lwc';
import updateStudentRecord from '@salesforce/apex/EditStudentRecordsController.updateStudentRecord';

export default class EditStudentRecord extends LightningElement {
    @api studentId;
    studentName;
    studentGrade;

    handleSave(){
        updateStudentRecord({ studentId : this.studentId,
                              studentName : this.studentName,
                              studentGrade : this.studentGrade
                            })
        .then(() => {
            //Show user a success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Student record updated',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            //Show user an error message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record',
                    message: error.message,
                    variant: 'error'
                })
            );
        });
    }
}