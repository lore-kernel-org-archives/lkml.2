Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2JJJBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:01:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:11420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2JJJA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,564,1344236400"; 
   d="scan'208";a="202707097"
Message-ID: <1349859638.10584.120.camel@smile>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: add module alias
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 10 Oct 2012 12:00:38 +0300
In-Reply-To: <1349178121-9105-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349178121-9105-3-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote: 
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> It's good to have a quasistatic name for the platform driver.
Please, do not push this one.
It makes no sense now. Better we have it after a split.

> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/dw_dmac.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 0b88ced..bbb2a82 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1712,6 +1712,7 @@ static struct platform_driver dw_driver = {
>  
>  module_platform_driver(dw_driver);
>  
> +MODULE_ALIAS("platform:dw_dmac");
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
>  MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
