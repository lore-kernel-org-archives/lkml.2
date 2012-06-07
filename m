Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab2FGIbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:31:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:43600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab2FGIbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:31:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162138842"
Subject: Re: [PATCH 1/1] DMA: PL330: Add missing static storage class
 specifier
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        patches@linaro.org
In-Reply-To: <1338809985-6864-1-git-send-email-sachin.kamat@linaro.org>
References: <1338809985-6864-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 13:54:31 +0530
Message-ID: <1339057471.1927.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 17:09 +0530, Sachin Kamat wrote:
> Fixes the following sparse warning:
> drivers/dma/pl330.c:2542:5: warning: symbol 'add_desc' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/dma/pl330.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index cbcc28e..63b6ad5 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2539,7 +2539,7 @@ static inline void _init_desc(struct dma_pl330_desc *desc)
>  }
>  
>  /* Returns the number of descriptors added to the DMAC pool */
> -int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
> +static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
>  {
>  	struct dma_pl330_desc *desc;
>  	unsigned long flags;

Applied, thanks
-- 
~Vinod

