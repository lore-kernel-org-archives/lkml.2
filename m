Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430Ab2ILQbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:31:31 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48385 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab2ILQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:31:30 -0400
Date: Wed, 12 Sep 2012 22:00:54 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: <marc.zyngier@arm.com>
Cc: <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>
Subject: Re: Fwd: [PATCH v9 07/13] ARM: SoC: convert ux500 to SoC descriptor
Message-ID: <20120912163053.GA10988@bnru02>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
 <1347461906-13527-8-git-send-email-arnd@arndb.de>
 <CAE2-_9o5gEpEddGLvRRA=pe=vroTnBXmGmoBO1Ojos-hOJXQAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE2-_9o5gEpEddGLvRRA=pe=vroTnBXmGmoBO1Ojos-hOJXQAQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> 
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Convert ux500 platforms to use the SoC descriptor to provide
> their SMP and CPU hotplug operations.
> 
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-ux500/board-mop500.c       |    4 ++++
>  arch/arm/mach-ux500/hotplug.c            |   36 ++++++++----------------------
>  arch/arm/mach-ux500/include/mach/setup.h |    3 +++
>  arch/arm/mach-ux500/platsmp.c            |   18 +++++++++++----
>  4 files changed, 30 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index a534d88..1c6f74b 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -694,6 +694,7 @@ static void __init hrefv60_init_machine(void)
>  MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
>         /* Maintainer: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com> */
>         .atag_offset    = 0x100,
> +       .smp            = smp_ops(ux500_smp_ops),
>         .map_io         = u8500_map_io,
>         .init_irq       = ux500_init_irq,
>         /* we re-use nomadik timer here */
> @@ -705,6 +706,7 @@ MACHINE_END

This looks like mips way doing smp operations.

I have not tested the patch series, will do later.

Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

/srinidhi
