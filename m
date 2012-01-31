Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2AaDeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:34:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:30897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab2AaDeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="104401750"
Subject: Re: [PATCH v2 0/6] imx-sdma: patches when I enable imx6q sabrelite
 audio
From: Vinod Koul <vinod.koul@intel.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20120113031349.GH2414@b20223-02.ap.freescale.net>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
	 <20120113031349.GH2414@b20223-02.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 09:05:15 +0530
Message-ID: <1327980915.1527.56.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 11:13 +0800, Richard Zhao wrote:
> Changes in v2:
>  - convert to use bit ops
> 
> > [PATCH v2 1/6] dma/imx-sdma: let sdma_run_channel call
> > [PATCH v2 2/6] dma/imx-sdma: use readl_relaxed/writel_relaxed and
> > [PATCH v2 3/6] dma/imx-sdma: call sdma_set_channel_priority after
> > [PATCH v2 4/6] dma/imx-sdma: move clk_enable out of
> > [PATCH v2 5/6] dma/imx-sdma: use num_events to validate event_id0
> > [PATCH v2 6/6] dma/imx-sdma: convernt to use bit ops
> > 
> > Thanks
> > Richard
> > 
Thanks Applied all, with a typo fix in 4 in change log

-- 
~Vinod

