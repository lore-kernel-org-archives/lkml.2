Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1JPIeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:34:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:42730 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1JPIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,353,1315206000"; 
   d="scan'208";a="78551293"
Subject: Re: [PATCH] dmaengine/ep93xx_dma: add module.h include
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20111016081930.GC2642@mwesterb-mobl.ger.corp.intel.com>
References: <1318703917-7604-1-git-send-email-mika.westerberg@iki.fi>
	 <1318752342.23438.49.camel@vkoul-udesk3>
	 <20111016081930.GC2642@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 13:55:39 +0530
Message-ID: <1318753539.23438.50.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 11:19 +0300, Mika Westerberg wrote:
> On Sun, Oct 16, 2011 at 01:35:42PM +0530, Vinod Koul wrote:
> > Any reason why it is required. Changelog isn't really helpful
> 
> Yeah, sorry. Grant also mentioned about the same thing.
> 
> Below is an updated version.
> 
> From: Mika Westerberg <mika.westerberg@iki.fi>
> Subject: [PATCH] dmaengine/ep93xx_dma: add module.h include
> 
> Due to module.h cleanup it is not anymore included implicitly. Drivers who
> want to use it need to include it explicitly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  drivers/dma/ep93xx_dma.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 5d7a49b..b47e2b8 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -22,6 +22,7 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/dmaengine.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>

Applied, Thanks

-- 
~Vinod

