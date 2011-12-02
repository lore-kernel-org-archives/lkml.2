Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1LBJYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:24:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36496 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1LBJYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:24:42 -0500
Message-ID: <4ED89956.9060908@arm.com>
Date: Fri, 02 Dec 2011 09:24:38 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Axel Lin'" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: exynos4: Fix build error due to 'gic_bank_offset'
 undeclared
References: <1322753070.11611.0.camel@phoenix> <4ED7ADCE.8040609@arm.com> <04f701ccb0ce$7c044d30$740ce790$%kim@samsung.com>
In-Reply-To: <04f701ccb0ce$7c044d30$740ce790$%kim@samsung.com>
X-Enigmail-Version: 1.4a1pre
X-OriginalArrivalTime: 02 Dec 2011 09:24:36.0784 (UTC) FILETIME=[35BA0300:01CCB0D4]
X-MC-Unique: 111120209243807101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/11 08:43, Kukjin Kim wrote:
> Marc Zyngier wrote:
>>
>> On 01/12/11 15:24, Axel Lin wrote:
>>> Fix below build error:
>>>   CC      arch/arm/mach-exynos/cpu.o
>>> arch/arm/mach-exynos/cpu.c: In function 'exynos4_init_irq':
>>> arch/arm/mach-exynos/cpu.c:245: error: 'gic_bank_offset' undeclared
>> (first use in this function)
>>> arch/arm/mach-exynos/cpu.c:245: error: (Each undeclared identifier is
>> reported only once
>>> arch/arm/mach-exynos/cpu.c:245: error: for each function it appears in.)
>>> arch/arm/mach-exynos/cpu.c:243: warning: unused variable 'bank_offset'
>>> make[1]: *** [arch/arm/mach-exynos/cpu.o] Error 1
>>> make: *** [arch/arm/mach-exynos] Error 2
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>
>> Arghhh... My bad. Thanks for fixing that.
>>
>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>
> Hi Marc,
> 
> Since the commit 4e44d2cb("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER") is not in my tree, this should be handled in your tree and Axel's patch, "ARM: exynos4: Fix build error" is too.

Hi Kukjin,

No problem, I'll take these through my tree and send a pull request to
Russell.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

