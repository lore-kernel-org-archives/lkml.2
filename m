Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1JCR51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:57:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38038 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab1JCR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:57:20 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+adsQ3Nb4nLvSEZasNb2aU
Date: Mon, 3 Oct 2011 10:57:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] ARM: omap/iommu: always provide iommu debug code
Message-ID: <20111003175718.GU6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-11-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-11-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [111002 07:13]:
> The iommu module on omap contains a few functions that are
> only used by the debug module. These are however only there
> when the debug code is built as a module. Since it is possible
> to build the debug code into the kernel, the functions should
> also be provided for the built-in case.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/plat-omap/iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index 34fc31e..9d43ce1 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -391,7 +391,7 @@ void iommu_set_twl(struct iommu *obj, bool on)
>  }
>  EXPORT_SYMBOL_GPL(iommu_set_twl);
>  
> -#if defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
> +#if defined(CONFIG_OMAP_IOMMU_DEBUG) || defined(CONFIG_OMAP_IOMMU_DEBUG_MODULE)
>  
>  ssize_t iommu_dump_ctx(struct iommu *obj, char *buf, ssize_t bytes)
>  {
> -- 
> 1.7.5.4
> 
