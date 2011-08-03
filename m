Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1HCRe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:34:56 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37615 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab1HCRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:34:45 -0400
From: Kevin Hilman <khilman@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
Organization: Texas Instruments, Inc.
References: <1312355897.14329.5.camel@phoenix>
Date: Wed, 03 Aug 2011 10:34:36 -0700
In-Reply-To: <1312355897.14329.5.camel@phoenix> (Axel Lin's message of "Wed,
	03 Aug 2011 15:18:17 +0800")
Message-ID: <8762me761f.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Axel Lin <axel.lin@gmail.com> writes:

> The gpio-omap driver has been converted to use generic IRQ chip.
> Thus select GENERIC_IRQ_CHIP for TI OMAP1 to fix below build error.
>
>  LD      vmlinux
> drivers/built-in.o: In function `omap_mpuio_alloc_gc':
> drivers/gpio/gpio-omap.c:1087: undefined reference to `irq_alloc_generic_chip'
> drivers/gpio/gpio-omap.c:1100: undefined reference to `irq_setup_generic_chip'
> drivers/built-in.o: In function `omap_gpio_show_rev':
> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_clr_bit'
> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_set_bit'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Kevin already sent a similar patch.  http://marc.info/?l=linux-omap&m=130749135312468&w=2
> But I still have the build error with make omap1_defconfig in today's linux-next tree.
> So here is a resend.

Tony didn't pick this up for v3.1, so I now have the original in my
fixies queue for v3.1-rc, which will be posted shortly.

Sorry this has slipped through the cracks.

Kevin
