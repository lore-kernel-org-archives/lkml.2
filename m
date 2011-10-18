Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1JRC46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:56:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:37853 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237Ab1JRC45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:56:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,362,1315206000"; 
   d="scan'208";a="74899018"
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
In-Reply-To: <Pine.LNX.4.64.1110171023070.18438@axis700.grange>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
	 <Pine.LNX.4.64.1110171023070.18438@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 08:18:15 +0530
Message-ID: <1318906095.23438.175.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 14:52 +0200, Guennadi Liakhovetski wrote:
> A general note to this rework. I haven't been cc'ed on patch 00/10,
> so, 
> replying here. Are we sure it is a good idea to name these new macros
> like 
> this:
> 
> MEM_TO_DEV,
> DEV_TO_MEM,
> ...
> 
> i.e., without a common namespace? Wouldn't something like
> DMA_DIRECTION_* 
> be better? 
Yes makes sense. I am leaning towards DMA_*

-- 
~Vinod

