page 58102 "IDYN Staging Error List"
{
    Caption = 'IDYN Staging Error List';
    PageType = List;
    SourceTable = "IDYN Staging Error Log";
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Local SKU"; Rec."Local SKU")
                {
                    ApplicationArea = All;
                }
                field("Magento Entry"; Rec."Magento Entry")
                {
                    ApplicationArea = All;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
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
    }
    var
        DeleteAllConfirm: label 'Do you want to delete all the records?';
}
