pageextension 80087 "BA Phys. Inventory Jnl." extends "Phys. Inventory Journal"
{
    layout
    {
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
        addfirst(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Warning Message"; Rec."BA Warning Message")
            {
                ApplicationArea = all;
                Style = Unfavorable;
                Editable = false;
            }
        }
        addafter(Description)
        {
            field("BA Updated"; "BA Updated")
            {
                ApplicationArea = all;
                Caption = 'Year-End Inventory Adjustment';
                Editable = true;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("BA Import Item Inventory")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = PhysicalInventory;
                Caption = 'Import Item Inventory';

                trigger OnAction()
                var
                    ImportInventory: Report "BA Physical Inventory Import";
                begin
                    ImportInventory.SetParameters(Rec);
                    ImportInventory.RunModal();
                end;
            }
            action("BA Update Posting Date")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ChangeDates;
                Caption = 'Update Posting Date';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                    DateLookup: Page "BA Date Lookup";
                    Window: Dialog;
                    NewDate: Date;
                    RecCount: Integer;
                    i: Integer;
                begin
                    ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if not ItemJnlLine.FindSet() then
                        exit;
                    if (DateLookup.RunModal() <> Action::Yes) then
                        exit;
                    NewDate := DateLookup.GetDate();
                    RecCount := ItemJnlLine.Count();
                    Window.Open(DateDialog);
                    repeat
                        i += 1;
                        Window.Update(1, StrSubstNo('%1 of %2', i, RecCount));
                        ItemJnlLine.Validate("Posting Date", NewDate);
                        ItemJnlLine.Modify(true);
                    until ItemJnlLine.Next() = 0;
                    Window.Close();
                    CurrPage.Update(false);
                end;
            }
            action("BA View Import Errors")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = PhysicalInventoryLedger;
                Caption = 'View Inventory Import Errors';

                trigger OnAction()
                var
                    NameBuffer: Record "Name/Value Buffer" temporary;
                    ItemJnlLine: Record "Item Journal Line";
                    ErrorPage: Page "BA Phys. Invt. Import Errors";
                begin
                    ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ItemJnlLine.SetFilter("BA Warning Message", '<>%1', '');
                    ErrorPage.PopulateRecords(ItemJnlLine);
                    ErrorPage.RunModal();
                end;
            }
        }
    }

    var
        DateDialog: Label 'Updating\#1##';
}