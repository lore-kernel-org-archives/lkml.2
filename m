Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab0JFQFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:05:20 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59180 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759299Ab0JFQFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:05:15 -0400
X-SpamScore: -29
X-BigFish: VS-29(zz542N1432N98dN179dN9371Pc8kzz1202hzz8275bh8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
x-cr-hashedpuzzle: DBeA ExYa F/XG IOsB QOND Q9iF SrMf Vxqy an+c zxBS 2nFO 6I09 7Jpt 7Yc5 9kce AE2QiQ==;9;YQBtAGkAdAAuAGsAdQBjAGgAZQByAGkAYQBAAGMAYQBuAG8AbgBpAGMAYQBsAC4AYwBvAG0AOwBkAGEAbgBpAGUAbABAAGMAYQBpAGEAcQAuAGQAZQA7AGcAcgBhAG4AdAAuAGwAaQBrAGUAbAB5AEAAcwBlAGMAcgBlAHQAbABhAGIALgBjAGEAOwBsAGkAbgB1AHgALQBhAHIAbQAtAGsAZQByAG4AZQBsAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAC4AcwBjAGgAdwBlAGIAZQBsAEAAcABlAG4AZwB1AHQAcgBvAG4AaQB4AC4AZABlADsAcwAuAGgAYQB1AGUAcgBAAHAAZQBuAGcAdQB0AHIAbwBuAGkAeAAuAGQAZQA7AHUALgBrAGwAZQBpAG4AZQAtAGsAbwBlAG4AaQBnAEAAcABlAG4AZwB1AHQAcgBvAG4AaQB4AC4AZABlADsAdgBhAGwAZQBuAHQAaQBuAC4AbABvAG4AZwBjAGgAYQBtAHAAQABlAHAAZgBsAC4AYwBoAA==;Sosha1_v1;7;{B617AF52-BE09-4E8F-85E0-60DF50B26780};cgAwADAAMAA5ADEAQABmAHIAZQBlAHMAYwBhAGwAZQAuAGMAbwBtAA==;Wed, 06 Oct 2010 16:04:45 GMT;UgBFADoAIABbAFAAQQBUAEMASAB2ADMAXQAgAEEAUgBNADoAIABpAG0AeAA6ACAAQQBkAGQAIABpAHIAYQBtACAAYQBsAGwAbw
 BjAGEAdA
	BvAHIAIABmAHUAbgBjAHQAaQBvAG4AcwA=
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {B617AF52-BE09-4E8F-85E0-60DF50B26780}
Content-Class: urn:content-classes:message
Subject: RE: [PATCHv3] ARM: imx: Add iram allocator functions
Date: Wed, 6 Oct 2010 09:04:45 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851050F1654@az33exm21>
In-Reply-To: <20101005202239.GB11737@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv3] ARM: imx: Add iram allocator functions
Thread-Index: ActkyxnExQDKxYAlRCSjA2RWBH9xUQApAugg
References: <1286307715-12276-1-git-send-email-Dinh.Nguyen@freescale.com> <20101005202239.GB11737@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <amit.kucheria@canonical.com>,
        <s.hauer@pengutronix.de>, <grant.likely@secretlab.ca>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <r.schwebel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Uwe
