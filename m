Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1FPMcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:32:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50690 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1FPMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:32:01 -0400
Date: Thu, 16 Jun 2011 06:31:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/5] spi/makefile:  Fix typo from reorganize drivers
 patch.
Message-ID: <20110616123158.GC31534@ponder.secretlab.ca>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
 <1308158588-17249-2-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308158588-17249-2-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:23:04AM -0700, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Fix Makefile to build designware driver.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

This is already fixed in spi/next

g.

> ---
>  drivers/spi/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index f6d5018..b60b04b 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -23,7 +23,7 @@ obj-$(CONFIG_SPI_DAVINCI)		+= spi-davinci.o
>  obj-$(CONFIG_SPI_DESIGNWARE)		+= spi-dw.o
>  obj-$(CONFIG_SPI_DW_MMIO)		+= spi-dw-mmio.o
>  obj-$(CONFIG_SPI_DW_PCI)		+= spi-dw-midpci.o
> -spi_dw_midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
> +spi-dw-midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
>  obj-$(CONFIG_SPI_EP93XX)		+= spi-ep93xx.o
>  obj-$(CONFIG_SPI_FSL_LIB)		+= spi-fsl-lib.o
>  obj-$(CONFIG_SPI_FSL_ESPI)		+= spi-fsl-espi.o
> -- 
> 1.7.3.4
> 
> 
> ------------------------------------------------------------------------------
> EditLive Enterprise is the world's most technically advanced content
> authoring tool. Experience the power of Track Changes, Inline Image
> Editing and ensure content is compliant with Accessibility Checking.
> http://p.sf.net/sfu/ephox-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
