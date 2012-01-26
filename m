Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2AZWw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:52:26 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2AZWwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:52:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6601"; a="155922157"
Date: Thu, 26 Jan 2012 16:52:22 -0600
From: Richard Kuo <rkuo@codeaurora.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/hexagon/kernel/dma.c: make function static
Message-ID: <20120126225222.GA11120@codeaurora.org>
References: <1327411896-4532-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327411896-4532-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 02:31:36PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> This function is only used in the same file, and the other similar
> functions in this file are also static.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  arch/hexagon/kernel/dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
> index 54891e1..0b49a0a 100644
> --- a/arch/hexagon/kernel/dma.c
> +++ b/arch/hexagon/kernel/dma.c
> @@ -54,7 +54,7 @@ static struct gen_pool *coherent_pool;
>  
>  /* Allocates from a pool of uncached memory that was reserved at boot time */
>  
> -void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
> +static void *hexagon_dma_alloc_coherent(struct device *dev, size_t size,
>  				 dma_addr_t *dma_addr, gfp_t flag)
>  {
>  	void *ret;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hexagon" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks!

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
