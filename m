Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937Ab1IOU5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:57:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38569 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775Ab1IOU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:57:39 -0400
Date: Thu, 15 Sep 2011 14:57:34 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 21/27] Initconst section fixes for SPI
Message-ID: <20110915205734.GF3523@ponder.secretlab.ca>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
 <1316117394-21666-22-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316117394-21666-22-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 01:09:48PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Cc: grant.likely@secretlab.ca
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Is this one going to be merged with the rest of the series?  Or do I need to pick it up?

g.

> ---
>  drivers/spi/spi-dw-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
> index c5f37f0..898d202 100644
> --- a/drivers/spi/spi-dw-pci.c
> +++ b/drivers/spi/spi-dw-pci.c
> @@ -148,7 +148,7 @@ static int spi_resume(struct pci_dev *pdev)
>  #define spi_resume	NULL
>  #endif
>  
> -static const struct pci_device_id pci_ids[] __devinitdata = {
> +static const struct pci_device_id pci_ids[] __devinitconst = {
>  	/* Intel MID platform SPI controller 0 */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
>  	{},
> -- 
> 1.7.4.4
> 
