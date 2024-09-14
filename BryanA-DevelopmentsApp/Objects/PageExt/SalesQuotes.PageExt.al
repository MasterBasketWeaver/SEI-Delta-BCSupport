pageextension 80120 "BA Sales Quotes" extends "Sales Quotes"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Sales Source"; Rec."BA Sales Source")
            {
                ApplicationArea = all;
            }
            field("BA Web Lead Date"; Rec."BA Web Lead Date")
            {
                ApplicationArea = all;
            }
            field("BA SEI Int'l Ref. No."; Rec."BA SEI Int'l Ref. No.")
            {
                ApplicationArea = all;
            }
            field("BA Quote Date"; Rec."BA Quote Date")
            {
                ApplicationArea = all;
            }
        }
    }
}
