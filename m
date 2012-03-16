Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067Ab2CPDIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:08:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:12265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab2CPDIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:08:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139715918"
Subject: Re: [PATCH 1/6] dmaengine: Kconfig: fix Atmel at_hdmac entry
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, a.zummo@towertech.it
In-Reply-To: <7cdf1e94a17a7d872cb1eeaef812aab25b3caf40.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
	 <7cdf1e94a17a7d872cb1eeaef812aab25b3caf40.1331826095.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 08:43:57 +0530
Message-ID: <1331867637.1727.29.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 16:57 +0100, Nicolas Ferre wrote:
> Remove SoC dependency and make it generic for every Atmel ARM AT91. That will
> allow to select this driver for newer chips. Keep dependency on AT91 because of
> the use of an header file located in include/mach directory.
> Modify the comment to reflect this.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
> ---
>  drivers/dma/Kconfig |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index f1a2749..6d50f35 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -91,11 +91,10 @@ config DW_DMAC
>  
>  config AT_HDMAC
>  	tristate "Atmel AHB DMA support"
> -	depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
> +	depends on ARCH_AT91
>  	select DMA_ENGINE
>  	help
> -	  Support the Atmel AHB DMA controller.  This can be integrated in
> -	  chips such as the Atmel AT91SAM9RL.
> +	  Support the Atmel AHB DMA controller.
>  
>  config FSL_DMA
>  	tristate "Freescale Elo and Elo Plus DMA support"


-- 
~Vinod

