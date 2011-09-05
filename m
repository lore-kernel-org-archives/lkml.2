Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1IENYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:24:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:23978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab1IENYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45191430"
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1314688104.23734.1.camel@phoenix>
References: <1314688104.23734.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 18:51:58 +0530
Message-ID: <1315228918.26251.78.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 15:08 +0800, Axel Lin wrote:
> Add missing include of linux/module.h to fix build error.
I don't see this build error in my tree (based on rc4), In which config
is this seen?

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/dma/imx-dma.c  |    1 +
>  drivers/dma/imx-sdma.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index d99f71c..d746899 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -14,6 +14,7 @@
>   * http://www.gnu.org/copyleft/gpl.html
>   */
>  #include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
>  #include <linux/interrupt.h>
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index b5cc27d..eab1fe7 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -18,6 +18,7 @@
>   */
>  
>  #include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
>  #include <linux/interrupt.h>


-- 
~Vinod

