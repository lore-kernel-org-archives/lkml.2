Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1HWGcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:32:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:17806 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1HWGce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:32:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40854694"
Subject: Re: [PATCH] DMA: PL330: add missing header
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Boojin Kim <boojin.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 12:02:13 +0530
Message-ID: <1314081133.22120.19.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 14:57 +0900, Boojin Kim wrote:
> This patch fixup below build error
> 
> drivers/dma/pl330.c: In function 'pl330_prep_slave_sg':
> drivers/dma/pl330.c:603: error: implicit declaration of function 'for_each_sg'
> drivers/dma/pl330.c:603: error: expected ';' before '{' token
> drivers/dma/pl330.c:581: warning: unused variable 'flags'
> drivers/dma/pl330.c: In function 'pl330_probe':
> drivers/dma/pl330.c:720: warning: comparison of distinct pointer types lacks a cast
> make[2]: *** [drivers/dma/pl330.o] Error 1
> 
> Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> ---
>  drivers/dma/pl330.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 00eee59..fcad90c 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -17,6 +17,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl330.h>
> +#include <linux/scatterlist.h>
>  
>  #define NR_DEFAULT_DESC	16
>  
Where tree is this error reported? scatterlist.h is already added to the
dmaengine.h

-- 
~Vinod

