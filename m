Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2HCQ1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:27:11 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34697 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2HCQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:27:09 -0400
Date: Fri, 3 Aug 2012 13:27:01 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] dma: Fix typo various drivers in dma
Message-ID: <20120803162701.GC5736@oc1711230544.ibm.com>
References: <1344004316-12204-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344004316-12204-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080316-9254-0000-0000-000009CFCBEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:31:56PM +0900, Masanari Iida wrote:
> Correct spelling typo in drivers/dma.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/dma/at_hdmac.c           | 8 ++++----
>  drivers/dma/ep93xx_dma.c         | 2 +-
>  drivers/dma/fsldma.c             | 2 +-
>  drivers/dma/imx-dma.c            | 2 +-
>  drivers/dma/intel_mid_dma_regs.h | 4 ++--
>  drivers/dma/pl330.c              | 2 +-
>  drivers/dma/ppc4xx/adma.c        | 2 +-
>  drivers/dma/ste_dma40_ll.h       | 2 +-
>  8 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 7292aa8..b2d87da 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -169,9 +169,9 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
>  }
> 
>  /**
> - * atc_desc_chain - build chain adding a descripor
> - * @first: address of first descripor of the chain
> - * @prev: address of previous descripor of the chain
> + * atc_desc_chain - build chain adding a descriptor
> + * @first: address of first descripotr of the chain
> + * @prev: address of previous descripotr of the chain
>   * @desc: descriptor to queue

That's still wrong: descripotr.

>   *
>   * Called from prep_* functions
> @@ -786,7 +786,7 @@ err_out:
>  }
> 
>  /**
> - * atc_dma_cyclic_fill_desc - Fill one period decriptor
> + * atc_dma_cyclic_fill_desc - Fill one period descriptor
>   */
>  static int
>  atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index c64917e..bb02fd9 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -1118,7 +1118,7 @@ fail:
>   * @chan: channel
>   * @dma_addr: DMA mapped address of the buffer
>   * @buf_len: length of the buffer (in bytes)
> - * @period_len: lenght of a single period
> + * @period_len: length of a single period
>   * @dir: direction of the operation
>   * @context: operation context (ignored)
>   *
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 8f84761..094437b 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1015,7 +1015,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
>  	/*
>  	 * Programming Error
>  	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
> -	 * triger a PE interrupt.
> +	 * trigger a PE interrupt.
>  	 */
>  	if (stat & FSL_DMA_SR_PE) {
>  		chan_dbg(chan, "irq: Programming Error INT\n");
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index fcfeb3c..db8b9aa 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -572,7 +572,7 @@ static void imxdma_tasklet(unsigned long data)
>  		desc->desc.callback(desc->desc.callback_param);
> 
>  	/* If we are dealing with a cyclic descriptor keep it on ld_active

What about a comma after descriptor here?

> -	 * and dont mark the descripor as complete.
> +	 * and dont mark the descriptor as complete.
>  	 * Only in non-cyclic cases it would be marked as complete
>  	 */
>  	if (imxdma_chan_is_doing_cyclic(imxdmac))
> diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
> index 1bfa926..0ef9597 100644
> --- a/drivers/dma/intel_mid_dma_regs.h
> +++ b/drivers/dma/intel_mid_dma_regs.h
> @@ -168,9 +168,9 @@ union intel_mid_dma_cfg_hi {
>   * @active_list: current active descriptors
>   * @queue: current queued up descriptors
>   * @free_list: current free descriptors
> - * @slave: dma slave struture
> + * @slave: dma slave structure
>   * @descs_allocated: total number of decsiptors allocated


Note decsiptors here.


> - * @dma: dma device struture pointer
> + * @dma: dma device structure pointer
>   * @busy: bool representing if ch is busy (active txn) or not
>   * @in_use: bool representing if ch is in use or not
>   * @raw_tfr: raw trf interrupt received
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 3ce7d55..71f9e96 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -522,7 +522,7 @@ enum desc_status {
>  	/* In the DMAC pool */
>  	FREE,
>  	/*
> -	 * Allocted to some channel during prep_xxx
> +	 * Allocated to some channel during prep_xxx
>  	 * Also may be sitting on the work_list.
>  	 */
>  	PREP,
> diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> index ced9882..f72348d 100644
> --- a/drivers/dma/ppc4xx/adma.c
> +++ b/drivers/dma/ppc4xx/adma.c
> @@ -4446,7 +4446,7 @@ static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev)
>  		ret = -ENOMEM;
>  		goto err_dma_alloc;
>  	}
> -	dev_dbg(&ofdev->dev, "allocted descriptor pool virt 0x%p phys 0x%llx\n",
> +	dev_dbg(&ofdev->dev, "allocated descriptor pool virt 0x%p phys 0x%llx\n",
>  		adev->dma_desc_pool_virt, (u64)adev->dma_desc_pool);
> 
>  	regs = ioremap(res.start, resource_size(&res));
> diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
> index 51e8e53..6d47373 100644
> --- a/drivers/dma/ste_dma40_ll.h
> +++ b/drivers/dma/ste_dma40_ll.h
> @@ -202,7 +202,7 @@
>  /* LLI related structures */
> 
>  /**
> - * struct d40_phy_lli - The basic configration register for each physical
> + * struct d40_phy_lli - The basic configuration register for each physical
>   * channel.
>   *
>   * @reg_cfg: The configuration register.
> -- 
> 1.7.12.rc1.16.g05a20c8
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

