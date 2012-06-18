Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2FRKwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:52:32 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:57445 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808Ab2FRKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:52:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4FAPsG309bdWObgWdsb2JhbABFrS+IKyIBARYmJ4IZAQUyAQUdIwEQCyEWDwkDAgECAUUGDQEHAQGIC7d9kXIDlSSSXw
X-IronPort-AV: E=Sophos;i="4.77,430,1336341600"; 
   d="scan'208";a="921566745"
Message-ID: <4FDF085A.7030805@igalia.com>
Date: Mon, 18 Jun 2012 12:52:10 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arnaud.patard@rtp-net.org, aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Staging: xgifb: reorder the code a bit to be more
 module friendly
References: <1338992527-5659-1-git-send-email-magomez@igalia.com> <1338992527-5659-2-git-send-email-magomez@igalia.com> <20120612000151.GA16887@kroah.com>
In-Reply-To: <20120612000151.GA16887@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   /*****************************************************/
>>   /*                      MODULE                       */
>>   /*****************************************************/
>>
>> -MODULE_DESCRIPTION("Z7 Z9 Z9S Z11 framebuffer device driver");
>> -MODULE_LICENSE("GPL");
>> -MODULE_AUTHOR("XGITECH , Others");
>> -
>>   module_param(mode, charp, 0);
>> -module_param(vesa, int, 0);
>> -module_param(filter, int, 0);
>> -module_param(forcecrt2type, charp, 0);
>> +MODULE_PARM_DESC(mode,
>> +	"\nSelects the desired default display mode in the format XxYxDepth,\n"
>> +	"eg. 1024x768x16.\n");
>>
>> +module_param(forcecrt2type, charp, 0);
>>   MODULE_PARM_DESC(forcecrt2type,
>>   	"\nForce the second display output type. Possible values are NONE,\n"
>>   	"LCD, TV, VGA, SVIDEO or COMPOSITE.\n");
>
> What's with these "\n" in the string?  Shouldn't those be removed?

Sure, I'll clean them in the next round of patches :)

(sorry for the delay)

Cheers!

-- 
Miguel Gómez
Igalia - http://www.igalia.com
