Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0IYPNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:13:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:36424 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0IYPNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,236,1283756400"; 
   d="scan'208";a="610341359"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Date: Sat, 25 Sep 2010 08:13:36 -0700
Subject: RE: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel
Thread-Topic: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel
Thread-Index: ActcpRwsR9x6wnrHT76ae6i+jzvpEgAHqo/Q
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AEA5258E@orsmsx501.amr.corp.intel.com>
References: <201009241606.11840.seth.heasley@intel.com>
 <20100925133039.75e9ac71@endymion.delvare>
In-Reply-To: <20100925133039.75e9ac71@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.35.4/drivers/i2c/busses/Kconfig.orig	2010-09-24
>14:59:23.000000000 -0700
>> +++ linux-2.6.35.4/drivers/i2c/busses/Kconfig	2010-09-24
>14:59:42.000000000 -0700
>> @@ -95,7 +95,7 @@
>>  	    ESB2
>>  	    ICH8
>>  	    ICH9
>> -	    Tolapai
>> +	    EP80579
>>  	    ICH10
>>  	    3400/5 Series (PCH)
>
>How did this become "5_3400_SERIES" in the symbol names? Shouldn't it
>be 3400_5_SERIES instead?

The way I did it here is consistent with the approved branding submitted for pci.ids.  So perhaps changing the 3400/5 Series to "5 Series/3400 Series" would make sense.

>
>>  	    Cougar Point (PCH)
>> --- linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c.orig	2010-09-24
>14:57:55.000000000 -0700
>> +++ linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c	2010-09-24
>14:59:13.000000000 -0700
>> @@ -38,7 +38,7 @@
>>    82801G   (ICH7)       0x27da     32     hard     yes     yes
>yes
>>    82801H   (ICH8)       0x283e     32     hard     yes     yes
>yes
>>    82801I   (ICH9)       0x2930     32     hard     yes     yes
>yes
>> -  Tolapai               0x5032     32     hard     yes     yes
>yes
>> +  EP80579               0x5032     32     hard     yes     yes
>yes
>
>Maybe keep "Tolapai" inside parentheses, as people may know the
>platform by that name by now?

That'd be fine with me.

-Seth
