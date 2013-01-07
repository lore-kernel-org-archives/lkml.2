Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3AGMzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:55:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:3843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3AGMzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,424,1355126400"; 
   d="scan'208";a="268627282"
Message-ID: <1357563294.31620.145.camel@smile>
Subject: dw_dmac patches
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 07 Jan 2013 14:54:54 +0200
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vinod.

I noticed you missed the 3.8 merge window and I can't see any of my
recent patches [1] in your next branch. So, what is your plan regarding
to them?

[1]
pick 9f2b870 dw_dmac: call .probe after we have a device in place
pick 5bcd7fe dw_dmac: absence of pdata isn't critical when autocfg is
set
pick 2fbca14 dmaengine: introduce is_slave_xfer function
pick 6e98b1f dma: at_hdmac: check direction properly for cyclic
transfers
pick d1573d9 dma: dw_dmac: check direction properly in
dw_dma_cyclic_prep
pick f1071a3 dma: ep93xx_dma: reuse is_slave_xfer helper
pick 191347f dma: ipu_idmac: reuse is_slave_xfer helper
pick 4ec19c2 dma: ste_dma40: reuse is_slave_xfer helper
pick 757978e dw_dmac: store direction in the custom channel structure
pick 8e5ea839 dw_dmac: make usage of dw_dma_slave optional
pick d0da3f4 dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
pick ca7141d dw_dmac: check for mapping errors
pick 281c298 dw_dmac: remove redundant check
pick 217f956 dw_dmac: update tx_node_active in dwc_do_single_block
pick fd144bd dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
pick 59a6031 dma: dw_dmac: clear suspend bit during termination


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
