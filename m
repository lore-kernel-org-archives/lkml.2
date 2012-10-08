Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2JHVTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:19:49 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:30062 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754933Ab2JHVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:19:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18MbVMTHskanU56hkPRvic0
Date: Mon, 8 Oct 2012 14:19:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-omap1/devices.c: Remove unecessary
 semicolon
Message-ID: <20121008211926.GK13011@atomide.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
 <1347986174-30287-3-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347986174-30287-3-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Senna Tschudin <peter.senna@gmail.com> [120918 09:37]:
> Found by http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  arch/arm/mach-omap1/devices.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
> index fa1fa4d..688b23a 100644
> --- a/arch/arm/mach-omap1/devices.c
> +++ b/arch/arm/mach-omap1/devices.c
> @@ -232,7 +232,7 @@ void __init omap1_init_mmc(struct omap_mmc_platform_data **mmc_data,
>  
>  		omap_mmc_add("mmci-omap", i, base, size, irq,
>  				rx_req, tx_req, mmc_data[i]);
> -	};
> +	}
>  }
>  
>  #endif

Thanks applying into omap fixes branch.

Regards,

Tony
