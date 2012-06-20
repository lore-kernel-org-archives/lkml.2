Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2FTOtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:49:08 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51696 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2FTOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:49:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ANnd2OwS15cvh5yJ1OLZh
Date: Wed, 20 Jun 2012 07:48:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        swarren@wwwdotorg.org, robherring2@gmail.com
Subject: Re: [PATCH RESEND] ARM: omap: Fix dts files w/ status property:
 "disable" -> "disabled"
Message-ID: <20120620144859.GS12766@atomide.com>
References: <1340051110-23746-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340051110-23746-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Stigge <stigge@antcom.de> [120618 13:29]:
> This patches fixes some status = "disable" strings to "disabled", the correct
> way of disabling nodes in the devicetree.
> 
> Just the OMAP part here, the rest goes via other patches and trees.

Thanks applying into fixes.

Tony
 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Benoit Cousson <b-cousson@ti.com>
> 
> ---
> Applies to v3.5-rc3
> 
>  arch/arm/boot/dts/omap3-beagle.dts |    4 ++--
>  arch/arm/boot/dts/omap4-panda.dts  |    6 +++---
>  arch/arm/boot/dts/omap4-sdp.dts    |    4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- linux-2.6.orig/arch/arm/boot/dts/omap3-beagle.dts
> +++ linux-2.6/arch/arm/boot/dts/omap3-beagle.dts
> @@ -61,9 +61,9 @@
>  };
>  
>  &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-panda.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-panda.dts
> @@ -74,15 +74,15 @@
>  };
>  
>  &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc5 {
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-sdp.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-sdp.dts
> @@ -147,11 +147,11 @@
>  };
>  
>  &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>  };
>  
>  &mmc5 {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
