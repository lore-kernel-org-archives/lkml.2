Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1GQNjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 09:39:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36180 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1GQNjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 09:39:17 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <87boxi2eep.fsf@ti.com>
References: <1309251943.3984.1.camel@phoenix> <87boxi2eep.fsf@ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 17 Jul 2011 21:38:56 +0800
Message-ID: <CAF+7xW=DKMi9doKm0XH0+EvJLX0gzUE0_TqrZNrqHqvjuSeHdA@mail.gmail.com>
Subject: Re: [PATCH] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
To: Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/28 Kevin Hilman <khilman@ti.com>:
> Axel Lin <axel.lin@gmail.com> writes:
>
>> The gpio-omap driver has been converted to use generic IRQ chip.
>> Thus select GENERIC_IRQ_CHIP for TI OMAP1 to fix below build error.
>>
>>   LD      vmlinux
>> drivers/built-in.o: In function `omap_mpuio_alloc_gc':
>> drivers/gpio/gpio-omap.c:1087: undefined reference to `irq_alloc_generic_chip'
>> drivers/gpio/gpio-omap.c:1100: undefined reference to `irq_setup_generic_chip'
>> drivers/built-in.o: In function `omap_gpio_show_rev':
>> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_clr_bit'
>> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_set_bit'
>> make: *** [vmlinux] Error 1
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Thanks, I have a fix for this already queued for v3.0-rc3 series:
>
>        http://marc.info/?l=linux-omap&m=130749135312468&w=2
>
Hi,
Seems this patch is not upstream.
I still have the same build error with  [linux-next: Tree for July 16].

Regards,
Axel
