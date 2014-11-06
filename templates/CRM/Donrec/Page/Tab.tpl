{*-------------------------------------------------------+
| SYSTOPIA Donation Receipts Extension                   |
| Copyright (C) 2013-2014 SYSTOPIA                       |
| Author: N.Bochan (bochan -at- systopia.de)             |
| http://www.systopia.de/                                |
+--------------------------------------------------------+
| TODO: License                                          |
+--------------------------------------------------------*}

<div class="action-link">
  {if $can_create_withdraw }
    <a accesskey="N" href="{crmURL p='civicrm/donrec/create' q="cid=$cid" h=0}" class="button"><span><div class="icon add-icon"></div>{ts}Create new donation receipt{/ts}</span></a>
  {/if}
</div>
<div class="donrec-stats-block">
  <table>
    {foreach from=$display_receipts key=receipt_id item=receipt name=receipt_items}
    <tr class="{if $smarty.foreach.receipt_items.index % 2 == 0}even{else}odd{/if}">
      <td>
        <div class="donrec-stats" name="donrec_stats_{$receipt_id}">
          <ul>
            <li><u><b>
              {if $receipt.type eq 'BULK'}{ts}bulk receipt{/ts}{/if}
              {if $receipt.type eq 'SINGLE'}{ts}single receipt{/ts}{/if}
            </b></u></li>
            <li>{ts}Status{/ts}: <b>
              {if $receipt.status eq 'WITHDRAWN'}{ts}withdrawn{/ts}{/if}
              {if $receipt.status eq 'ORIGINAL'}{ts}original{/ts}{/if}
              {if $receipt.status eq 'COPY'}{ts}copy{/ts}{/if}
              {if $receipt.status eq 'WITHDRAWN_COPY'}{ts}withdrawn copy{/ts}{/if}
            </b></li>
            <li>{ts}Creation date{/ts}: {$receipt.issued_on|date_format:"%d.%m.%Y"}</li>
            <li>{ts}Date{/ts}: {$receipt.date_from|date_format:"%d.%m.%Y"} {if $receipt.date_to neq $receipt.date_from} - {$receipt.date_to|date_format:"%d.%m.%Y"}{/if}</li>
            <li>{ts}Total amount{/ts}: {$receipt.total_amount} {$receipt.currency}</li>
            <li><a id="details_receipt_{$receipt_id}"><span><div class="icon details-icon"></div>{ts}Details{/ts}</span></a></li>
          </ul>
        </div>
        <div id="donrec_details_block_{$receipt_id}" class="donrec-details-block">
          <table>
            <tr>
              <td>
                <ul class="donrec-details">
                  <li><b>{ts}Issued To{/ts}</b></li>
                  <li>{ts}Name{/ts}: TODO</li>
                  <li>{ts}Postal Code{/ts}: TODO</li>
                  <li>{ts}Street{/ts}: {$receipt.receipt_address.street_address}</li>
                  <li>{ts}City{/ts}: {$receipt.receipt_address.city}</li>
                  <li>{ts}Country{/ts}: {$receipt.receipt_address.country}</li>
                </ul>
              </td>
              <td>
                <ul class="donrec-details">
                  <li><b>{ts}Current Address{/ts}</b></li>
                  <li>{ts}Name{/ts}: TODO</li>
                  <li>{ts}Postal Code{/ts}: TODO</li>
                  <li>{ts}Street{/ts}: {$receipt.contact_address.street_address}</li>
                  <li>{ts}City{/ts}: {$receipt.contact_address.city}</li>
                  <li>{ts}Country{/ts}: {$receipt.contact_address.country}</li>
                </ul>
              </td>
            </tr>
          </table>
          <table>
            <thead>
              <tr>
                <td><b>{ts}Contributions{/ts}</b></td>
              </tr>
              <tr>
                <td><b>{ts}Total Amount{/ts}</b></td>
                <td><b>{ts}Received Date{/ts}</b></td>
                <td><b>{ts}Financial Type{/ts}</b></td>
              </tr>
            </thead>
            <tbody>
              {foreach from=$receipt.lines key=id item=item}
              <tr>
                <td>{$item.total_amount|crmMoney}</td>
                <td>{$item.receive_date}</td>
                <td>{$item.type}</td>
              </tr>
              {/foreach}
            </tbody>
          </table>
        </div>
      </td>
      <td>
        {if $can_view_copy}
          {if $receipt.view_url}
            <a href="{$receipt.view_url}" class="button"><span><div class="icon details-icon"></div>{ts}Download{/ts}</span></a>
          {else}
            <a id="view_receipt_{$receipt_id}" class="button"><span><div class="icon details-icon"></div>{ts}View{/ts}</span></a>
          {/if}
        {/if}
        {if $receipt.status == 'ORIGINAL' && $can_view_copy}
          <a id="copy_receipt_{$receipt_id}" class="button"><span><div class="icon add-icon"></div>{ts}Create copy{/ts}</span></a>
        {/if}
        {if $receipt.status == 'ORIGINAL' && $can_create_withdraw}
          <a id="withdraw_receipt_{$receipt_id}" class="button"><span><div class="icon back-icon"></div>{ts}Withdraw{/ts}</span></a>
        {/if}
        {if $can_delete}
          <a id="delete_receipt_{$receipt_id}" class="button"><span><div class="icon delete-icon"></div>{ts}Delete{/ts}</span></a>
        {/if}

        {*ALTERNATIVELY: CiviCRM List style: if $receipt.original_file}
          <a id="view_receipt_{$receipt_id}" title="{ts}View{/ts}" class="action-item action-item-first" href="{$receipt.original_file}">{ts}View{/ts}</a>
        {else}
          <a id="view_receipt_{$receipt_id}" title="{ts}View{/ts}" class="action-item action-item-first" href="#">{ts}View{/ts}</a>
        {/if}
        {if $receipt.status == 'ORIGINAL' && $can_view_copy}
          <a id="copy_receipt_{$receipt_id}" title="{ts}Create copy{/ts}" class="action-item" href="#">{ts}Create copy{/ts}</a>
        {/if}
        {if $can_create_withdraw}
          <a id="withdraw_receipt_{$receipt_id}" title="{ts}Withdraw{/ts}" class="action-item" href="#">{ts}Withdraw{/ts}</a>
        {/if}
        {if $can_delete}
          <a id="delete_receipt_{$receipt_id}" title="{ts}Delete{/ts}" class="action-item" href="#">{ts}Delete{/ts}</a>
        {/if*}
      </td>
    </tr>
    <tr class="even" id="donrec_details_block_{$receipt_id}_1" style="display: none;">
      <td>
        <div class="crm-clear crm-inline-block-content">
              <div class="crm-edit-help"><div class="icon user-record-icon"></div>{ts}Issued To{/ts}</div>

              <div class="crm-summary-row">
                <div class="crm-label">{ts}Name{/ts}</div>
                <div class="crm-content">Maxwell</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Postal Code{/ts}</div>
                <div class="crm-content">Patternman</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Street{/ts}</div>
                <div class="crm-content">1600 Amphitheatre Parkway</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}City{/ts}</div>
                <div class="crm-content">Mountain View, CA 94043</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Country{/ts}</div>
                <div class="crm-content">United States of America</div>
              </div>
        </div>
      </td>
      <td>
        <div class="crm-clear crm-inline-block-content">
              <div class="crm-edit-help"><div class="icon dashboard-icon"></div>{ts}Current Address{/ts}</div>

              <div class="crm-summary-row">
                <div class="crm-label">{ts}Name{/ts}</div>
                <div class="crm-content">Maxwell</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Postal Code{/ts}</div>
                <div class="crm-content">Patternman</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Street{/ts}</div>
                <div class="crm-content">Todostraße 10</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}City{/ts}</div>
                <div class="crm-content">53111 Bonn</div>
              </div>
              <div class="crm-summary-row">
                <div class="crm-label">{ts}Country{/ts}</div>
                <div class="crm-content">Germany</div>
              </div>
        </div>
      </td>
    </tr>
    <tr class="even" id="donrec_details_block_{$receipt_id}_2" style="display: none;">
      <td colspan="2">
        <div class="crm-clear crm-inline-block-content">
              <div class="crm-edit-help"><div class="icon search-icon"></div>{ts}Contributions{/ts}</div>
              <div>
                <table>
                  <thead>
                    <tr>
                      <td>{ts}Total Amount{/ts}</td>
                      <td>{ts}Received Date{/ts}</td>
                      <td>{ts}Financial Type{/ts}</td>
                    </tr>
                  </thead>
                  <tbody>
                    {foreach from=$receipt.lines key=id item=item}
                    <tr>
                      <td>{$item.total_amount|crmMoney}</td>
                      <td>{$item.receive_date}</td>
                      <td>{$item.type}</td>
                    </tr>
                    {/foreach}
                  </tbody>
                </table>
              </div>
        </div>
      </td>
    </tr>
    {/foreach}
  </table>
