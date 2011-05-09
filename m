Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1EIEFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:05:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab1EIEFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:05:42 -0400
Subject: Re: [PATCH V2 5/5] pch_dma: Support new device ML7223 IOH
From: Joe Perches <joe@perches.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
In-Reply-To: <1304912885-6747-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304912885-6747-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 21:05:41 -0700
Message-ID: <1304913941.19586.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 12:48 +0900, Tomoya MORINAGA wrote:
> Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
> The ML7223 IOH is for MP(Media Phone) use.
> The ML7223 is companion chip for Intel Atom E6xx series.
> The ML7223 is completely compatible for Intel EG20T PCH.
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  config PCH_DMA
> -	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH DMA support"
> +	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR IOH(ML7213/ML7223)"

DMA support?

> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 2c052bb..466954d 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -956,6 +956,10 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
>  #define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
>  #define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
>  #define PCI_DEVICE_ID_ML7213_DMA4_12CH	0x8032
> +#define PCI_DEVICE_ID_ML7223_DMA1_4CH	0x800B
> +#define PCI_DEVICE_ID_ML7223_DMA2_4CH	0x800E
> +#define PCI_DEVICE_ID_ML7223_DMA3_4CH	0x8017
> +#define PCI_DEVICE_ID_ML7223_DMA4_4CH	0x803B
>  
>  static const struct pci_device_id pch_dma_id_table[] = {

DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {



