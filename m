Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab1JGFIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:08:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:34927 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514Ab1JGFII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,500,1312182000"; 
   d="scan'208";a="75625265"
Subject: Re: [PATCH] pch_dma: Fix suspend issue
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 10:30:58 +0530
Message-ID: <1317963658.1573.2229.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 16:27 +0900, Tomoya MORINAGA wrote:
> Currently, executing suspend/hibernation,
> memory access violation occurs.
> 
> This patch fixes the issue
>  - Modify array size (MAX_CHAN_NR)
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
>  drivers/dma/pch_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 1ac8d4b..42bcc80 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -60,7 +60,7 @@
>  #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
>  #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
>  
> -#define MAX_CHAN_NR			8
> +#define MAX_CHAN_NR			12
>  
>  #define DMA_MASK_CTL0_MODE	0x33333333
>  #define DMA_MASK_CTL2_MODE	0x00003333

How would changing the max number of descriptors fix the memory
violation?

-- 
~Vinod

