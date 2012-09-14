Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab2INDSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:18:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:38652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2INDS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="192892913"
Subject: Re: [PATCH 0/2] DMA: PL330: Clock and runtime cleanup
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org, boojin.kim@samsung.com,
        jassisinghbrar@gmail.com
In-Reply-To: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
References: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:45:03 +0530
Message-ID: <1347592503.1943.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 12:14 +0530, Inderpal Singh wrote:
> The controller clock is being managed at AMBA bus level probe/remove and
> pm_runtime/suspend functions. The existing driver does the clock enable/disable
> again in the same code paths, which unneccessarily increments the usage count of
> the clock for the same device. 
> 
> The following patches remove the redundant clock enable/disable from the driver.
Looks good, any tested by before I apply this.. Kukjin?
> 
> Inderpal Singh (2):
>   DMA: PL330: Remove controller clock enable/disable
>   DMA: PL330: Remove redundant runtime_suspend/resume functions
> 
>  drivers/dma/pl330.c |   73 ++++-----------------------------------------------
>  1 file changed, 5 insertions(+), 68 deletions(-)
> 


-- 
~Vinod

