Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab2EPHLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:11:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46855 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342Ab2EPHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120515154333.6659.66479.sendpatchset@w520>
References: <20120515154333.6659.66479.sendpatchset@w520>
Date: Wed, 16 May 2012 09:11:14 +0200
Message-ID: <CACRpkdb9LbjvobsJf61VA1Nt8-UCwDZzmjqC8JuN8WPdvhq+iQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 5:43 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> This patch is V2 of the Emma Mobile GPIO driver. This
> driver is designed to be reusable between multiple SoCs
> that share the same basic building block, but so far it
> has only been used on Emma Mobile EV2.
>
> Each driver instance handles 32 GPIOs with individually
> maskable IRQs. The driver operates on two I/O memory
> ranges and the 32 GPIOs are hooked up to two interrupts.
>
> In the case of Emma Mobile EV2 this GPIO building block
> is used as main external interrupt controller hooking up
> 159 GPIOS as 159 interrupts via 5 driver instances and
> 10 interrupts to the GIC and the Cortex-A9 Dual.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

V2 is fair enough for me, so feel free to add:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
