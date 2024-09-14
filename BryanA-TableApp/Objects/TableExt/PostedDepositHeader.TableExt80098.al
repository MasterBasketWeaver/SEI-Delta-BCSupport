tableextension 80098 "BA Posted Deposit Header" extends "Posted Deposit Header"
{
    fields
    {
        field(80000; "BA User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
            Editable = false;
        }
        field(80100; "BA Actual Posting DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Posting DateTime';
            Editable = false;
        }
    }

    keys
    {
        key("BA Actual Posting"; "BA Actual Posting DateTime") { }
    }

    trigger OnInsert()
    begin
        Rec."BA Actual Posting DateTime" := CurrentDateTime();
    end;
}