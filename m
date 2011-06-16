Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1FPE4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:56:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:55665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1FPE4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:56:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,373,1304319600"; 
   d="scan'208";a="13616334"
Subject: Re: [PATCH] dma/ep93xx_dma.c: local symbols should be static
From: "Koul, Vinod" <vinod.koul@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, mika.westerberg@iki.fi,
        dan.j.williams@intel.com
In-Reply-To: <201106101515.05990.hartleys@visionengravers.com>
References: <201106101515.05990.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 09:50:44 +0530
Message-ID: <1308198044.10976.195.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 15:15 -0700, H Hartley Sweeten wrote:
> The symbol 'ep93xx_dma_prep_dma_memcpy' is only used in this driver
> and should be marked static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>

Applied Thanks
> 
> ---
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 0766c1e..5d7a49b 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -902,7 +902,7 @@ static void ep93xx_dma_free_chan_resources(struct dma_chan *chan)
>   *
>   * Returns a valid DMA descriptor or %NULL in case of failure.
>   */
> -struct dma_async_tx_descriptor *
> +static struct dma_async_tx_descriptor *
>  ep93xx_dma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest,
>  			   dma_addr_t src, size_t len, unsigned long flags)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

