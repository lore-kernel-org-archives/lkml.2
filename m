Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1JPIOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:14:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:39255 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1JPIOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="63345066"
Subject: Re: [PATCH] dmaengine/ep93xx_dma: add module.h include
From: Vinod Koul <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1318703917-7604-1-git-send-email-mika.westerberg@iki.fi>
References: <1318703917-7604-1-git-send-email-mika.westerberg@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 13:35:42 +0530
Message-ID: <1318752342.23438.49.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 21:38 +0300, Mika Westerberg wrote:
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
>  
Any reason why it is required. Changelog isn't really helpful

-- 
~Vinod

