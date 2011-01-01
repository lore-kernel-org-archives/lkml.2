Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1AAHnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 02:43:12 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:37904 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1AAHnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 02:43:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lsALV2V04jUx1yyqpwURb/P9ytBmPIgLkxfBAtMClvKe+Uk4XaJ+U04HJU3ZQ7dxnW
         vc7Cme2U3c6W5i1i+i1rzRumLdX4VNK1YGxPqsIdu9euXg2r3PqVz0V4fYKTJKa3zmK+
         21nG/hYx05Gsym+CLnSagZmK6DhSJjXu+xXsk=
Message-ID: <4D1EDB22.2020308@gmail.com>
Date: Fri, 31 Dec 2010 23:43:30 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 03/15]drivers:staging:rtl8187se:r8180_hw.h Typo change
 diable to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1012311722580.24460@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1012311722580.24460@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2010 10:48 PM, Finn Thain wrote:
>
> On Thu, 30 Dec 2010, Justin P. Mattock wrote:
>
>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>> is correct or not.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/staging/rtl8187se/r8180_hw.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8187se/r8180_hw.h b/drivers/staging/rtl8187se/r8180_hw.h
>> index 3fca144..2911d40 100644
>> --- a/drivers/staging/rtl8187se/r8180_hw.h
>> +++ b/drivers/staging/rtl8187se/r8180_hw.h
>> @@ -554,7 +554,7 @@
>>   /* by amy for power save		*/
>>   /* by amy for antenna			*/
>>   #define EEPROM_SW_REVD_OFFSET 0x3f
>> -/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are diable.					*/
>> +/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are disabled.					*/
>
> I think, "other values disable" was what you meant?
>
> Finn
>
>>   #define EEPROM_SW_AD_MASK			0x0300
>>   #define EEPROM_SW_AD_ENABLE			0x0100
>>
>>
>

no! I changed it to disabled to make it proper..

Justin P. Mattock
