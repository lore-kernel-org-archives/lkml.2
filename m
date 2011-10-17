Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1JQNYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:24:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:37054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1JQNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63947090"
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
In-Reply-To: <4E9BBCEB.9090204@st.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
	 <4E9BBCEB.9090204@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 18:45:24 +0530
Message-ID: <1318857324.23438.96.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 10:58 +0530, Viresh Kumar wrote:
> For amba-pl08x and dw_dmac:
> 
> Acked-by: Viresh Kumar <viresh.kumar@st.com>
Thanks
> 
> Can you please add something in the commit message, to explain why is
> it done.
I think 01/10 explains it well

-- 
~Vinod