>Kleine-König
>Sent: Tuesday, October 05, 2010 3:23 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; amit.kucheria@canonical.com; s.hauer@pengutronix.de;
>grant.likely@secretlab.ca; valentin.longchamp@epfl.ch; daniel@caiaq.de; Zhang Lily-R58066;
>r.schwebel@pengutronix.de; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCHv3] ARM: imx: Add iram allocator functions
>
>Hello,
>
>On Tue, Oct 05, 2010 at 02:41:55PM -0500, Dinh.Nguyen@freescale.com wrote:
>> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>>
>> Add iram allocation functions using GENERIC_ALLOCATOR. The
>> allocation size is 4KB multiples to guarantee alignment. The
>> idea for these functions is for i.MX platforms to use them
>> to dynamically allocate IRAM usage.
>>
>> Applies on 2.6.36-rc6
>>
>> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
>> ---
>>  arch/arm/plat-mxc/Kconfig                   |    9 ++++
>>  arch/arm/plat-mxc/Makefile                  |    1 +
>>  arch/arm/plat-mxc/include/mach/iram_alloc.h |   35 +++++++++++++++
>>  arch/arm/plat-mxc/iram.c                    |   62 +++++++++++++++++++++++++++
>>  4 files changed, 107 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/plat-mxc/include/mach/iram_alloc.h
>>  create mode 100644 arch/arm/plat-mxc/iram.c
>>
>> diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
>> index 6785db4..e6de0df 100644
>> --- a/arch/arm/plat-mxc/Kconfig
>> +++ b/arch/arm/plat-mxc/Kconfig
>> @@ -57,6 +57,15 @@ source "arch/arm/mach-mx5/Kconfig"
>>
>>  endmenu
>>
>> +config IRAM_ALLOC
>> +	bool "Enable IRAM allocator"
>> +	select GENERIC_ALLOCATOR
>> +	help
>> +	  Select this to have access to generic IRAM allocation functions that
>> +	  use the GENERIC_ALLOCATOR.  The allocation size is 4KB multiples to
>> +	  guarantee alignment. The idea for these functions is for i.MX platforms
>> +	  to use them to dynamically allocate IRAM usage.
>> +
>I thought you didn't want to have that user selectible?
>
>>  config MXC_IRQ_PRIOR
>>  	bool "Use IRQ priority"
>>  	help
>> diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
>> index 78d405e..35cf07b 100644
>> --- a/arch/arm/plat-mxc/Makefile
>> +++ b/arch/arm/plat-mxc/Makefile
>> @@ -10,6 +10,7 @@ obj-$(CONFIG_MXC_TZIC) += tzic.o
>>
>>  obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
>>  obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
>> +obj-$(CONFIG_IRAM_ALLOC) += iram.o
>>  obj-$(CONFIG_MXC_PWM)  += pwm.o
>>  obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
>>  obj-$(CONFIG_MXC_ULPI) += ulpi.o
>> diff --git a/arch/arm/plat-mxc/include/mach/iram_alloc.h b/arch/arm/plat-
>mxc/include/mach/iram_alloc.h
>> new file mode 100644
>> index 0000000..12881aa
>> --- /dev/null
>> +++ b/arch/arm/plat-mxc/include/mach/iram_alloc.h
>> @@ -0,0 +1,35 @@
>> +/*
>> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
>> + * MA 02110-1301, USA.
>> + */
>> +
>> +#ifdef CONFIG_IRAM_ALLOC
>> +int __init iram_init(unsigned long base, unsigned long size);
>> +void *iram_alloc(unsigned int size, unsigned long *dma_addr);
>> +void iram_free(unsigned long dma_addr, unsigned int size);
>> +#else
>> +static inline int __init iram_init(unsigned long base, unsigned long size)
>> +{
>> +	return -ENOMEM;
>> +}
>> +static inline void *iram_alloc(unsigned int size, unsigned long *dma_addr)
>> +{
>> +	return NULL;
>> +}
>> +static inline void iram_free(unsigned long base, unsigned long size) {}
>> +#endif
>> +
>please remove trailing newlines
Will fix in PATCHv4

>
>> diff --git a/arch/arm/plat-mxc/iram.c b/arch/arm/plat-mxc/iram.c
>> new file mode 100644
>> index 0000000..d59fe75
>> --- /dev/null
>> +++ b/arch/arm/plat-mxc/iram.c
>> @@ -0,0 +1,62 @@
>> +/*
>> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
>> + * MA 02110-1301, USA.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/spinlock.h>
>Hmm, I have a déjà vu, and that's already the second time in this mail.
>IIRC I asked you to remove spinlock.h and use linux/init.h insteadof
>linux/module.h.

I apologize for missing this comment on the previous review. It appears that I need to include linux/spinlock.h, otherwise I get a compile error.

include/linux/genalloc.h:16: error: expected specifier-qualifier-list before 'rwlock_t'
include/linux/genalloc.h:25: error: expected specifier-qualifier-list before 'spinlock_t'

>
>> +#include <linux/genalloc.h>
>> +
>> +static unsigned long iram_phys_base;
>> +static __iomem void *iram_virt_base;
>> +static struct gen_pool *iram_pool;
>> +
>> +#define iram_phys_to_virt(p) (iram_virt_base + ((p) - iram_phys_base))
>> +
>> +void *iram_alloc(unsigned int size, unsigned long *dma_addr)
>> +{
>> +	if (!iram_pool)
>> +		return NULL;
>> +
>> +	*dma_addr = gen_pool_alloc(iram_pool, size);
>> +	pr_debug("iram alloc - %dB@0x%p\n", size, (void *)*dma_addr);
>> +	return iram_phys_to_virt(*dma_addr);
>> +}
>> +EXPORT_SYMBOL(iram_alloc);
>> +



