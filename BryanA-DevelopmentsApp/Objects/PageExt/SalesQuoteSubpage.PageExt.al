pageextension 80076 "BA Sales Quote Subpage" extends "Sales Quote Subform"
{
    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode3)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode4)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode5)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode6)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode7)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        modify(ShortcutDimCode8)
        {
            ApplicationArea = all;
            Editable = CanEditDimensions;
        }
        addafter("Total Amount Incl. VAT")
        {
            field("BA Exchange Rate"; ExchageRate)
            {
                ApplicationArea = all;
                Editable = false;
                BlankZero = true;
                ToolTip = 'Specifies the exchange rate used to calculate prices for item sales lines.';
                Caption = 'Exchange Rate';
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

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        CanEditDimensions := UserSetup.Get(UserId) and UserSetup."BA Can Edit Dimensions";
    end;

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(Rec."Document Type", rec."Document No.") then
            ExchageRate := SalesHeader."BA Quote Exch. Rate";
    end;

    procedure SetExchangeRate(NewExchangeRate: Decimal)
    begin
        ExchageRate := NewExchangeRate;
    end;

    var
        ExchageRate: Decimal;
        [InDataSet]
        CanEditDimensions: Boolean;
}