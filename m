Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab2EKGgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:36:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:40737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759643Ab2EKGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:36:08 -0400
Subject: Re: [PATCH 1/1] DMA: PL330: Remove duplicate header file inclusion
From: Vinod Koul <vkoul@infradead.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, jaswinder.singh@linaro.org,
        patches@linaro.org
In-Reply-To: <1336037548-13718-1-git-send-email-sachin.kamat@linaro.org>
References: <1336037548-13718-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 11:59:24 +0530
Message-ID: <1336717764.15424.1592.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 15:02 +0530, Sachin Kamat wrote:
> Removes <linux/interrupt.h> file which was included twice.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Applied Thanks

> ---
>  drivers/dma/pl330.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2ee6e23..e8ebca7 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -21,7 +21,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
> -#include <linux/interrupt.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl330.h>
>  #include <linux/pm_runtime.h>



