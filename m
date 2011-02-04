Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1BDBaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:30:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25413 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1BDBaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:30:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/fh/smn6Rm4NRH+TnhUnxG
Date: Thu, 3 Feb 2011 17:29:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        trivial@kernel.org
Subject: Re: [PATCH][trivial] ARM, OMAP, timer: Remove duplicate inclusion
 of linux/sched.h from arch/arm/mach-omap1/time.c
Message-ID: <20110204012953.GO3322@atomide.com>
References: <alpine.LNX.2.00.1102032255090.1369@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1102032255090.1369@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl <jj@chaosbits.net> [110203 13:57]:
> arch/arm/mach-omap1/time.c includes linux/sched.h twice - it's enough to 
> do it once. This removes the duplicate.

Thanks, already have a similar fix queued in my devel-fixes branch.

Regards,

Tony
 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  time.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
> index f83fc33..6885d2f 100644
> --- a/arch/arm/mach-omap1/time.c
> +++ b/arch/arm/mach-omap1/time.c
> @@ -44,7 +44,6 @@
>  #include <linux/clocksource.h>
>  #include <linux/clockchips.h>
>  #include <linux/io.h>
> -#include <linux/sched.h>
>  
>  #include <asm/system.h>
>  #include <mach/hardware.h>
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
