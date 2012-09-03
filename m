Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2ICLkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:40:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59854 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2ICLkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:40:45 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CACRpkdYxYGa=C092rbTU5bo=YEu6wqiTUD7W4pLS_wNfmAe4Zw@mail.gmail.com>
References: <1346588747.7909.2.camel@phoenix> <CACRpkdYxYGa=C092rbTU5bo=YEu6wqiTUD7W4pLS_wNfmAe4Zw@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 3 Sep 2012 19:40:24 +0800
Message-ID: <CAF+7xWnwH17Bxjpm3nMAJL45D4XUsEfDpJAoG=feJwKtgwpUkw@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Fix build error due to missing include of
 asm/pmu.h in cpu-db8500.c
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/3 Linus Walleij <linus.walleij@linaro.org>:
> On Sun, Sep 2, 2012 at 2:25 PM, Axel Lin <axel.lin@gmail.com> wrote:
>
>> Include asm/pmu.h to fix below build error:
>>
>>   CC      arch/arm/mach-ux500/cpu-db8500.o
>> arch/arm/mach-ux500/cpu-db8500.c:118:8: error: variable 'db8500_pmu_platdata' has initializer but incomplete type
>> arch/arm/mach-ux500/cpu-db8500.c:119:2: error: unknown field 'handle_irq' specified in initializer
>> arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: excess elements in struct initializer [enabled by default]
>> arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: (near initialization for 'db8500_pmu_platdata') [enabled by default]
>> make[1]: *** [arch/arm/mach-ux500/cpu-db8500.o] Error 1
>> make: *** [arch/arm/mach-ux500] Error 2
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> That's on linux-next not on v3.6-rcN right?
Yes, This patch is against linux-next tree.

>
> I've applied it to my ux500 branch and will carry it unless Will Deacon
> express an interest in it, PMU is his territory...

Thanks,
Axel
