tableextension 80024 "BA User Setup" extends "User Setup"
{
    fields
    {
        field(80000; "BA Job Title"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Title';
        }
        field(80001; "BA Allow Changing Counties"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Provinces/States';
        }
        field(80002; "BA Allow Changing Regions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Regions';
        }
        field(80003; "BA Allow Changing Countries"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Countries';
        }
        field(80004; "BA Receive Job Queue Notes."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Receive Job Queue Notifications';
        }
        field(80005; "BA Can Edit Dimensions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Can Edit Dimensions on SQ/SO';
        }
        field(80010; "BA Force Reason Code Entry"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Force Reason Code Entry';
        }
        field(80099; "BA Service Order Open"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Service Order Open';
            Editable = false;
        }
        field(80100; "BA Open Service Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Open Service Order No.';
            Editable = false;
            TableRelation = "Service Header"."No." where ("Document Type" = const (Order));
        }
    }
}