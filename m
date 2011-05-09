Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1EIGYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:24:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:58511 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab1EIGYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,338,1301900400"; 
   d="scan'208";a="432770560"
Subject: Re: [PATCH] dmaengine/ste_dma40: fix introduced warnings
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1304780983-14492-1-git-send-email-linus.walleij@stericsson.com>
References: <1304780983-14492-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 11:22:04 +0530
Message-ID: <1304920324.32447.34.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 17:09 +0200, Linus Walleij wrote:
> From: Philippe Langlais <philippe.langlais@linaro.org>
> 
> The compiler nowadays moans about possibly non-assigned variable.
> Fix this by default-assigning 0.
> 
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/ste_dma40.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 94ee15d..f3dcd25 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -1829,7 +1829,7 @@ d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
>  {
>  	struct stedma40_platform_data *plat = chan->base->plat_data;
>  	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
> -	dma_addr_t addr;
> +	dma_addr_t addr = 0;
>  
>  	if (chan->runtime_addr)
>  		return chan->runtime_addr;
Applied, Thanks

-- 
~Vinod

