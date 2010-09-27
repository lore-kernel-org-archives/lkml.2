Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab0I0PLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:11:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51858 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0I0PK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r6fYFSr2MyMTc/2j7kUAyCUdDnkMdwOVgPv5cwqncnN2c0m2zD6i+j+6Nqini8gdgp
         moMSuW8zutE34wMwAs7hHP8QOksDIirF7hSlJBKSjDhZPjykCZ6r1JEbOW0vJOdhdCeW
         bsGdBySSskTcOZ7M5SZUELkrRDIis46TqEIXE=
MIME-Version: 1.0
In-Reply-To: <20100927121842.240806983@linutronix.de>
References: <20100927121651.904100669@linutronix.de>
	<20100927121842.240806983@linutronix.de>
Date: Mon, 27 Sep 2010 17:10:58 +0200
X-Google-Sender-Auth: EDf1WG_sWafbW__Rgh_giVTkCWU
Message-ID: <AANLkTimpavoLaAeY7dXPh7-596+xK0ZFxYMb8AHT6fv1@mail.gmail.com>
Subject: Re: [patch 08/19] genirq; Provide compat handling for chip->mask_ack()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 14:44, Thomas Gleixner <tglx@linutronix.de> wrote:
> Wrap the old chip function mask_ack() until the migration is complete
> and the old chip functions are removed.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/irq/chip.c      |   20 ++++++++++++++++++--
>  kernel/irq/internals.h |   17 +++++++++++------
>  kernel/irq/manage.c    |   22 +++++++++++-----------
>  3 files changed, 40 insertions(+), 19 deletions(-)

3 files

> Index: linux-2.6-tip/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/chip.c
> +++ linux-2.6-tip/kernel/irq/chip.c

Only 1 file?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
