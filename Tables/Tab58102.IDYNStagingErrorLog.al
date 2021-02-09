table 58102 "IDYN Staging Error Log"
{
    Caption = 'IDYN Staging Error Log';
    DataClassification = ToBeClassified;
    DrillDownPageId = "IDYN Staging Error List";
    LookupPageId = "IDYN Staging Error List";

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
        field(100; "Error Text"; text[250])
        {
            Caption = 'Error Text';
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

}
