Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370Ab2CFLXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:23:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:35638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759155Ab2CFLXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:23:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118163688"
Subject: Re: [PATCH] drivers/dma: linux/module.h included twice
From: Vinod Koul <vinod.koul@intel.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1329333626-31993-1-git-send-email-danny.kukawka@bisect.de>
References: <1329333626-31993-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 16:58:14 +0530
Message-ID: <1331033296.24656.195.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 20:20 +0100, Danny Kukawka wrote:
> drivers/dma/imx-dma.c and drivers/dma/imx-sdma.c included
> 'linux/module.h' twice, remove the duplicates.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/dma/imx-dma.c  |    1 -
>  drivers/dma/imx-sdma.c |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index e4383ee..678cd01 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -24,7 +24,6 @@
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/dmaengine.h>
> -#include <linux/module.h>
>  
>  #include <asm/irq.h>
>  #include <mach/dma-v1.h>
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 8bc5acf..63540d3 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -35,7 +35,6 @@
>  #include <linux/dmaengine.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/module.h>
>  
>  #include <asm/irq.h>
>  #include <mach/sdma.h>
Applied Thanks


-- 
~Vinod

