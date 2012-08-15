Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2HOIwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:52:40 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49294
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab2HOIwZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:52:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1202h1082kzz8275bh8275dhz2dh2a8h668h839h93fhd25he5bhf0ah107ah)
Message-ID: <502B63AD.4000604@freescale.com>
Date: Wed, 15 Aug 2012 16:54:05 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: Huang Shijie <shijie8@gmail.com>, <linux-mtd@lists.infradead.org>,
        <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
References: <1344998325-3279-1-git-send-email-shijie8@gmail.com> <20120815100655.479e2c39@pixies.home.jungo.com>
In-Reply-To: <20120815100655.479e2c39@pixies.home.jungo.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年08月15日 15:06, Shmulik Ladkani 写道:
> Hi Huang,
>
> On Tue, 14 Aug 2012 22:38:45 -0400 Huang Shijie<shijie8@gmail.com>  wrote:
>> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
>> index 588e989..0ca7257 100644
>> --- a/drivers/mtd/nand/Kconfig
>> +++ b/drivers/mtd/nand/Kconfig
>> @@ -22,15 +22,6 @@ menuconfig MTD_NAND
>>
>>   if MTD_NAND
>>
>> -config MTD_NAND_VERIFY_WRITE
>> -	bool "Verify NAND page writes"
>> -	help
>> -	  This adds an extra check when data is written to the flash. The
>> -	  NAND flash device internally checks only bits transitioning
>> -	  from 1 to 0. There is a rare possibility that even though the
>> -	  device thinks the write was successful, a bit could have been
>> -	  flipped accidentally due to device wear or something else.
>> -
> There are some defconfig files which set CONFIG_MTD_NAND_VERIFY_WRITE.
>
> I guess you should submit an accompanying patch that removes
> CONFIG_MTD_NAND_VERIFY_WRITE from all defconfig files.
>
thanks a lot.

I will send out a separate patch to fix it.

Huang Shijie
> (also, trimmed the CC list for this specific discussion, seems unrelated
> to all of the parties)
>
> Regards,
> Shmulik
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>


