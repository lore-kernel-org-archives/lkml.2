Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab0IXW6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:58:23 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56899 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab0IXW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:58:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19w04tbiun4yfUC4TcYBoau
Date: Fri, 24 Sep 2010 15:58:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] Adding LogicPD OMAP3 board support
Message-ID: <20100924225818.GL4211@atomide.com>
References: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
 <1285358338-3403-2-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285358338-3403-2-git-send-email-tim.nordell@logicpd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tim Nordell <tim.nordell@logicpd.com> [100924 13:06]:
> Adding support for LogicPD's OMAP 3530 LV SOM and
> OMAP 35x Torpedo board.
> 
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,6 +135,24 @@ config MACH_OMAP_LDP
>  	default y
>  	select OMAP_PACKAGE_CBB
>  
> +config MACH_OMAP3530_LV_SOM
> +	bool "OMAP3 Logic 3530 LV SOM board"
> +	depends on ARCH_OMAP3
> +	default y
> +	help
> +	 Support for the LogicPD OMAP3530 SOM Development kit
> +	 for full description please see the products webpage at
> +	 http://www.logicpd.com/products/development-kits/texas-instruments-zoom%E2%84%A2-omap35x-development-kit
> +
> +config MACH_OMAP3_TORPEDO
> +	bool "OMAP3 Logic 35x Torpedo board"
> +	depends on ARCH_OMAP3
> +	default y
> +	help
> +	 Support for the LogicPD OMAP35x Torpedo Development kit
> +	 for full description please see the products webpage at
> +	 http://www.logicpd.com/products/development-kits/zoom-omap35x-torpedo-development-kit
> +

Missing select OMAP_PACKAGE_XXX for both boards?

Also, please add the DEBUG_LL entries to
arch/arm/plat-omap/include/plat/uncompress.h. You can test
that by enabling DEBUG_LL and EARLY_PRINTK and have earlyprintk
in your kernel cmdline.

And please repost the whole series so linux-arm-kernel
list is also Cc'd.

Regards,

Tony
