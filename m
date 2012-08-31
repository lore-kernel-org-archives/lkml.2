Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2HaAag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:30:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44010 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2HaAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:30:13 -0400
Message-ID: <1346373442.15463.3.camel@vkoul-mobl4>
Subject: Re: [PATCH] ioat: Adding Ivy Bridge IOATDMA PCI device IDs
From: Vinod Koul <vkoul@infradead.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, djbw@fb.com, linux-kernel@vger.kernel.org
Date: Fri, 31 Aug 2012 06:07:22 +0530
In-Reply-To: <20120824233619.9218.25014.stgit@djiang5-linux.ch.intel.com>
References: <20120824233619.9218.25014.stgit@djiang5-linux.ch.intel.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 16:36 -0700, Dave Jiang wrote:
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Sounds okay to me, I can carry it once Dan acks it
> ---
> 
>  drivers/dma/ioat/pci.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
> index 5e3a40f..c057306 100644
> --- a/drivers/dma/ioat/pci.c
> +++ b/drivers/dma/ioat/pci.c
> @@ -40,6 +40,17 @@ MODULE_VERSION(IOAT_DMA_VERSION);
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Intel Corporation");
>  
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB0	0x0e20
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB1	0x0e21
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB2	0x0e22
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB3	0x0e23
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB4	0x0e24
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB5	0x0e25
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB6	0x0e26
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB7	0x0e27
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB8	0x0e2e
> +#define PCI_DEVICE_ID_INTEL_IOAT_IVB9	0x0e2f
> +
>  static struct pci_device_id ioat_pci_tbl[] = {
>  	/* I/OAT v1 platforms */
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
> @@ -83,6 +94,17 @@ static struct pci_device_id ioat_pci_tbl[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB8) },
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB9) },
>  
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB0) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB1) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB2) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB3) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB4) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB5) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB6) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB7) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB8) },
> +	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB9) },
> +
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
~Vinod Koul
Intel Corp.

