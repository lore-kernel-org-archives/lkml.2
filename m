Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2INDAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:00:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:36239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2INDAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="192606138"
Subject: Re: [PATCH 1/2] dmaengine: at_hdmac: fix comment in
 atc_prep_slave_sg()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com
In-Reply-To: <77b1e7252fbc9a31e1ed8806e017f8bd8a4605e0.1347375975.git.nicolas.ferre@atmel.com>
References: <77b1e7252fbc9a31e1ed8806e017f8bd8a4605e0.1347375975.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:27:14 +0530
Message-ID: <1347591434.1943.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 17:21 +0200, Nicolas Ferre wrote:
> s/dma_memcpy/slave_sg/ and it is sg length that we are
> talking about.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Stable <stable@vger.kernel.org> [2.6.31+]
> ---
>  drivers/dma/at_hdmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 3934fcc..6c09e18 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -661,7 +661,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  			flags);
>  
>  	if (unlikely(!atslave || !sg_len)) {
> -		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
> +		dev_dbg(chan2dev(chan), "prep_slave_sg: sg length is zero!\n");
>  		return NULL;
>  	}
Applied both, Thanks.

I will send this to Linus in couple of days


-- 
~Vinod

