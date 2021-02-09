codeunit 58101 "UpdateItemID-IDYN"
{



    procedure ReadFile(): Boolean
    var
        TempExcelBuffer: record "Excel Buffer" temporary;
        TempCSVBuffer: record "CSV Buffer" temporary;
        IDYNStaging: record "IDYN Staging";
        RowNo: Integer;
        FileName: Text;
        NVInStream: InStream;
        Sheetname: Text;
        DialogCaption: Label 'Select File to import';
        HasHeadersQst: label '&Have Header,&Doesnt have header';
        Selection: integer;
        TmpSheetName: text;
    begin
        Clear(TempExcelBuffer);
        Clear(TempCSVBuffer);
        If not UploadIntoStream(DialogCaption, '', 'Excel Files (*.xlsx)|*.xlsx|csv Files (*.csv)|*.csv', FileName, NVInStream) then
            exit(false);

        If FileName = '' then
            Exit(false);

        if not (StrPos(FileName, '.csv') > 0) then begin
            Sheetname := TempExcelBuffer.SelectSheetsNameStream(NVInStream);
            TempExcelBuffer.Reset();
            TempExcelBuffer.OpenBookStream(NVInStream, Sheetname);
            TempExcelBuffer.ReadSheet();
            //assumptions:
            //1. the first column is the "Local SKU"
            //2. the second column is the "SKU" or "Item No." available in BC
            //3. the third column is the "Magento ID"
            TempExcelBuffer.Reset();
            Selection := STRMENU(HasHeadersQst, 1);
            if Selection = 1 then
                TempExcelBuffer.SetFilter("Row No.", '>1');
            if TempExcelBuffer.FindSet(false, false) then begin
                repeat
                    case TempExcelBuffer."Column No." of
                        1:
                            begin
                                IDYNStaging.Init();
                                IDYNStaging."Entry No." := IDYNStaging.GetNextLineNo();
                                IDYNStaging."Local SKU" := TempExcelBuffer."Cell Value as Text";
                            end;
                        2:
                            begin
                                IDYNStaging."Item No." := TempExcelBuffer."Cell Value as Text";
                            end;
                        3:
                            begin
                                IDYNStaging."Magento Entry" := TempExcelBuffer."Cell Value as Text";
                                IDYNStaging."Process Record" := true;
                                IDYNStaging.Insert(true);
                            end;
                    end;
                until TempExcelBuffer.Next() = 0;
                exit(true);
            end;
        end else begin
            TempCSVBuffer.LoadDataFromStream(NVInStream, ',');
            //assumptions:
            //1. the first column is the "Local SKU"
            //2. the second column is the "SKU" or "Item No." available in BC
            //3. the third column is the "Magento ID"
            TempCSVBuffer.Reset();
            Selection := STRMENU(HasHeadersQst, 1);
            if Selection = 1 then
                TempCSVBuffer.SetFilter("Line No.", '>1');
            if TempCSVBuffer.FindSet(false, false) then begin
                repeat
                    case TempCSVBuffer."Field No." of
                        1:
                            begin
                                IDYNStaging.Init();
                                IDYNStaging."Entry No." := IDYNStaging.GetNextLineNo();
                                IDYNStaging."Local SKU" := TempCSVBuffer.Value;
                            end;
                        2:
                            begin
                                IDYNStaging."Item No." := TempCSVBuffer.Value;
                            end;
                        3:
                            begin
                                IDYNStaging."Magento Entry" := TempCSVBuffer.Value;
                                IDYNStaging."Process Record" := true;
                                IDYNStaging.Insert(true);
                            end;
                    end;
                until TempCSVBuffer.Next() = 0;
                exit(true);
            end;
        end;
        exit(false);
    end;


    procedure ProcessRecords(): Boolean
    var
        NC365ItemRec: record "NC365 Item";
        IDYNStaging: record "IDYN Staging";
        ItemRec: record Item;
        ItemDoesNotExist: label 'Item %1 can not be found in %2.';
    begin
        IDYNStaging.Reset();
        IDYNStaging.Setrange("Process Record", true);
        if IDYNStaging.FindSet(true, false) then begin
            repeat
                NC365ItemRec.Reset();
                NC365ItemRec.SetRange("No.", IDYNStaging."Item No."); //local sku or Item No.
                if NC365ItemRec.FindSet(true, false) then begin
                    repeat
                        if ItemRec.Get(IDYNStaging."Item No.") then begin
                            NC365ItemRec.Validate("Magento ID", IDYNStaging."Magento Entry");
                            NC365ItemRec.Modify(true);
                            IDYNStaging.Success := true;
                            IDYNStaging.Modify(false);
                        end else
                            WriteErrorLog(IDYNStaging, StrSubstNo(ItemDoesNotExist, IDYNStaging."Item No.", ItemRec.TableCaption));
                    until NC365ItemRec.Next() = 0;
                end else begin
                    WriteErrorLog(IDYNStaging, StrSubstNo(ItemDoesNotExist, IDYNStaging."Item No.", NC365ItemRec.TableCaption));
                end;
            until IDYNStaging.Next() = 0;
        end;
        IDYNStaging.Reset();
        IDYNStaging.Setrange(Success, true);
        IDYNStaging.DeleteAll(false);
    end;

    procedure WriteErrorLog(p_IDYNStaging: record "IDYN Staging"; p_ErrorText: text)
    var
        ErrorLog: record "IDYN Staging Error Log";
    begin
        ErrorLog.Init();
        ErrorLog.TransferFields(p_IDYNStaging);
        ErrorLog."Error Text" := p_ErrorText;
        if not ErrorLog.Insert(true) then
            ErrorLog.Modify(true);
    end;
}
