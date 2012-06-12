Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2FLJXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:23:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:9906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2FLJXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:23:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178778964"
Subject: Re: [PATCH] dmaengine: at_hdmac: trivial: fix comment in header
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com
In-Reply-To: <1339490695-28796-1-git-send-email-nicolas.ferre@atmel.com>
References: <1339490695-28796-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jun 2012 14:46:10 +0530
Message-ID: <1339492570.1927.1636.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 10:44 +0200, Nicolas Ferre wrote:
> Not all Atmel SoCs were pointed out in header comment which was bringing
> confusion. Remove the truncated list of supported devices, replace by the
> only one that is not supported.
> 
> Reported-by: Elen Song <elen.song@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 7292aa8..bb16013 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -9,10 +9,9 @@
>   * (at your option) any later version.
>   *
>   *
> - * This supports the Atmel AHB DMA Controller,
> - *
> - * The driver has currently been tested with the Atmel AT91SAM9RL
> - * and AT91SAM9G45 series.
> + * This supports the Atmel AHB DMA Controller found in several Atmel SoCs.
> + * The only Atmel DMA Controller that is not covered by this driver is the one
> + * found on AT91SAM9263.
>   */
>  
>  #include <linux/clk.h>
Applied thanks

-- 
~Vinod

