page 58101 "IDYN Staging List"
{

    ApplicationArea = All;
    Caption = 'IDYN Staging List';
    PageType = List;
    SourceTable = "IDYN Staging";
    UsageCategory = Administration;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Process Record"; Rec."Process Record")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Magento Entry"; Rec."Magento Entry")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Local SKU"; Rec."Local SKU")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            Action(Import)
            {
                Caption = 'Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    UpdateItemID: codeunit "UpdateItemID-IDYN";
                begin
                    Clear(UpdateItemID);
                    if UpdateItemID.ReadFile() then
                        Message(ProcessCompletedLbl);
                end;
            }
            Action(Process)
            {
                Caption = 'Process';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    UpdateItemID: codeunit "UpdateItemID-IDYN";
                begin
                    clear(UpdateItemID);
                    if UpdateItemID.ProcessRecords() then
                        message(ProcessCompletedLbl);
                    CurrPage.Update();
                end;
            }
            Action("Select All")
            {
                Caption = 'Select All';
                Image = Select;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if not Confirm(SelectAllConfirm, false) then
                        exit;
                    Reset();
                    ModifyAll("Process Record", true);
                    CurrPage.Update();
                end;
            }
            Action("Unselect All")
            {
                Caption = 'Unselect All';
                Image = UnApply;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if not Confirm(UnselectAllConfirm, false) then
                        exit;
                    Reset();
                    ModifyAll("Process Record", false);
                    CurrPage.Update();
                end;
            }
            Action(Delete)
            {
                Caption = 'Delete All';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if not Confirm(DeleteAllConfirm, false) then
                        exit;
                    Reset();
                    DeleteAll(true);
                end;
            }
        }
        area(Navigation)
        {

            Action("Error Log")
            {
                Caption = 'Error Log';
                Image = ErrorLog;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ErrorLogRec: record "IDYN Staging Error Log";
                    ErrorLogList: page "IDYN Staging Error List";
                begin
                    ErrorLogRec.Reset();
                    ErrorLogRec.Setrange("Entry No.", Rec."Entry No.");
                    if ErrorLogRec.FindFirst() then begin
                        Clear(ErrorLogList);
                        ErrorLogList.SetTableView(ErrorLogRec);
                        ErrorLogList.SetRecord(ErrorLogRec);
                        ErrorLogList.RunModal();
                    end;
                end;
            }
        }
    }

    var
        DeleteAllConfirm: label 'Do you want to delete all the records?';
        ProcessCompletedLbl: label 'Completed.';
        SelectAllConfirm: label 'Do you want to mark all records for processing?';
        UnselectAllConfirm: label 'Do you want to unselect all records from processing?';
}
