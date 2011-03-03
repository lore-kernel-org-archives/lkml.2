Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1CCBJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:09:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:4960 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1CCBJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:09:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,256,1297065600"; 
   d="scan'208";a="715442314"
Subject: Re: [PATCH] ste_dma40: assign device_prep_dma_sg for dma_memcpy
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
In-Reply-To: <1298975579-1594-1-git-send-email-per.forlin@stericsson.com>
References: <1298975579-1594-1-git-send-email-per.forlin@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 06:12:35 +0530
Message-ID: <1299112955.6974.155.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 11:32 +0100, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
> 
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/ste_dma40.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 6e1d46a..1dd8ea3 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -2496,7 +2496,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
>  	base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
>  	base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
>  	base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
> -	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
> +	base->dma_memcpy.device_prep_dma_sg = d40_prep_sg;
>  	base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
>  	base->dma_memcpy.device_tx_status = d40_tx_status;
>  	base->dma_memcpy.device_issue_pending = d40_issue_pending;

Please copy the MAINTAINERS, or your patches can get missed...

Applied, Thanks

~Vinod




-- 
~Vinod

