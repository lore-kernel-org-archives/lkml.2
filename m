Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1LWQDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:03:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:42399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1LWQDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:03:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50124938"
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Artem Bityutskiy <artem.bityutskiy@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Huang Shijie <b32955@freescale.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 21:33:49 +0530
Message-ID: <1324656229.1633.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 23:48 +0800, Shawn Guo wrote:
> I have been working on -rc recently, and have not noticed the failure
> until I ran next tree today.  The mxs-mmc driver is broken on next
> tree because the DMA_NONE was left over from the dma_transfer_direction
> migration for mxs-dma and its client drivers.
> 
> This seires is trying to fix it up.
Applied, Thanks

> 
> Huang Shijie (1):
>       mtd: fix compile error for gpmi-nand
> 
> Shawn Guo (3):
>       dmaengine: add DMA_TRANS_NONE to dma_transfer_direction
>       mmc: mxs-mmc: fix the dma_transfer_direction migration
>       mtd: gpmi-nand: move to dma_transfer_direction
> 
>  drivers/dma/mxs-dma.c                 |    2 +-
>  drivers/mmc/host/mxs-mmc.c            |    3 +
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   22 ++++++-----
>  include/linux/dmaengine.h             |    1 +
>  include/linux/mtd/gpmi-nand.h         |   68 +++++++++++++++++++++++++++++++++
>  5 files changed, 85 insertions(+), 11 deletions(-)
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
~Vinod

