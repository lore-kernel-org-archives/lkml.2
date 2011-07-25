Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GYO0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:26:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:42306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1GYOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:25:55 -0400
Subject: Re: [PATCH] dma: mxs-dma: fix unterminated platform_device_id table
From: Vinod Koul <vkoul@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1310468032.6590.1.camel@phoenix>
References: <1310468032.6590.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Mon, 25 Jul 2011 19:54:54 +0530
Message-ID: <1311603894.8206.16.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 18:53 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/dma/mxs-dma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 88aad4f..72a2896 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -707,6 +707,8 @@ static struct platform_device_id mxs_dma_type[] = {
>  	}, {
>  		.name = "mxs-dma-apbx",
>  		.driver_data = MXS_DMA_APBX,
> +	}, {
> +		/* end of list */
>  	}
>  };
>  
Applied, Thanks

-- 
~Vinod Koul
Intel Corp.

