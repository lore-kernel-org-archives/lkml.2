Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0GEI4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:56:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54643 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab0GEI4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:56:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NFbLlP7QUxg+niyLgrlQW
Date: Mon, 5 Jul 2010 11:56:56 +0300
From: Tony Lindgren <tony@atomide.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Lam <lzg@ema-tech.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: [PATCH 21/33] Removing dead OMAP2_VENC_OUT_TYPE_SVIDEO,
 OMAP2_VENC_OUT_TYPE_COMPOSITE
Message-ID: <20100705085654.GL15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <2709d1406900af2436f6f8af00555507baf8dac9.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2709d1406900af2436f6f8af00555507baf8dac9.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Egger <siccegge@cs.fau.de> [100630 18:58]:
> OMAP2_VENC_OUT_TYPE_SVIDEO, OMAP2_VENC_OUT_TYPE_COMPOSITE doesn't
> exist in Kconfig, therefore removing all references for it from the
> source code.

Let's let Tomi figure out this one, added him to Cc.

Regards,

Tony
 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-omap2/board-omap3stalker.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
> index f848ba8..b38afd5 100644
> --- a/arch/arm/mach-omap2/board-omap3stalker.c
> +++ b/arch/arm/mach-omap2/board-omap3stalker.c
> @@ -181,11 +181,6 @@ static struct omap_dss_device omap3_stalker_tv_device = {
>  	.name			= "tv",
>  	.driver_name		= "venc",
>  	.type			= OMAP_DISPLAY_TYPE_VENC,
> -#if defined(CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO)
> -	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
> -#elif defined(CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE)
> -	.u.venc.type		= OMAP_DSS_VENC_TYPE_COMPOSITE,
> -#endif
>  	.platform_enable	= omap3_stalker_enable_tv,
>  	.platform_disable	= omap3_stalker_disable_tv,
>  };
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
