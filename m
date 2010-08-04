Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0HDNF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:05:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab0HDNFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:05:55 -0400
Date: Wed, 4 Aug 2010 15:05:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Weil <weil@mail.berlios.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix spelling contorller -> controller in comments
In-Reply-To: <1280857492-4398-1-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LNX.2.00.1008041505460.29919@pobox.suse.cz>
References: <1280857492-4398-1-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Stefan Weil wrote:

> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/dma/fsldma.c |    2 +-
>  drivers/net/sh_eth.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 8088b14..f0fd6db 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -10,7 +10,7 @@
>   * Description:
>   *   DMA engine driver for Freescale MPC8540 DMA controller, which is
>   *   also fit for MPC8560, MPC8555, MPC8548, MPC8641, and etc.
> - *   The support for MPC8349 DMA contorller is also added.
> + *   The support for MPC8349 DMA controller is also added.
>   *
>   * This driver instructs the DMA controller to issue the PCI Read Multiple
>   * command for PCI read operations, instead of using the default PCI Read Line
> diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
> index 501a55f..70a9bc5 100644
> --- a/drivers/net/sh_eth.c
> +++ b/drivers/net/sh_eth.c
> @@ -1325,7 +1325,7 @@ static int sh_mdio_init(struct net_device *ndev, int id)
>  	bitbang->mdc_msk = 0x01;
>  	bitbang->ctrl.ops = &bb_ops;
>  
> -	/* MII contorller setting */
> +	/* MII controller setting */
>  	mdp->mii_bus = alloc_mdio_bitbang(&bitbang->ctrl);
>  	if (!mdp->mii_bus) {

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
