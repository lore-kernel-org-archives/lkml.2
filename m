Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab2IRDeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:34:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:34383 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657Ab2IRDeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="146166292"
Subject: Re: [PATCH 0/2] DMA: PL330: Clock and runtime cleanup
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org, boojin.kim@samsung.com,
        jassisinghbrar@gmail.com
In-Reply-To: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
References: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 09:00:12 +0530
Message-ID: <1347939012.1943.170.camel@vkoul-udesk3>
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
Applied thanks

-- 
~Vinod

