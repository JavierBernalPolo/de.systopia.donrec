<?php
/*-------------------------------------------------------+
| SYSTOPIA Donation Receipts Extension                   |
| Copyright (C) 2013-2014 SYSTOPIA                       |
| Author: N.Bochan (bochan -at- systopia.de)             |
| http://www.systopia.de/                                |
+--------------------------------------------------------+
| TODO: License                                          |
+--------------------------------------------------------*/

/**
 * This class holds helper functions
 */
class CRM_Utils_DonrecHelper
{
  /**
  * @param number any number that should be converted to words
  * @param lang language - currently only 'de' (German) is supported
  * @author Karl Rixon (http://www.karlrixon.co.uk/writing/convert-numbers-to-words-with-php/)
  *         modified by Niko Bochan to support the German language
  */
  public static function convert_number_to_words($number, $lang='de') {
    // FIXME: @Niko bitte etwas mehr Doku im Code
    if ($lang!='de') return false;
    $hyphen      = 'und';
    $conjunction = ' ';
    $separator   = ' ';
    $negative    = 'minus ';
    $decimal     = ' Euro ';
    $dictionary  = array(
        0                   => 'null',
        1                   => 'ein',
        2                   => 'zwei',
        3                   => 'drei',
        4                   => 'vier',
        5                   => 'fünf',
        6                   => 'sechs',
        7                   => 'sieben',
        8                   => 'acht',
        9                   => 'neun',
        10                  => 'zehn',
        11                  => 'elf',
        12                  => 'zwölf',
        13                  => 'dreizehn',
        14                  => 'vierzehn',
        15                  => 'fünfzehn',
        16                  => 'sechzehn',
        17                  => 'siebzehn',
        18                  => 'achtzehn',
        19                  => 'neunzehn',
        20                  => 'zwanzig',
        30                  => 'dreißig',
        40                  => 'vierzig',
        50                  => 'fünfzig',
        60                  => 'sechzig',
        70                  => 'siebzig',
        80                  => 'achtzig',
        90                  => 'neunzig',
        100                 => 'hundert',
        1000                => 'tausend',
        1000000             => 'millionen',
        1000000000          => 'milliarden',
        1000000000000       => 'billionen'
    );

    if (!is_numeric($number)) {
        return false;
    }

    if (($number >= 0 && (int) $number < 0) || (int) $number < 0 - PHP_INT_MAX) {
        // overflow
        return false;
    }

    if ($number < 0) {
        return $negative . self::convert_number_to_words(abs($number));
    }

    $string = $fraction = null;

    if (strpos($number, '.') !== false) {
        list($number, $fraction) = explode('.', $number);
    }

    switch (true) {
        case $number < 21:
            $string = $dictionary[$number];
            break;
        case $number < 100:
            $tens   = ((int) ($number / 10)) * 10;
            $units  = $number % 10;
            if ($units) {
                $string = $dictionary[$units] . $hyphen . $dictionary[$tens];
            }else{
                $string = $dictionary[$tens];
            }
            break;
        case $number < 1000:
            $hundreds  = $number / 100;
            $remainder = $number % 100;
            $string = $dictionary[$hundreds] . ' ' . $dictionary[100];
            if ($remainder) {
                $string .= $conjunction . self::convert_number_to_words($remainder);
            }
            break;
        default:
            $baseUnit = pow(1000, floor(log($number, 1000)));
            $numBaseUnits = (int) ($number / $baseUnit);
            $remainder = $number % $baseUnit;
            $string .= self::convert_number_to_words($numBaseUnits);
            if ($baseUnit == 1000000 && $numBaseUnits == 1) {
              $string .= 'e ';                                  // ein_e_
              $string .= substr($dictionary[$baseUnit], 0, -2); // million (ohne 'en')
            } else {
              $string .= ' ';
              $string .= $dictionary[$baseUnit];
            }

            if ($remainder) {
                $string .= ($remainder < 100) ? $conjunction : $separator;
                $string .= self::convert_number_to_words($remainder);
            }
            break;
    }

    if (null !== $fraction) {
        $string .= $decimal;

        if(is_numeric($fraction) && $fraction != 0.00) {
          switch (true) {
            case $fraction < 21:
                $string .= $dictionary[$fraction];
                break;
            case $fraction < 100:
                $tens   = ((int) ($fraction / 10)) * 10;
                $units  = $fraction % 10;
                if ($units) {
                    $string .= $dictionary[$units] . $hyphen . $dictionary[$tens];
                }else{
                    $string .= $dictionary[$tens];
                }
                break;
          }
        }
    }

    return $string;
  }

  /**
  * Converts a string to unix timestamp
  * @param string Raw date string (i.e. '10/15/2014')
  * @param int If $clamp is less than 0 the function will return a unix timestamp
  *            set to 00:00 of the given date. If it is greater than 1, it will
  *            return a value clamped to 23:59:59 of the same day.
  * @param format
  * @return string timestamp
  */
  public static function convertDate($raw_date, $clamp=0, $format = 'm/d/Y') {
    $date = FALSE;
    if (!empty($raw_date)) {
      $date_object = DateTime::createFromFormat($format, $raw_date, new DateTimeZone('Europe/Berlin'));
      if ($date_object) {
        if($clamp < 0) {
          // set to [date format] 00:00:00
          $date = mktime(0, 0, 0, $date_object->format('n'), $date_object->format('j'), $date_object->format('Y'));
        }else if($clamp > 0) {
          // set to [date format] 23:59:59
          $date = mktime(23, 59, 59, $date_object->format('n'), $date_object->format('j'), $date_object->format('Y'));
        }
      }
    }
    return $date;
  }
  /**
  * Calls die() with a pretty template (WIP)
  *
  */
  public static function exitWithMessage($error_message) {
    $template = "<html>
                 <head><title>Donation Receipt - Fatal Error</title></head>
                 <body><p>$error_message</p></body>
                 </html>";
    exit($template);
  }



  /**
   * Get a batching lock
   * 
   * the lock is needed so that only one relevant process can access the 
   * payment/statment data structures at a time
   * 
   * @return lock object. check if it ->isAcquired() before use
   */
  public static function getLock($type, $id) {
    if ($type=='') {
      // for the 'next' lock, we calculate the lock timeout as follows
      $max_lock_timeout = ini_get('max_execution_time');
      if (empty($max_lock_timeout)) {
        $max_lock_timeout = 30 * 60; // 30 minutes
      }

      // calculate based on chunk size (max 1min/item)
      $calculation_time = CRM_Donrec_Logic_Settings::getChunkSize() * 60;
      $timeout = min($calculation_time, $max_lock_timeout);

    } else {
      // default timeout for other locks
      $timeout = 600.0; // 10mins, TODO: do we need a setting here?
    }

    error_log("de.systopia.donrec.$type".'-'.$id." timeout $timeout created.");
    return new CRM_Core_Lock("de.systopia.donrec.$type".'-'.$id, $timeout);
  }

}
