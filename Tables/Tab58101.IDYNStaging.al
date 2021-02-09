table 58101 "IDYN Staging"
{
    Caption = 'IDYN Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Local SKU"; Code[20])
        {
            Caption = 'Local SKU';
            DataClassification = CustomerContent;
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(30; "Magento Entry"; Code[20])
        {
            Caption = 'Magento Entry';
            DataClassification = CustomerContent;
        }
        field(40; "Process Record"; Boolean)
        {
            Caption = 'Process Record';
            DataClassification = CustomerContent;
        }
        field(50; "Success"; Boolean)
        {
            Caption = 'Success';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetNextLineNo(): Integer
    var
        localRec: record "IDYN Staging";
    begin
        localRec.Reset();
        if localRec.FindLast() then
            exit(localRec."Entry No." + 1);
        exit(1);
    end;
}
