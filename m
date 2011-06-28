Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1F1PDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:03:52 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:42076 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758580Ab1F1PBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:01:22 -0400
From: Kevin Hilman <khilman@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
Organization: Texas Instruments, Inc.
References: <1309251943.3984.1.camel@phoenix>
Date: Tue, 28 Jun 2011 07:56:14 -0700
In-Reply-To: <1309251943.3984.1.camel@phoenix> (Axel Lin's message of "Tue, 28
	Jun 2011 17:05:43 +0800")
Message-ID: <87boxi2eep.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> The gpio-omap driver has been converted to use generic IRQ chip.
> Thus select GENERIC_IRQ_CHIP for TI OMAP1 to fix below build error.
>
>   LD      vmlinux
> drivers/built-in.o: In function `omap_mpuio_alloc_gc':
> drivers/gpio/gpio-omap.c:1087: undefined reference to `irq_alloc_generic_chip'
> drivers/gpio/gpio-omap.c:1100: undefined reference to `irq_setup_generic_chip'
> drivers/built-in.o: In function `omap_gpio_show_rev':
> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_clr_bit'
> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_set_bit'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, I have a fix for this already queued for v3.0-rc3 series:

        http://marc.info/?l=linux-omap&m=130749135312468&w=2

Kevin
