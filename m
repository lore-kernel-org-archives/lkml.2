Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab2KEPoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:44:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42934 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2KEPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:44:03 -0500
Message-ID: <5097DEB4.8040907@ti.com>
Date: Mon, 5 Nov 2012 10:43:48 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 10/11] ARM: davinci - migrate to common clock
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-11-git-send-email-m-karicheri2@ti.com> <50966861.4040500@ti.com>
In-Reply-To: <50966861.4040500@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 08:06 AM, Sekhar Nori wrote:
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> Currently migrate only DM644x as this is being reviewed. Once all
>> platforms are migrated, the Makefile will be cleaned up to remove
>> obsoleted files clock.o and psc.o
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>>   arch/arm/Kconfig               |    1 +
>>   arch/arm/mach-davinci/Kconfig  |    2 ++
>>   arch/arm/mach-davinci/Makefile |   11 ++++++++++-
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index c5f9ae5..4611987 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -967,6 +967,7 @@ config ARCH_DAVINCI
>>   	select ARCH_REQUIRE_GPIOLIB
>>   	select ZONE_DMA
>>   	select HAVE_IDE
>> +	select COMMON_CLK
>>   	select CLKDEV_LOOKUP
>>   	select GENERIC_ALLOCATOR
>>   	select GENERIC_IRQ_CHIP
> This list has to be sorted. Russell has a patch which fixed this all
> across arch/arm/* which got merged for v3.7. This patch does not apply
> to v3.7-rc3 anymore due to the same reason.
>
> Thanks,
> Sekhar
>
Ok. Will do.
