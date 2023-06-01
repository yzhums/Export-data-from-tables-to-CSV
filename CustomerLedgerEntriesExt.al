pageextension 50102 CustomerLedgerEntriesExt extends "Customer Ledger Entries"
{
    actions
    {
        addfirst(processing)
        {
            action(ExportToExt)
            {
                Caption = 'Export Items via TextBuilder';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Image = Export;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    InS: InStream;
                    OutS: OutStream;
                    FileName: Text;
                    TxtBuilder: TextBuilder;
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    FileName := 'TestCSVFile_' + UserId + '_' + Format(CurrentDateTime) + '.csv';
                    TxtBuilder.AppendLine('Posting Date' + ',' + 'Document Type' + ',' + 'Document No.' + ',' + 'Customer No.' + ',' + 'Amount(LCY)');
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetAutoCalcFields("Amount (LCY)");
                    if CustLedgerEntry.FindSet() then
                        repeat
                            TxtBuilder.AppendLine(AddDoubleQuotes(Format(CustLedgerEntry."Posting Date")) + ',' + AddDoubleQuotes(Format(CustLedgerEntry."Document Type")) + ',' +
                                                     AddDoubleQuotes(CustLedgerEntry."Document No.") + ',' + AddDoubleQuotes(CustLedgerEntry."Customer No.") + ',' +
                                                        AddDoubleQuotes(Format(CustLedgerEntry."Amount (LCY)")));
                        until CustLedgerEntry.Next() = 0;
                    TempBlob.CreateOutStream(OutS);
                    OutS.WriteText(TxtBuilder.ToText());
                    TempBlob.CreateInStream(InS);
                    DownloadFromStream(InS, '', '', '', FileName);
                end;
            }
        }
    }

    local procedure AddDoubleQuotes(FieldValue: Text): Text
    begin
        exit('"' + FieldValue + '"');
    end;
}
