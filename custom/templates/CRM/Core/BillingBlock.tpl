{crmRegion name="billing-block"}
    {if $form.credit_card_number or $form.bank_account_number}
    <div id="payment_information">
    <fieldset class="billing_mode-group {if $paymentProcessor.payment_type & 2}direct_debit_info-group{else}credit_card_info-group{/if}">
        <legend>
            {if $paymentProcessor.payment_type & 2}
                {ts}Direct Debit Information{/ts}
                {else}
                {if $isPZ eq 1}
                    {ts}Payment Information{/ts}
                    {else}
                    {ts}Credit Card Information{/ts}
                {/if}
            {/if}
        </legend>
        {if $paymentProcessor.billing_mode & 2 and !$hidePayPalExpress }
            <div class="crm-section no-label paypal_button_info-section">
                <div class="content description">
                    {ts}If you have a PayPal account, you can click the PayPal button to continue. Otherwise, fill in the credit card and billing information on this form and click <strong>Continue</strong> at the bottom of the page.{/ts}
                </div>
            </div>
            <div class="crm-section no-label {$form.$expressButtonName.name}-section">
                <div class="content description">
                    {$form.$expressButtonName.html}
                    <div class="description">Save time. Checkout securely. Pay without sharing your financial information. </div>
                </div>
            </div>
        {/if}

        {if $paymentProcessor.billing_mode & 1}
            <div class="crm-section billing_mode-section {if $paymentProcessor.payment_type & 2}direct_debit_info-section{else}credit_card_info-section{/if}">
                {if $paymentProcessor.payment_type & 2}
                    <div class="crm-section {$form.account_holder.name}-section">
                        <div class="label">{$form.account_holder.label}</div>
                        <div class="content">{$form.account_holder.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.bank_account_number.name}-section">
                        <div class="label">{$form.bank_account_number.label}</div>
                        <div class="content">{$form.bank_account_number.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.bank_identification_number.name}-section">
                        <div class="label">{$form.bank_identification_number.label}</div>
                        <div class="content">{$form.bank_identification_number.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.bank_name.name}-section">
                        <div class="label">{$form.bank_name.label}</div>
                        <div class="content">{$form.bank_name.html}</div>
                        <div class="clear"></div>
                    </div>
                    {else}
                        {if $isPZ eq 1}
                            <div class="crm-section {$form.payment_method.name}-section" id="{$form.payment_method.name}-section">
                                <div class="label">{$form.payment_method.label}</div>
                                <div class="content">{$form.payment_method.html}</div>
                                <div class="clear"></div>
                            </div>
                            <div class="crm-section {$form.routing_number.name}-section" id="{$form.routing_number.name}-section">
                                <div class="label">{$form.routing_number.label}<span class = 'crm-marker'>*</span></div>
                                <div class="content">{$form.routing_number.html}</div>
                                <div class="clear"></div>
                            </div>
                            <div class="crm-section {$form.account_number.name}-section" id="{$form.account_number.name}-section">
                                <div class="label">{$form.account_number.label}<span class = 'crm-marker'>*</span></div>
                                <div class="content">{$form.account_number.html}</div>
                                <div class="clear"></div>
                            </div>
                            <div class="crm-section {$form.check_number.name}-section" id="{$form.check_number.name}-section">
                                <div class="label">{$form.check_number.label}<span class = 'crm-marker'></span></div>
                                <div class="content">{$form.check_number.html}</div>
                                <div class="clear"></div>
                            </div>
                            <div class="crm-section {$form.account_type.name}-section" id="{$form.account_type.name}-section">
                                <div class="label">{$form.account_type.label}</div>
                                <div class="content">{$form.account_type.html}</div>
                                <div class="clear"></div>
                            </div>
                        {/if}
                    <div class="crm-section {$form.credit_card_type.name}-section">
                        <div class="label">{$form.credit_card_type.label}</div>
                        <div class="content">{$form.credit_card_type.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.credit_card_number.name}-section">
                        <div class="label">{$form.credit_card_number.label}</div>
                        <div class="content">{$form.credit_card_number.html}
                            <div class="description">{ts}Enter numbers only, no spaces or dashes.{/ts}</div>
                        </div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.cvv2.name}-section">
                        <div class="label">{$form.cvv2.label}</div>
                        <div class="content">
                            {$form.cvv2.html}
                            <img src="{$config->resourceBase}i/mini_cvv2.gif" alt="{ts}Security Code Location on Credit Card{/ts}" style="vertical-align: text-bottom;" />
                            <div class="description">{ts}Usually the last 3-4 digits in the signature area on the back of the card.{/ts}</div>
                        </div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.credit_card_exp_date.name}-section">
                        <div class="label">{$form.credit_card_exp_date.label}</div>
                        <div class="content">{$form.credit_card_exp_date.html}</div>
                        <div class="clear"></div>
                    </div>
                {/if}
            </div>
        </fieldset>

            <fieldset class="billing_name_address-group">
                <legend>{ts}Billing Name and Address{/ts}</legend>
                {if $profileAddressFields}
                    <input type="checkbox" id="billingcheckbox" value=0> <label for="billingcheckbox">{ts}Billing Address is same as above{/ts}</label>
                {/if}
                <div class="crm-section billing_name_address-section">
                    <div class="crm-section billingNameInfo-section">
                        <div class="content description">
                            {if $paymentProcessor.payment_type & 2}
                                {ts}Enter the name of the account holder, and the corresponding billing address.{/ts}
                                {else}
                                {ts}Enter the name as shown on your credit or debit card, and the billing address for this card.{/ts}
                            {/if}
                        </div>
                    </div>
                    <div class="crm-section {$form.billing_first_name.name}-section">
                        <div class="label">{$form.billing_first_name.label}</div>
                        <div class="content">{$form.billing_first_name.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.billing_middle_name.name}-section">
                        <div class="label">{$form.billing_middle_name.label}</div>
                        <div class="content">{$form.billing_middle_name.html}</div>
                        <div class="clear"></div>
                    </div>
                    <div class="crm-section {$form.billing_last_name.name}-section">
                        <div class="label">{$form.billing_last_name.label}</div>
                        <div class="content">{$form.billing_last_name.html}</div>
                        <div class="clear"></div>
                    </div>
                    {assign var=n value=billing_street_address-$bltID}
                    <div class="crm-section {$form.$n.name}-section">
                        <div class="label">{$form.$n.label}</div>
                        <div class="content">{$form.$n.html}</div>
                        <div class="clear"></div>
                    </div>
                    {assign var=n value=billing_city-$bltID}
                    <div class="crm-section {$form.$n.name}-section">
                        <div class="label">{$form.$n.label}</div>
                        <div class="content">{$form.$n.html}</div>
                        <div class="clear"></div>
                    </div>
                    {assign var=n value=billing_country_id-$bltID}
                    <div class="crm-section {$form.$n.name}-section">
                        <div class="label">{$form.$n.label}</div>
                        <div class="content">{$form.$n.html|crmReplace:class:big}</div>
                        <div class="clear"></div>
                    </div>
                    {assign var=n value=billing_state_province_id-$bltID}
                    <div class="crm-section {$form.$n.name}-section">
                        <div class="label">{$form.$n.label}</div>
                        <div class="content">{$form.$n.html|crmReplace:class:big}</div>
                        <div class="clear"></div>
                    </div>
                    {assign var=n value=billing_postal_code-$bltID}
                    <div class="crm-section {$form.$n.name}-section">
                        <div class="label">{$form.$n.label}</div>
                        <div class="content">{$form.$n.html}</div>
                        <div class="clear"></div>
                    </div>
                </div>
            </fieldset>
            {else}
            </fieldset>
        {/if}
    </div>

        {if $profileAddressFields}
        <script type="text/javascript">
                {literal}
                cj( function( ) {
                    cj('#billingcheckbox').click( function( ) {
                        sameAddress( this.checked ); // need to only action when check not when toggled, can't assume desired behaviour
                    });
                });

                function sameAddress( setValue ) {
                {/literal}
                var addressFields = {$profileAddressFields|@json_encode};
                {literal}
                    var locationTypeInProfile = 'Primary';
                    var orgID = field = fieldName = null;
                    if ( setValue ) {
                        cj('.billing_name_address-section input').each( function( i ){
                            orgID = cj(this).attr('id');
                            field = orgID.split('-');
                            fieldName = field[0].replace('billing_', '');
                            if ( field[1] ) { // ie. there is something after the '-' like billing_street_address-5
                                // this means it is an address field
                                if ( addressFields[fieldName] ) {
                                    fieldName =  fieldName + '-' + addressFields[fieldName];
                                }
                            }
                            cj(this).val( cj('#' + fieldName ).val() );
                        });

                        var stateId;
                        cj('.billing_name_address-section select').each( function( i ){
                            orgID = cj(this).attr('id');
                            field = orgID.split('-');
                            fieldName = field[0].replace('billing_', '');
                            fieldNameBase = fieldName.replace('_id', '');
                            if ( field[1] ) {
                                // this means it is an address field
                                if ( addressFields[fieldNameBase] ) {
                                    fieldName =  fieldNameBase + '-' + addressFields[fieldNameBase];
                                }
                            }

                            // don't set value for state-province, since
                            // if need reload state depending on country
                            if ( fieldNameBase == 'state_province' ) {
                                stateId = cj('#' + fieldName ).val();
                            }
                            else {
                                cj(this).val( cj('#' + fieldName ).val() ).change( );
                            }
                        });

                        // now set the state province
                        // after ajax call loads all the states
                        if ( stateId ) {
                            cj('select[id^="billing_state_province_id"]').ajaxStop(function() {
                                cj( 'select[id^="billing_state_province_id"]').val( stateId );
                            });
                        }
                    }
                }
                {/literal}
        </script>
        {/if}

        {literal}
        <script type="text/javascript">
            function showHidePaymentDetails(element)
            {
                value = element.options[element.selectedIndex].text;

                //if(value=='Check' )
                if(value=='ACH')
                {
                    cj('.credit_card_type-section').hide();
                    cj('.credit_card_number-section').hide();
                    cj('.cvv2-section').hide();
                    cj('.credit_card_exp_date-section').hide();

                    cj('.routing_number-section').show();
                    cj('.account_number-section').show();
                    cj('.check_number-section').show();
                    cj('.account_type-section').show();

                }
                else if(value=='Credit Card')
                {
                    cj('.credit_card_type-section').show();
                    cj('.credit_card_number-section').show();
                    cj('.cvv2-section').show();
                    cj('.credit_card_exp_date-section').show();

                    cj('.routing_number-section').hide();
                    cj('.account_number-section').hide();
                    cj('.check_number-section').hide();
                    cj('.account_type-section').hide();
                }
                else
                {
                    cj('.credit_card_type-section').hide();
                    cj('.credit_card_number-section').hide();
                    cj('.cvv2-section').hide();
                    cj('.credit_card_exp_date-section').hide();
                    cj('.routing_number-section').hide();
                    cj('.account_number-section').hide();
                    cj('.check_number-section').hide();
                    cj('.account_type-section').hide();
                }
            }
            showHidePaymentDetails(document.getElementById('payment_method'));

            function copyAddress(){
                var homeArray = new Array( 'first_name', 'last_name', 'street_address-3', 'city-3', 'postal_code-3', 'country-3', 'state_province-3' );
                var billingArray = new Array( 'billing_first_name', 'billing_last_name', 'billing_street_address-5', 'billing_city-5', 'billing_postal_code-5', 'billing_country_id-5', 'billing_state_province_id-5' );

                cj.each( homeArray, function(key, value){

                    cj('#'+billingArray[key]).val(cj('#'+value).val());
                } );
            }
        </script>
        {/literal}
    {/if}
{/crmRegion}