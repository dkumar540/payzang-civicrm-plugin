<?php
require_once 'CRM/Core/Payment.php';

class com_payzang_payment_pzpayments extends CRM_Core_Payment
{
    /**
     * We only need one instance of this object. So we use the singleton
     * pattern and cache the instance in this variable
     *
     * @var object
     * @static
     */
    static private $_singleton = null;

    /**
     * mode of operation: live or test
     *
     * @var object
     * @static
     */
    static protected $_mode = null;

    /**
     * Constructor
     *
     * @param string $mode the mode of operation: live or test
     *
     * @return void
     */
    function __construct( $mode, &$paymentProcessor ) {
        $this->_mode             = $mode;
        $this->_paymentProcessor = $paymentProcessor;
        $this->_processorName    = ts('PayZang Payments');
    }

    /**
     * singleton function used to manage this object
     *
     * @param string $mode the mode of operation: live or test
     *
     * @return object
     * @static
     *
     */
    static function &singleton( $mode, &$paymentProcessor ) {
        $processorName = $paymentProcessor['name'];
        if (self::$_singleton[$processorName] === null ) {
            self::$_singleton[$processorName] = new com_payzang_payment_pzpayments( $mode, $paymentProcessor );
        }
        return self::$_singleton[$processorName];
    }

    /**
     * This function checks to see if we have the right config values
     *
     * @return string the error message if any
     * @public
     */
    function checkConfig( ) {
        $config = CRM_Core_Config::singleton();

        $error = array();

        if (empty($this->_paymentProcessor['user_name'])) {
            $error[] = ts('The "Bill To ID" is not set in the Administer CiviCRM Payment Processor.');
        }

        if (!empty($error)) {
            return implode('<p>', $error);
        }
        else {
            return NULL;
        }
    }

