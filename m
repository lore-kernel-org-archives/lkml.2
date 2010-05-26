Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab0EZB6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:58:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59099 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab0EZB6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ax9NUu50xtliaz8ewU8HVw/S2wF7+iocOg5BB6QTWXMwshHz1zIL0BPCt2Hk1YC1b0
         MDY0OLnKsXGehdM27egV7iB8USmkvrYtYdSj3pV/f8tfdDhjJRdh6lEhpWxf7/Iw4chd
         TDxQ8VXFggHB1S1wW+Llg1nmMh5mlx/pfzzLA=
Message-ID: <4BFC8059.5020708@gmail.com>
Date: Wed, 26 May 2010 09:58:49 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NUC900: add maintainer entries for Wan ZongShun.
References: <4BF7E6EC.7010505@gmail.com> <20100525160130.6e5aeb60.akpm@linux-foundation.org>
In-Reply-To: <20100525160130.6e5aeb60.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,


> On Sat, 22 May 2010 22:15:08 +0800
> Wan ZongShun <mcuos.com@gmail.com> wrote:
> 
>> Dear Andrew,
>>
>> I want to add some files entries in MAINTAINER files
>> for Winbond/Nuvoton ARM platform.
>>
>> Could you help me merge this patch?
>>
> 
> I can do that.

Thanks a lot for your help again!

> 
>> >From 4e5326dbfbfdad58eb2c333df91c15993bce6c47 Mon Sep 17 00:00:00 2001
>> From: zswan <zswan@zswan-marvell.(none)>
>> Date: Sat, 22 May 2010 21:56:26 +0800
>> Subject: [PATCH] add maintainer file entries
>>
> 
> Please send your Signed-off-by: for this change.

So,should I add the "Signed-off-by" in my patch,and resubmit it to you?

> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index d329b05..d6b3777 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -970,6 +970,18 @@ M:	Wan ZongShun <mcuos.com@gmail.com>
>>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  W:	http://www.mcuos.com
>>  S:	Maintained
>> +F:	arch/arm/mach-w90x900/
>> +F:	arch/arm/mach-nuc93x/
>> +F:	drivers/input/keyboard/w90p910_keypad.c
>> +F:	drivers/input/touchscreen/w90p910_ts.c
>> +F:	drivers/watchdog/nuc900_wdt.c
>> +F:	drivers/net/arm/w90p910_ether.c
>> +F:	drivers/mtd/nand/w90p910_nand.c
>> +F:	drivers/rtc/rtc-nuc900.c
>> +F:	drivers/spi/spi_nuc900.c
>> +F:	drivers/usb/host/ehci-w90x900.c
>> +F:	drivers/video/nuc900fb.c
>> +F:	drivers/sound/soc/nuc900/
>>
>>  ARM/U300 MACHINE SUPPORT
>>  M:	Linus Walleij <linus.walleij@stericsson.com>
>> -- 
>> 1.6.3.3
> 

