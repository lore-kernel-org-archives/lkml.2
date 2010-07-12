Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0GLNSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:18:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0GLNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:18:50 -0400
Message-ID: <4C3B138E.4080208@monstr.eu>
Date: Mon, 12 Jul 2010 15:07:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: remove unused HAVE_ARCH_PCI_SET_DMA_MASK
References: <20100712153701V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100712153701V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> HAVE_ARCH_PCI_SET_DMA_MASK was removed in 2.6.36 (no architecture has
> the own implementation of pci_set_dma_mask).

Added to next branch. I also fixed that kernel version.

Thanks,
Michal

> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/microblaze/include/asm/dma-mapping.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
> index 18b3731..5073895 100644
> --- a/arch/microblaze/include/asm/dma-mapping.h
> +++ b/arch/microblaze/include/asm/dma-mapping.h
> @@ -79,12 +79,6 @@ static inline int dma_supported(struct device *dev, u64 mask)
>  	return ops->dma_supported(dev, mask);
>  }
>  
> -#ifdef CONFIG_PCI
> -/* We have our own implementation of pci_set_dma_mask() */
> -#define HAVE_ARCH_PCI_SET_DMA_MASK
> -
> -#endif
> -
>  static inline int dma_set_mask(struct device *dev, u64 dma_mask)
>  {
>  	struct dma_map_ops *ops = get_dma_ops(dev);


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