    /**
     * Sets appropriate parameters for checking out to PayZang Payments
     *
     * @param array $params  name value pair of contribution data
     *
     * @return void
     * @access public
     *
     */
    function doDirectPayment(&$params) {
        $merchantID = $this->_paymentProcessor['user_name'];
        $password = $this->_paymentProcessor['password'];
        include_once 'CRM/Contribute/PseudoConstant.php';
        $payment_method = $params['payment_method'];
        $paymentMethods = CRM_Contribute_PseudoConstant::paymentInstrument();
        $transactionType = ($paymentMethods[$payment_method] == 'ACH'?20:10); // Use 10 to identify CC sale, 20 for EFT sale
        $invoiceID = $params['invoiceID'];
        $amount = $params['amount'];
        $first = $params['first_name'];
        $middle = $params['middle_name'];
        $last = $params['last_name'];
        $cardName = $first . ' ' . $middle . ' ' . $last;
        $cardType = $params['credit_card_type'];
        $cardNumber = $params['credit_card_number'];
        $cvv2 = $params['cvv2'];
        $cardExpMonth = $params['credit_card_exp_date']['M'];
        $cardExpYear = $params['credit_card_exp_date']['Y'];
        $street1 = $params['street_address'];
        $city = $params['city'];
        $state = $params['state_province'];
        $zip = $params['postal_code'];
        $routing = $params['routing_number'];
        $account = $params['account_number'];
        $accountType = ($params['account_type'] == 'Checking'?'C':'S'); // C for Checking, S for Savings
        $checkNO = $params['check_number']; // Is this really required?  Payment gateway doesn't make this mandatory
        if(!empty($params['is_recur']) && $params['is_recur'])
        {
            $scheduleFrequency = $this->_getScheduleFrequency($params['frequency_unit']);
            $scheduleQuantity = $params['installments'];
        }



        $billID = array(
            $params['invoiceID'],
            $params['qfKey'],
        );


        // output transaction - this is dynamically created from form variables
        $output_transaction = "pg_merchant_id={$merchantID}";
        $output_transaction .= "&pg_password={$password}";
        $output_transaction .= "&pg_transaction_type={$transactionType}";
        $output_transaction .= "&pg_total_amount={$amount}";
        $output_transaction .= "&ecom_consumerorderid={$invoiceID}";
        if(!empty($params['is_recur']) && $params['is_recur'])
        {
            $output_transaction .= "&pg_schedule_frequency={$scheduleFrequency}";
            $output_transaction .= "&pg_schedule_quantity={$scheduleQuantity}";
        }
        $output_transaction .= "&ecom_billto_postal_name_first={$first}";
        $output_transaction .= "&ecom_billto_postal_name_last={$last}";
        $output_transaction .= "&ecom_billto_postal_street_line1={$street1}";
        $output_transaction .= "&ecom_billto_postal_city={$city}";
        $output_transaction .= "&ecom_billto_postal_stateprov={$state}";
        $output_transaction .= "&ecom_billto_postal_postalcode={$zip}";
        if($transactionType == 10) //// Use 10 to identify CC sale, 20 for EFT sale
        {
            $output_transaction .= "&Ecom_payment_card_type={$cardType}";
            $output_transaction .= "&ecom_payment_card_name={$cardName}";
            $output_transaction .= "&ecom_payment_card_number={$cardNumber}";
            $output_transaction .= "&ecom_payment_card_expdate_month={$cardExpMonth}";
            $output_transaction .= "&ecom_payment_card_expdate_year={$cardExpYear}";
            $output_transaction .= "&ecom_payment_card_verification={$cvv2}";
            $output_transaction .= "&pg_avs_method=00000";
            $output_transaction .= "&endofdata&";
        }
        else
        {
            $output_transaction .= "&ecom_payment_check_account_type={$accountType}";
            $output_transaction .= "&ecom_payment_check_account={$account}";
            $output_transaction .= "&ecom_payment_check_trn={$routing}";
            $output_transaction .= "&ecom_payment_check_checkno={$checkNO}";
            $output_transaction .= "&pg_avs_method=00000";
            $output_transaction .= "&endofdata&";
        }


        // output url - i.e. the absolute url to the paymentsgateway.net script
        $output_url = $this->_paymentProcessor['url_api'];

        // start output buffer to catch curl return data
        ob_start();

            // setup curl
                $ch = curl_init ($output_url);
            // set curl to use verbose output
                curl_setopt ($ch, CURLOPT_VERBOSE, 1);
            // set curl to use HTTP POST
                curl_setopt ($ch, CURLOPT_POST, 1);
            // set POST output
                curl_setopt ($ch, CURLOPT_POSTFIELDS, $output_transaction);
            //execute curl and return result to STDOUT
                curl_exec ($ch);
            //close curl connection
                curl_close ($ch);

        // set variable eq to output buffer
        $process_result = ob_get_contents();

        // close and clean output buffer
        ob_end_clean();

        // clean response data of whitespace, convert newline to ampersand for parse_str function and trim off endofdata
        $clean_data = str_replace("\n","&",trim(str_replace("endofdata", "", trim($process_result))));

        // parse the string into variablename=variabledata
        parse_str($clean_data);

        // success
        if($pg_response_type == 'A')
        {
            if( !empty($params['is_recur']) && $params['is_recur'] )
            {
                $recurParams = array( 'id'      => $params['contributionRecurID'],
                    'trxn_id' => $pg_trace_number,
                    'frequency_unit' => $params['frequency_unit'] //Adding this here, for some reason this never gets set in normal process
                );
                $ids = array( 'contribution' => $params['contributionRecurID'] );

                require_once 'CRM/Contribute/BAO/ContributionRecur.php';
                $recurring =& CRM_Contribute_BAO_ContributionRecur::add( $recurParams, $ids );
            }
            $result['trxn_id'] = $pg_trace_number;
            $result['payment_instrument_id'] = $payment_method;

        }
        else // failed
        {
            /*echo "Response Type = ".$pg_response_type."<br />";
            echo "Response Code = ".$pg_response_code."<br />";
            echo "Response Description = ".$pg_response_description."<br />";*/
            return self::error( $pg_response_code, $pg_response_description );


            //CRM_Core_Error::fatal(ts('Throwing an error'));
        }
        return $result;
    }

    function &error( $errorCode = null, $errorMessage = null )
    {
        $e =& CRM_Core_Error::singleton( );
        if ( $errorCode ) {
            $e->push( $errorCode, 0, null, $errorMessage );
        } else {
            $e->push( 9001, 0, null, 'Unknown System Error.' );
        }
        return $e;
    }

    function doTransferCheckout( &$params, $component ) {
        CRM_Core_Error::fatal(ts('This function is not implemented'));
    }

    function _getScheduleFrequency($freq)
    {
        $retVal = 0;
        switch ($freq)
        {
            case "weekly":
                $retVal = 10;
            break;
            case "bi-weekly":
                $retVal = 15;
                break;
            case "monthly":
                $retVal = 20;
                break;
            case "bi-monthly":
                $retVal = 25;
                break;
            case "quarterly":
                $retVal = 30;
                break;
            case "semiannually":
                $retVal = 35;
                break;
            case "yearly":
                $retVal = 40;
                break;
            default:
                $retVal = 0;
        }
        return $retVal;
    }
}

?>