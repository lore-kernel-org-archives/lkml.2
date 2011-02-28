Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1B1Qzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:55:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18273 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1B1Qzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:55:36 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8OPKVxlWg8UvWF3y9Xc32
Date: Mon, 28 Feb 2011 08:55:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21]arch:arm:Kconfig remove one to many l's in the
 word.
Message-ID: <20110228165530.GI20560@atomide.com>
References: <1298614175-3456-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298614175-3456-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Justin P. Mattock <justinmattock@gmail.com> [110224 22:08]:
> The patch below removes an extra "l" in the word.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: Tony Lindgren <tony@atomide.com>
 
> ---
>  arch/arm/plat-omap/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index b6333ae..cd5f993 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -54,7 +54,7 @@ config OMAP_SMARTREFLEX
>  	  user must write 1 to
>  		/debug/voltage/vdd_<X>/smartreflex/autocomp,
>  	  where X is mpu or core for OMAP3.
> -	  Optionallly autocompensation can be enabled in the kernel
> +	  Optionally autocompensation can be enabled in the kernel
>  	  by default during system init via the enable_on_init flag
>  	  which an be passed as platform data to the smartreflex driver.
>  
> -- 
> 1.7.4.1
> 
