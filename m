Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2IQDo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:44:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:32574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab2IQDoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="193475782"
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20120914111842.GD12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com>
	 <20120914094155.GC12245@n2100.arm.linux.org.uk>
	 <1347619868.1943.113.camel@vkoul-udesk3>
	 <20120914111842.GD12245@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 09:10:23 +0530
Message-ID: <1347853223.1943.136.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 12:18 +0100, Russell King - ARM Linux wrote:
> I'm not saying take the slave_id out of the map.  I'm saying, let the
> DMA engine driver itself figure out what dma_chan to return. 
But wont that assume the dma controller knows which channel to allocate.
And how would it know this information? This can be problematic for hard
wired muxes, but can be easily done for controller which have
programmable mux.

-- 
~Vinod

