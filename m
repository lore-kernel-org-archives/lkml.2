Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2EHMtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:49:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42448 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2EHMtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <1336472347-25822-1-git-send-email-dedekind1@gmail.com>
References: <1336472347-25822-1-git-send-email-dedekind1@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Tue, 8 May 2012 14:48:41 +0200
Message-ID: <CAOiHx==iC27f=frCedDH2xahaK=HBzXBxrWhb-AuG+vcCqSUCw@mail.gmail.com>
Subject: Re: [PATCH] mips: bcm63xx: fix compilation problems
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On 8 May 2012 12:19, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>
> I get the following build error when I am compiling the MTD gpio-nand driver
> for bcm63xx:
>
> In file included from arch/mips/include/asm/mach-bcm63xx/gpio.h:4:0,
>                 from arch/mips/include/asm/gpio.h:4,
>                 from include/linux/gpio.h:36,
>                 from drivers/mtd/maps/gpio-addr-flash.c:16:
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h: In function 'bcm63xx_gpio_count':
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:10:2: error: implicit declaration of function 'bcm63xx_get_cpu_id' [-Werror=implicit-function-declaration]
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: error: 'BCM6358_CPU_ID' undeclared (first use in this function)
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: note: each undeclared identifier is reported only once for each function it appears in
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:13:7: error: 'BCM6338_CPU_ID' undeclared (first use in this function)
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:15:7: error: 'BCM6345_CPU_ID' undeclared (first use in this function)
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:17:7: error: 'BCM6368_CPU_ID' undeclared (first use in this function)
> arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:19:7: error: 'BCM6348_CPU_ID' undeclared (first use in this function)
>
> (snip)

I already submitted almost the same patch ~3 months ago:
http://patchwork.linux-mips.org/patch/3351/

> This patch sloves the problem.

"sloves"? ;p


Jonas
