pageextension 80003 "BA Assembly Order Subpage" extends "Assembly Order Subform"
{
    layout
    {
        addafter(Description)
        {
            field("BA Optional"; "BA Optional")
            {
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                Subscribers: Codeunit "BA SEI Subscibers";
            begin
                Text := Subscribers.LocationListLookup();
                exit(Text <> '');
            end;
        }
    }
}