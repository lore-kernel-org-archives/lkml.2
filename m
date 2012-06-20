Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2FTNnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:43:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:23615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2FTNne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:43:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114207580"
Subject: Re: [PATCH v2 1/3] dmaengine: Add wrapper for device_tx_status
 callback
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FE1BE79.5080903@metafoo.de>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
	 <1340189662.1927.1648.camel@vkoul-udesk3>  <4FE1BE79.5080903@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 19:05:46 +0530
Message-ID: <1340199346.1927.1655.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:13 +0200, Lars-Peter Clausen wrote:
> On 06/20/2012 12:54 PM, Vinod Koul wrote:
> > On Mon, 2012-06-11 at 20:11 +0200, Lars-Peter Clausen wrote:
> >> This patch adds a small inline wrapper for the devivce_tx_status callback of a
> >> dma device. This makes the source code of users of this function a bit more
> >> compact and a bit more legible.
> > Applied, thanks
> > 
> > rest of the series should go thru ASoC tree.
> > 
> 
> Thanks.
> 
> There is a compile time dependency between the patches, so this patch should
> go through the ASoC tree as well, or we'll have to wait another release
> before the ASoC patches can be applied.
> 
Yes and rest of the two patches depend on components in asoc-next so
they don't apply for me as well.
Mark, it would make sense to take all three to your tree. I will retain
this in my next for others to use.
So, 
Acked-by Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod

