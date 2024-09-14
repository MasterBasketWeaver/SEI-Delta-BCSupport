pageextension 80050 "BA Service Order" extends "Service Order"
{
    layout
    {
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Bill-to Name")
        {
            field("BA Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Sell-to")
        {
            field("BA Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Ship-to Name")
        {
            field("BA Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        addlast(General)
        {
            field("BA Quote Exch. Rate"; "BA Quote Exch. Rate")
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
        modify("Order Date")
        {
            ApplicationArea = all;
            Editable = false;
            Visible = false;
        }
        addafter("Service Order Type")
        {
            field("ENC External Document No."; "ENC External Document No.")
            {
                ApplicationArea = all;
                Caption = 'External Document No.';
            }
            field("BA Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
            field("BA Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    Rec."BA Modified Posting Date" := true;
                    Rec.Modify(true);
                end;
            }
            field("BA Quote Date"; Rec."BA Quote Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Shipment Date"; Rec."BA Shipment Date")
            {
                ApplicationArea = all;
            }
            field("BA Promised Delivery Date"; "BA Promised Delivery Date")
            {
                ApplicationArea = all;
                ShowMandatory = MandatoryDeliveryDate;
            }
            field("ENC BBD Sell-To No."; Rec."ENC BBD Sell-To No.")
            {
                ApplicationArea = all;
            }
            field("ENC BBD Sell-To Name"; Rec."ENC BBD Sell-To Name")
            {
                ApplicationArea = all;
            }
            field("ENC BBD Sell-To PO No."; Rec."ENC BBD Sell-To PO No.")
            {
                ApplicationArea = all;
            }
            field("ENC BBD Contact"; Rec."ENC BBD Contact")
            {
                ApplicationArea = all;
            }
        }
        addafter("Tax Area Code")
        {
            field("BA Tax Registration No."; Rec."ENC Tax Registration No.")
            {
                ApplicationArea = all;
            }
            field("BA FID No."; Rec."ENC FID No.")
            {
                ApplicationArea = all;
            }
            field("BA EORI No."; Rec."BA EORI No.")
            {
                ApplicationArea = all;
            }
        }
        addlast("Ship-to")
        {
            field("BA Ship-To Tax Reg. No."; Rec."ENC Ship-To Tax Reg. No.")
            {
                ApplicationArea = all;
            }
            field("BA Ship-To FID No."; Rec."ENC Ship-To FID No.")
            {
                ApplicationArea = all;
            }
            field("BA Ship-to EORI No."; Rec."BA Ship-to EORI No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Document Date")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Posting Date")
        {
            ApplicationArea = all;
            Visible = false;
        }
    }


    var
        [InDataSet]
        MandatoryDeliveryDate: Boolean;




    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ExchangeRate: Record "Currency Exchange Rate";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        Subscribers: Codeunit "BA SEI Subscibers";
    begin
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."BA Use Single Currency Pricing" then
            exit;
        ServiceMgtSetup.TestField("BA Single Price Currency");
        if Subscribers.GetExchangeRate(ExchangeRate, ServiceMgtSetup."BA Single Price Currency") then
            Rec."BA Quote Exch. Rate" := ExchangeRate."Relational Exch. Rate Amount";
    end;

    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        CurrExchRate: Record "Currency Exchange Rate";
        OldCurrFactor: Decimal;
        Customer: Record Customer;
    begin
        MandatoryDeliveryDate := Customer.Get(Rec."Bill-to Customer No.") and not Customer."BA Non-Mandatory Delivery Date";
        GetUserSetup();
        if not UserSetup."BA Service Order Open" or (UserSetup."BA Open Service Order No." <> Rec."No.") then begin
            UserSetup."BA Service Order Open" := true;
            UserSetup."BA Open Service Order No." := Rec."No.";
            UserSetup.Modify(false);
        end;

        if Rec."BA Modified Posting Date" or (Rec."Posting Date" = WorkDate()) or not CurrPage.Editable() or (Rec.Status <> Rec.Status::"In Process") then
            exit;
        OldCurrFactor := Rec."Currency Factor";
        Rec.SetHideValidationDialog(true);
        Rec."BA Skip Sales Line Recreate" := true;
        if (Rec."Currency Code" <> '') and (Rec."Currency Factor" = 0) then
            if Rec."BA Quote Exch. Rate" <> 0 then
                Rec."Currency Factor" := 1 / Rec."BA Quote Exch. Rate"
            else
                Rec."Currency Factor" := CurrExchRate.GetCurrentCurrencyFactor(Rec."Currency Code");
        Rec.Validate("Posting Date", WorkDate());
        if (Rec."Currency Code" <> '') and (Rec."Currency Factor" = 0) then
            Rec.Validate("Currency Factor", CurrExchRate.GetCurrentCurrencyFactor(Rec."Currency Code"));
        Rec.SetHideValidationDialog(false);
        Rec."BA Skip Sales Line Recreate" := false;
        Rec.Modify(true);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetUserSetup();
        if UserSetup."BA Service Order Open" then begin
            UserSetup."BA Service Order Open" := false;
            UserSetup."BA Open Service Order No." := '';
            UserSetup.Modify(false);
        end;
    end;

    local procedure GetUserSetup()
    begin
        if not UserSetup.Get(UserId()) then begin
            UserSetup.Init();
            UserSetup.Validate("User ID", UserId());
            UserSetup.Insert(false);
        end;
    end;

    var
        UserSetup: Record "User Setup";
}