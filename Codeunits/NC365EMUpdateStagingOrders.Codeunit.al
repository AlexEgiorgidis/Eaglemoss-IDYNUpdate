codeunit 58102 "NC365 EM Update Staging Orders"
{
    Access = Internal;

    trigger OnRun()
    var
        NC365StagingOrderHeader: Record "NC365 Staging Order Header";
        NC365SalesOrderAPI: Codeunit "NC365 Sales Order API";
        FinishedNotification: Notification;
        NoOfOrders: Integer;
        FinishedMsg: Label 'Updated %1 staging order(s) from Magento.', Comment = '%1=No. of orders';
        UpdatingMsg: Label 'Updating staging orders';
    begin
        NC365StagingOrderHeader.SetFilter(Status, '<>complete&<>canceled');
        if NC365StagingOrderHeader.FindSet() then begin
            NC365Stopwatch.Start();

            NoOfOrders := NC365StagingOrderHeader.Count();

            repeat
                NC365SalesOrderAPI.UpdateStagingOrder(NC365StagingOrderHeader);
            until NC365StagingOrderHeader.Next() = 0;

            NC365Stopwatch.Stop();
            NC365Log.ApplicationEvent(UpdatingMsg, Format(NoOfOrders), NC365Stopwatch.ElapsedMilliseconds());
        end;

        if GuiAllowed() then begin
            FinishedNotification.Message := StrSubstNo(FinishedMsg, NoOfOrders);
            FinishedNotification.Scope := NotificationScope::LocalScope;
            FinishedNotification.Send();
        end;
    end;

    var
        NC365Stopwatch: Codeunit "NC365 Stopwatch";
        NC365Log: Codeunit "NC365 Log";
}
