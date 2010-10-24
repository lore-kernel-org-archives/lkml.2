Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0JXOXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 10:23:48 -0400
Received: from www.tglx.de ([62.245.132.106]:51729 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0JXOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:23:47 -0400
Date: Sun, 24 Oct 2010 16:22:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Serafeim Zanikolas <sez@debian.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: jiffies.c: fix typos in comment
In-Reply-To: <1287849986-5936-1-git-send-email-sez@debian.org>
Message-ID: <alpine.LFD.2.00.1010241618480.8736@localhost6.localdomain6>
References: <1287849986-5936-1-git-send-email-sez@debian.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Oct 2010, Serafeim Zanikolas wrote:

> 
> Signed-off-by: Serafeim Zanikolas <sez@debian.org>
> ---
>  kernel/time/jiffies.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 5404a84..12ba9a7 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -30,8 +30,8 @@
>   * the timer interrupt frequency HZ and it suffers
>   * inaccuracies caused by missed or lost timer
>   * interrupts and the inability for the timer
> - * interrupt hardware to accuratly tick at the
> - * requested HZ value. It is also not reccomended
> + * interrupt hardware to accurately tick at the
> + * requested HZ value. It is also not recommended
>   * for "tick-less" systems.

You are not only correcting a typo. You are changing the sense of the
comment, unfortunately in the wrong way.

Why wouldn't it be recommended that the interrupt hardware ticks at
the requested HZ value ? 

The inability of it to tick accurately at the requested HZ value is
one of the causes which make jiffies clocksource inaccurate. And that
what the comment says.

Thanks,

	tglx
