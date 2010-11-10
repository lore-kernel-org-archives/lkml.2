Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0KJPvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:51:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57520 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0KJPvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:51:45 -0500
X-SpamScore: -36
X-BigFish: VS-36(zz542N1432N98dN1447R9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
Date: Wed, 10 Nov 2010 08:51:19 -0700
Message-ID: <86A0E76937111F4C92FABEC0A20988510523D224@az33exm21>
In-Reply-To: <20101109214607.GG6017@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
Thread-Index: AcuAV6brtXgPpU38Tcev9bFRIK//yAAls4kA
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <20101109214607.GG6017@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <u.kleine-koenig@pengutronix.de>,
        <amit.kucheria@canonical.com>, <eric@eukrea.com>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

>-----Original Message-----
>From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
>Sent: Tuesday, November 09, 2010 3:46 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux@arm.linux.org.uk;
>u.kleine-koenig@pengutronix.de; amit.kucheria@canonical.com;
eric@eukrea.com
>Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
>
>Hi Dinh,
>
>On Fri, Nov 05, 2010 at 10:55:50AM -0500, Dinh.Nguyen@freescale.com
wrote:
>> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>>
>> Add iomux, clocks,  and memory map for Freescale's MX53 SoC.
>> Add cpu_is_mx53 function to common.h.
>> Add 3 more banks of gpio's to mxc_gpio_ports.
>> Add MX53 phys offset address.
>>
>> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> ---
>>  arch/arm/mach-mx5/clock-mx53.c              |  857
+++++++++++++++++++++++++++
>>  arch/arm/mach-mx5/devices.c                 |   27 +
>>  arch/arm/plat-mxc/include/mach/common.h     |    4 +
>>  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  303 ++++++++++
>>  arch/arm/plat-mxc/include/mach/memory.h     |    1 +
>>  arch/arm/plat-mxc/include/mach/mx53.h       |  406 +++++++++++++
>>  6 files changed, 1598 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/arm/mach-mx5/clock-mx53.c
>>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
>>  create mode 100644 arch/arm/plat-mxc/include/mach/mx53.h
>>
>> diff --git a/arch/arm/mach-mx5/clock-mx53.c
b/arch/arm/mach-mx5/clock-mx53.c
>> new file mode 100644
>> index 0000000..d547cb8
>> --- /dev/null
>> +++ b/arch/arm/mach-mx5/clock-mx53.c
>
>Most of this code looks like it could be shared with clock-mx51.c

Agreed, but I was unsure how to proceed with adding clock code for mx53.
Should I merge mx53 clock code into clock-mx51 and rename clock-mx51? 

>
>> +extern int mx53_revision(void);
>> +#endif
>> +
>> +#endif	/* ifndef __MACH_H__ */
>
>__MACH_MX53_H__
>
>> --
>> 1.6.0.4
>>
>>
>>
>
>--
>Pengutronix e.K.                           |
|
>Industrial Linux Solutions                 | http://www.pengutronix.de/
|
>Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0
|
>Amtsgericht Hildesheim, HRA 2686           | Fax:
+49-5121-206917-5555 |

Thanks for the review,

Dinh


