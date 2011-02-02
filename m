Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1BBUUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:20:41 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11572 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1BBUUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:20:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/6I/VTQ6Wq/l8l3LzqyUim
Date: Wed, 2 Feb 2011 12:20:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] arm: Kconfig: allow OMAP to use sparse IRQ
 numbering
Message-ID: <20110202202026.GH3322@atomide.com>
References: <1296664315-32108-1-git-send-email-balbi@ti.com>
 <1296664315-32108-3-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296664315-32108-3-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [110202 08:31]:
> Select HAVE_SPARSE_IRQ to allow OMAP to use
> sparse IRQ numbering scheme. The main difference
> is that irq_descs will be added to a radix tree
> instead of a static array.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Assuming these two will go through Russell's tree:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 09a5c11..2ca24ad 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -857,6 +857,7 @@ config ARCH_DAVINCI
>  config ARCH_OMAP
>  	bool "TI OMAP"
>  	select HAVE_CLK
> +	select HAVE_SPARSE_IRQ
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARCH_HAS_CPUFREQ
>  	select GENERIC_CLOCKEVENTS
> -- 
> 1.7.4.rc2
> 
