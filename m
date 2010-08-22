Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0HVHZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 03:25:32 -0400
Received: from compulab.co.il ([67.18.134.219]:45498 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab0HVHZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 03:25:28 -0400
Message-ID: <4C70D0CB.6040903@compulab.co.il>
Date: Sun, 22 Aug 2010 10:24:59 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.7) Gecko/20100816 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: imx: fix build failure concerning otg/ulpi
References: <4C65246E.1000906@ru.mvista.com>	<1281701210-27776-1-git-send-email-u.kleine-koenig@pengutronix.de>	<4C6783C7.1030604@compulab.co.il>	<20100816045340.GA17038@pengutronix.de> <4C68D607.3090202@compulab.co.il>
In-Reply-To: <4C68D607.3090202@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Greg,

ping...

On 08/16/10 09:09, Igor Grinberg wrote:
> On 08/16/10 07:53, Uwe Kleine-König wrote:
>> Hello Igor,
>>
>> On Sun, Aug 15, 2010 at 09:05:59AM +0300, Igor Grinberg wrote:
>>   
>>> On 08/13/10 15:06, Uwe Kleine-König wrote:
>>>     
>>>> The build failure was introduced by
>>>>
>>>> 	13dd0c9 (USB: otg/ulpi: extend the generic ulpi driver.)
>>>>
>>>> Cc: Igor Grinberg <grinberg@compulab.co.il>
>>>> Cc: Mike Rapoport <mike@compulab.co.il>
>>>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>>>   
>>>>       
>>> I've based my patches on v2.6.35-rc6, so I could not patch
>>> those imx variants, sorry...
>>> But I did deal with mach-pca100.c, so I think moving it from
>>> mach-mx2 to mach-imx is what made it miss my patch.
>>>
>>> Anyway, this looks like the right addition.
>>>     
>> I assume this is an Ack?
>>   
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>
>
> Greg,
>
> Can you, please, add this as a fix (maybe urgent) for build failure?
>
> Thanks
>
>> Best regards
>> Uwe
>>
>>   

-- 
Regards,
Igor.