</div>

{literal}
<style type="text/css">
  .action-link .button {
    margin-bottom: 0;
  }
  .donrec-details-block {
    display: none;
    background-color: lightgreen;
  }
  .donrec-stats-block table {
    border-collapse: collapse;
  }
  .donrec-stats-block tr td, tr th {
    border: none;
  }
  .donrec-stats-block ul {
    list-style-type: none;
  }
  .donrec-stats-block a {
    cursor: pointer;
  }
</style>

<script type="text/javascript">
  cj(function() {
    var re = /^(details|view|copy|withdraw|delete)_receipt_([0-9]+)/;
    // called for every detail-view-link
    cj('.donrec-stats-block a[id^="details_receipt_"]').click(function() {
        // calculate receipt id
        var rid = re.exec(this.id);
        if (rid != null) {
          cj('#donrec_details_block_' + rid[2] + '_1').toggle();
          cj('#donrec_details_block_' + rid[2] + '_2').toggle();
        }

    });
    // called for every view-button
    cj('.donrec-stats-block a[id^="view_receipt_"]').click(function() {
        // calculate receipt id
        var rid = re.exec(this.id);
        if (rid != null) {
          rid = rid[2];
          {/literal}
          var filename = "{ts}DonationReceipt{/ts}-{$cid}-" + rid + ".pdf";
          {literal}
          // view this donation receipt
          CRM.api('DonationReceipt', 'view', {'q': 'civicrm/ajax/rest', 'sequential': 1, 'rid': rid, name: filename},
            {success: function(data) {
                if (data['is_error'] == 0) {
                  // use the following to urldecode the link url
                  var view_url = cj("<div/>").html(data.values).text();
                  location.href = view_url;
                }else{
                  CRM.alert("{/literal}" + data['error_message'], "{ts}Error{/ts}{literal}", "error");
                }
              }
            }
          );
        }

    });
    {/literal}{if $can_create_withdraw}{literal}
    // called for every withdraw-button
    cj('.donrec-stats-block a[id^="withdraw_receipt_"]').click(function() {
        // calculate receipt id
        var rid = re.exec(this.id);
        if (rid != null) {
          rid = rid[2];
          // withdraw this donation receipt
          CRM.api('DonationReceipt', 'withdraw', {'q': 'civicrm/ajax/rest', 'sequential': 1, 'rid': rid},
            {success: function(data) {
                if (data['is_error'] == 0) {
                  CRM.alert("{/literal}{ts}The donation receipt has been successfully withdrawn{/ts}", "{ts}Success{/ts}{literal}", "success");
                  var contentId = cj('#tab_donation_receipts').attr('aria-controls');
                  cj('#' + contentId).load(CRM.url('civicrm/donrec/tab', {'reset': 1, 'snippet': 1, 'force': 1, 'cid':{/literal}{$cid}{literal}}));
                }else{
                  CRM.alert("{/literal}" + data['error_message'], "{ts}Error{/ts}{literal}", "error");
                }
              }
            }
          );
        }

    });
    {/literal}{/if}{if $can_view_copy}{literal}
    // called for every copy-button
    cj('.donrec-stats-block a[id^="copy_receipt_"]').click(function() {
        // calculate receipt id
        var rid = re.exec(this.id);
        if (rid != null) {
          rid = rid[2];
          // copy this donation receipt
          CRM.api('DonationReceipt', 'copy', {'q': 'civicrm/ajax/rest', 'sequential': 1, 'rid': rid},
            {success: function(data) {
                if (data['is_error'] == 0) {
                  CRM.alert("{/literal}{ts}The donation receipt has been successfully copied{/ts}", "{ts}Success{/ts}{literal}", "success");
                  var contentId = cj('#tab_donation_receipts').attr('aria-controls');
                  cj('#' + contentId).load(CRM.url('civicrm/donrec/tab', {'reset': 1, 'snippet': 1, 'force': 1, 'cid':{/literal}{$cid}{literal}}));
                }else{
                  CRM.alert("{/literal}" + data['error_message'], "{ts}Error{/ts}{literal}", "error");
                }
              }
            }
          );
        }

    });
    {/literal}{/if}{if $can_delete}{literal}
    // called for every delete-button
    cj('.donrec-stats-block a[id^="delete_receipt_"]').click(function() {
        // calculate receipt id
        var rid = re.exec(this.id);
        if (rid != null) {
          rid = rid[2];
          // delete this donation receipt
          var msgExt = "";
          if(/original/i.test(cj("div[name='donrec_stats_" + rid +"'] ul li:nth-child(2)").text())) {
            msgExt = "<br/>" + {/literal}"{ts}You could also just withdraw it.{/ts}"{literal};
          }
          CRM.confirm(function() {
            CRM.api('DonationReceipt', 'delete', {'q': 'civicrm/ajax/rest', 'sequential': 1, 'rid': rid, 'id': 0},
            {success: function(data) {
                if (data['is_error'] == 0) {
                  CRM.alert("{/literal}{ts}The donation receipt has been successfully deleted{/ts}", "{ts}Success{/ts}{literal}", "success");
                  var contentId = cj('#tab_donation_receipts').attr('aria-controls');
                  cj('#' + contentId).load(CRM.url('civicrm/donrec/tab', {'reset': 1, 'snippet': 1, 'force': 1, 'cid':{/literal}{$cid}{literal}}));
                }else{
                  CRM.alert("{/literal}" + data['error_message'], "{ts}Error{/ts}{literal}", "error");
                }
              }
            }
          );
          },
          {
            message: {/literal}"{ts}Are you sure you want to delete this donation receipt?{/ts}"{literal} + msgExt
          });
        }
    });{/literal}{/if}{literal}
  });
</script>
{/literal}
