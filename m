Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1GROwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:52:14 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57572 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab1GROwM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:52:12 -0400
From: Kevin Hilman <khilman@ti.com>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] omap1: select GENERIC_IRQ_CHIP for TI OMAP1
Organization: Texas Instruments, Inc.
References: <1309251943.3984.1.camel@phoenix> <87boxi2eep.fsf@ti.com>
	<CAF+7xW=DKMi9doKm0XH0+EvJLX0gzUE0_TqrZNrqHqvjuSeHdA@mail.gmail.com>
Date: Mon, 18 Jul 2011 07:52:07 -0700
In-Reply-To: <CAF+7xW=DKMi9doKm0XH0+EvJLX0gzUE0_TqrZNrqHqvjuSeHdA@mail.gmail.com>
	(Axel Lin's message of "Sun, 17 Jul 2011 21:38:56 +0800")
Message-ID: <87aacbmyjs.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> 2011/6/28 Kevin Hilman <khilman@ti.com>:
>> Axel Lin <axel.lin@gmail.com> writes:
>>
>>> The gpio-omap driver has been converted to use generic IRQ chip.
>>> Thus select GENERIC_IRQ_CHIP for TI OMAP1 to fix below build error.
>>>
>>>   LD      vmlinux
>>> drivers/built-in.o: In function `omap_mpuio_alloc_gc':
>>> drivers/gpio/gpio-omap.c:1087: undefined reference to `irq_alloc_generic_chip'
>>> drivers/gpio/gpio-omap.c:1100: undefined reference to `irq_setup_generic_chip'
>>> drivers/built-in.o: In function `omap_gpio_show_rev':
>>> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_clr_bit'
>>> drivers/gpio/gpio-omap.c:998: undefined reference to `irq_gc_mask_set_bit'
>>> make: *** [vmlinux] Error 1
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>
>> Thanks, I have a fix for this already queued for v3.0-rc3 series:
>>
>>        http://marc.info/?l=linux-omap&m=130749135312468&w=2
>>
> 
> Seems this patch is not upstream.
> I still have the same build error with  [linux-next: Tree for July 16].

Hmm, you're right.  Tony hasn't queued that fix yet.

Tony?

Kevin
