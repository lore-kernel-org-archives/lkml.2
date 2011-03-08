Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1CHSdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:33:24 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:62091 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1CHSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:33:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QJlSTNKqYH5GjRMxEZ8wMrzkGaCkfZKGiYMYUJEm/WIILY6mRRRfssS7WCBOT8uqwl
         0v/3Rd2G3jY55vs1JHgdUIUhuFyFgZB5g3J4iknC18p4KMyDlUotWjAZHkvMOTcw83JD
         83+FS5MtIRsf3tGglGs5BJf/mo9z5e1LMNvew=
Message-ID: <4D767660.9030509@gmail.com>
Date: Tue, 08 Mar 2011 10:33:04 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]trivial: Remove one to many r's in some comments.
References: <1299527103-9953-1-git-send-email-justinmattock@gmail.com> <1299528921.20104.54.camel@Joe-Laptop>
In-Reply-To: <1299528921.20104.54.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 12:15 PM, Joe Perches wrote:
> On Mon, 2011-03-07 at 11:45 -0800, Justin P. Mattock wrote:
>> The below patch fixes some typos with one to many "rr's" in a comment.
>> PLease have a look and let me know if I missed anything.
>> --- a/arch/arm/mach-omap2/smartreflex.c
>> +++ b/arch/arm/mach-omap2/smartreflex.c
>> @@ -246,7 +246,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
>>    * driver register and sr device intializtion API's. Only one call
>>    * will ultimately succeed.
>>    *
>> - * Currenly this function registers interrrupt handler for a particular SR
>> + * Currenly this function registers interrupt handler for a particular SR
>
> When you do typo fixes, it'd be good to check the lines
> modified to make sure there are no other typos on the
> same or nearby lines.
>
> s/intializtion/initialization/
> s/Currenly/Currently/
>
>

again I missed this(hard of hearing/reading) will resend, hopefully 
correct this time.

>> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
>> index 1758d44..1473476 100644
>> --- a/drivers/net/wireless/rtlwifi/pci.c
>> +++ b/drivers/net/wireless/rtlwifi/pci.c
>> @@ -1506,7 +1506,7 @@ void rtl_pci_stop(struct ieee80211_hw *hw)
>>   	u8 RFInProgressTimeOut = 0;
>>
>>   	/*
>> -	 *should before disable interrrupt&adapter
>> +	 *should before disable interrupt&adapter
>
> Bad grammar?  Stop HAL before disabling interrupt and adapter?
>

not sure if HAL is involved with this or not, if anybody objects to the 
above then I will change if not I will resend with the above.

>> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>> index 2fe3046..c5d03e0 100644
>> --- a/drivers/usb/musb/musb_gadget.c
>> +++ b/drivers/usb/musb/musb_gadget.c
>> @@ -699,7 +699,7 @@ static void rxstate(struct musb *musb, struct musb_request *req)
>>   	 * most these gadgets, end of is signified either by a short packet,
>>   	 * or filling the last byte of the buffer.  (Sending extra data in
>>   	 * that last pckate should trigger an overflow fault.)  But in mode 1,
>
> s/pckate/packet/
>
>> diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
>> index 2f691e4..d2d4fb6 100644
>> --- a/include/linux/pxa2xx_ssp.h
>> +++ b/include/linux/pxa2xx_ssp.h
>> @@ -56,7 +56,7 @@
>>   /* PXA27x, PXA3xx */
>>   #define SSCR0_EDSS	(1<<  20)	/* Extended data size select */
>>   #define SSCR0_NCS	(1<<  21)	/* Network clock select */
>> -#define SSCR0_RIM	(1<<  22)	/* Receive FIFO overrrun interrupt mask */
>> +#define SSCR0_RIM	(1<<  22)	/* Receive FIFO overrun interupt mask */
>
> Fix one, introduce one.  Dangers of s/rr/r/
>
> overrun interrupt.
>
>
>
>


yeah.

Cool, Thanks for looking through..

Justin P. Mattock
