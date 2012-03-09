Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab2CJCyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:54:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226Ab2CJCyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:54:39 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Convert to DEFINE_PCI_DEVICE_TABLE
To: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <1323907885.7773.0.camel@phoenix>
References: <1323907885.7773.0.camel@phoenix>
Date: Fri, 09 Mar 2012 15:33:38 -0700
Message-Id: <20120309223338.868D43E0880@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 08:11:25 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-dw-pci.c       |    2 +-
>  drivers/spi/spi-pxa2xx-pci.c   |    2 +-
>  drivers/spi/spi-topcliff-pch.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
> index f64250e..14f7cc9 100644
> --- a/drivers/spi/spi-dw-pci.c
> +++ b/drivers/spi/spi-dw-pci.c
> @@ -149,7 +149,7 @@ static int spi_resume(struct pci_dev *pdev)
>  #define spi_resume	NULL
>  #endif
>  
> -static const struct pci_device_id pci_ids[] __devinitdata = {
> +static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
>  	/* Intel MID platform SPI controller 0 */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
>  	{},
> diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
> index 8caa07d..3fb44af 100644
> --- a/drivers/spi/spi-pxa2xx-pci.c
> +++ b/drivers/spi/spi-pxa2xx-pci.c
> @@ -151,7 +151,7 @@ static void __devexit ce4100_spi_remove(struct pci_dev *dev)
>  	kfree(spi_info);
>  }
>  
> -static struct pci_device_id ce4100_spi_devices[] __devinitdata = {
> +static DEFINE_PCI_DEVICE_TABLE(ce4100_spi_devices) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2e6a) },
>  	{ },
>  };
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 99ec279..17274a5 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -214,7 +214,7 @@ struct pch_pd_dev_save {
>  	struct pch_spi_board_data *board_dat;
>  };
>  
> -static struct pci_device_id pch_spi_pcidev_id[] = {
> +static DEFINE_PCI_DEVICE_TABLE(pch_spi_pcidev_id) = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_SPI), 1, },
> -- 
> 1.7.5.4
> 
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
