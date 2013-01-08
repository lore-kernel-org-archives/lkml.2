Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3AHQSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:18:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:2088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab3AHQSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:18:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,432,1355126400"; 
   d="scan'208";a="271343791"
Date: Tue, 8 Jan 2013 07:54:23 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: dw_dmac patches
Message-ID: <20130108155423.GJ19691@intel.com>
References: <1357563294.31620.145.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357563294.31620.145.camel@smile>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:54:54PM +0200, Andy Shevchenko wrote:
> Hi, Vinod.
> 
> I noticed you missed the 3.8 merge window and I can't see any of my
> recent patches [1] in your next branch. So, what is your plan regarding
> to them?
Yes i missed quite a few due to my travel, but now am back :)

Can you please rebase below on my next and resend the below sequence. I can go
thru them quickly tomorrow and do the needful

--
~Vinod
> 
> [1]
> pick 9f2b870 dw_dmac: call .probe after we have a device in place
> pick 5bcd7fe dw_dmac: absence of pdata isn't critical when autocfg is
> set
> pick 2fbca14 dmaengine: introduce is_slave_xfer function
> pick 6e98b1f dma: at_hdmac: check direction properly for cyclic
> transfers
> pick d1573d9 dma: dw_dmac: check direction properly in
> dw_dma_cyclic_prep
> pick f1071a3 dma: ep93xx_dma: reuse is_slave_xfer helper
> pick 191347f dma: ipu_idmac: reuse is_slave_xfer helper
> pick 4ec19c2 dma: ste_dma40: reuse is_slave_xfer helper
> pick 757978e dw_dmac: store direction in the custom channel structure
> pick 8e5ea839 dw_dmac: make usage of dw_dma_slave optional
> pick d0da3f4 dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
> pick ca7141d dw_dmac: check for mapping errors
> pick 281c298 dw_dmac: remove redundant check
> pick 217f956 dw_dmac: update tx_node_active in dwc_do_single_block
> pick fd144bd dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
> pick 59a6031 dma: dw_dmac: clear suspend bit during termination
> 
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy
