Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1LTJYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:24:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:60233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1LTJYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:24:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98258718"
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Artem Bityutskiy <artem.bityutskiy@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Huang Shijie <b32955@freescale.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 14:54:04 +0530
Message-ID: <1324373044.1641.10096.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 23:48 +0800, Shawn Guo wrote:
> I have been working on -rc recently, and have not noticed the failure
> until I ran next tree today.  The mxs-mmc driver is broken on next
> tree because the DMA_NONE was left over from the dma_transfer_direction
> migration for mxs-dma and its client drivers.
> 
For DMA transfer, the NONE direction makes no sense?

In your conetext, what are you trying to achieve?


-- 
~Vinod

