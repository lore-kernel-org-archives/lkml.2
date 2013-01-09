Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3AIIVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:21:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:54870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab3AIIRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189184434"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [resend][PATCH 00/16] dw_dmac related patchset
Date: Wed,  9 Jan 2013 10:16:59 +0200
Message-Id: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130108155423.GJ19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a patchset against dw_dmac driver. It has been resent for Vinod to
review after he returned back from vacation and holidays. That's why there is
no Cc list.

Andy Shevchenko (15):
  dw_dmac: call .probe after we have a device in place
  dw_dmac: absence of pdata isn't critical when autocfg is set
  dmaengine: introduce is_slave_xfer function
  dma: at_hdmac: check direction properly for cyclic transfers
  dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
  dma: ep93xx_dma: reuse is_slave_xfer helper
  dma: ipu_idmac: reuse is_slave_xfer helper
  dma: ste_dma40: reuse is_slave_xfer helper
  dw_dmac: store direction in the custom channel structure
  dw_dmac: make usage of dw_dma_slave optional
  dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
  dw_dmac: check for mapping errors
  dw_dmac: remove redundant check
  dw_dmac: update tx_node_active in dwc_do_single_block
  dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume

Heikki Krogerus (1):
  dma: dw_dmac: clear suspend bit during termination

 drivers/dma/at_hdmac.c      |   10 +--
 drivers/dma/dw_dmac.c       |  152 +++++++++++++++++++++++++++++--------------
 drivers/dma/dw_dmac_regs.h  |   17 +++--
 drivers/dma/ep93xx_dma.c    |    3 +-
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 drivers/dma/ste_dma40.c     |    2 +-
 include/linux/dmaengine.h   |    5 ++
 7 files changed, 123 insertions(+), 68 deletions(-)

-- 
1.7.10.4

