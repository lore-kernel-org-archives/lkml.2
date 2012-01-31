Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2AaK47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:56:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24693 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2AaK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:56:58 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Date: Tue, 31 Jan 2012 11:57:10 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/2] ARM: Exynos4: Convert exynos4-dt to
 CONFIG_MULTI_IRQ_HANDLER
In-reply-to: <CAH9JG2VgaSHyTMHxD7xSgu+Ugez9tD3ucDH_XC_n2VDfH+hxfw@mail.gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com
Message-id: <4F27C906.6060800@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
 <1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
 <CAH9JG2VgaSHyTMHxD7xSgu+Ugez9tD3ucDH_XC_n2VDfH+hxfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.01.2012 11:39, Kyungmin Park wrote:

Dear Mr Park

> restart is also required.

Thanks for this catching this omission. I'll add it in next patch.

Regards,

> On 1/31/12, Karol Lewandowski<k.lewandowsk@samsung.com>  wrote:
>> Commit 4e44d2cb95bd ("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER")
>> converted all exynos boards but exynos4-dt.c.
>>
>> This commit fixes that omission.
>>
>> Signed-off-by: Karol Lewandowski<k.lewandowsk@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> Cc: Thomas Abraham<thomas.abraham@linaro.org>
>> Cc: Kukjin Kim<kgene.kim@samsung.com>
>> Cc: Marc Zyngier<marc.zyngier@arm.com>
>> ---
>>   arch/arm/mach-exynos/mach-exynos4-dt.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c
>> b/arch/arm/mach-exynos/mach-exynos4-dt.c
>> index 98e79c9..8aef6aa 100644
>> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
>> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
>> @@ -15,6 +15,7 @@
>>   #include<linux/serial_core.h>
>>
>>   #include<asm/mach/arch.h>
>> +#include<asm/hardware/gic.h>
>>   #include<mach/map.h>
>>
>>   #include<plat/cpu.h>
>> @@ -83,4 +84,5 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4
>> (Flattened Device Tree)")
>>   	.init_machine	= exynos4210_dt_machine_init,
>>   	.timer		=&exynos4_timer,
>>   	.dt_compat	= exynos4210_dt_compat,
>> +	.handle_irq	= gic_handle_irq,
>>   MACHINE_END
>> --
>> 1.7.8.3

-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
