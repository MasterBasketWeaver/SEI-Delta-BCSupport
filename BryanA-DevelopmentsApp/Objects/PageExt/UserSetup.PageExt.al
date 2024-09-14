pageextension 80044 "BA User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Job Title"; Rec."BA Job Title")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Counties"; Rec."BA Allow Changing Counties")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Regions"; Rec."BA Allow Changing Regions")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Countries"; Rec."BA Allow Changing Countries")
            {
                ApplicationArea = all;
            }
            field("BA Receive Job Queue Notes."; Rec."BA Receive Job Queue Notes.")
            {
                ApplicationArea = all;
            }
            field("BA Can Edit Dimensions"; Rec."BA Can Edit Dimensions")
            {
                ApplicationArea = all;
                Caption = 'Can Edit Dimensions on SQ/SO';
            }
            field("BA Allow Changing TDG Cal."; Rec."BA Allow Changing TDG Cal.")
            {
                ApplicationArea = all;
            }
            field("BA Force Reason Code Entry"; Rec."BA Force Reason Code Entry")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("BA Update All Posting Dates")
            {
                ApplicationArea = all;
                Caption = 'Update All Posting Dates';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                    DateRec: Record Date;
                    DateLookup: Page "BA Date Lookup";
                    FromDate: Date;
                    ToDate: Date;
                begin
                    DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
                    DateRec.SetRange("Period Start", DMY2Date(1));
                    DateRec.FindFirst();
                    DateLookup.SetDates(DateRec."Period Start", DateRec."Period End");
                    if DateLookup.RunModal() <> Action::Yes then
                        exit;
                    DateLookup.GetDates(FromDate, ToDate);
                    if UserSetup.FindSet() then
                        repeat
                            UserSetup."Allow Posting From" := FromDate;
                            UserSetup."Allow Posting To" := ToDate;
                            UserSetup.Modify(true);
                            UserSetup.CheckAllowedPostingDates(0);
                        until UserSetup.Next() = 0;
                end;
            }
        }
    }
}