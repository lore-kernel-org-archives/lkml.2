Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2E3HhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:37:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2E3HhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:37:23 -0400
Message-ID: <4FC5CE2E.6000501@linaro.org>
Date: Wed, 30 May 2012 15:37:18 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] mfd: Remove redundant Kconfig entry
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org> <1338353260-10097-19-git-send-email-lee.jones@linaro.org> <CACRpkdYpCMRurpDgz5X-Qsv5qUgzeVX3S8trWHByTaw6R35_jg@mail.gmail.com>
In-Reply-To: <CACRpkdYpCMRurpDgz5X-Qsv5qUgzeVX3S8trWHByTaw6R35_jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/12 15:15, Linus Walleij wrote:
> On Wed, May 30, 2012 at 12:47 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
>> was left remnant. This patch simply removes it.
>>
>> Cc: Samuel Ortiz<sameo@linux.intel.com>
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
>> ---
>>   drivers/mfd/Kconfig |   10 ----------
>>   1 file changed, 10 deletions(-)
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 11a1b65..b697136 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -660,16 +660,6 @@ config AB8500_CORE
>>           the irq_chip parts for handling the Mixed Signal chip events.
>>           This chip embeds various other multimedia funtionalities as well.
>>
>> -config AB8500_I2C_CORE
>> -       bool "AB8500 register access via PRCMU I2C"
>> -       depends on AB8500_CORE&&  MFD_DB8500_PRCMU
>
> You need to move these dependencies under the AB8500_CORE config
> entry instead.

Already done and upstreamed: 21f082a66177852365df0c955ecaef50fba9a691

>> -       default y
>
> I wonder if in  arch/arm/mach-ux500/Kconfig MACH_MOP500 should
> select this instead, all MOP500 children have this an *won't* work
> without it.

As described, I have already moved the dependency in the Kconfig file.

I guess what you've just mentioned is a separate patch (for another 
time). I'll stick it on my ever growing TODO.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
