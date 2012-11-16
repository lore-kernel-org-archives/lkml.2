Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2KPPwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:52:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:44096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2KPPwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:52:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,265,1352102400"; 
   d="scan'208";a="250305881"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/6] dmaengine: introduce is_slave_xfer helper
Date: Fri, 16 Nov 2012 17:51:59 +0200
Message-Id: <1353081126-17995-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a common practice to distinguish slave type transfers by checking
direction of the channel. This series introduces the check helper and its usage
across the drivers.

Since v1:
 - append commit messages to the all patches
 - update description for the patches against dw_dmac and at_hdmac
 - apply all current Reviewed-by and Acked-by tags

Andy Shevchenko (6):
  dmaengine: introduce is_slave_xfer function
  dma: at_hdmac: check direction properly for cyclic transfers
  dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
  dma: ep93xx_dma: reuse is_slave_xfer helper
  dma: ipu_idmac: reuse is_slave_xfer helper
  dma: ste_dma40: reuse is_slave_xfer helper

 drivers/dma/at_hdmac.c      |   10 +++++-----
 drivers/dma/dw_dmac.c       |    5 +++--
 drivers/dma/ep93xx_dma.c    |    3 +--
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 drivers/dma/ste_dma40.c     |    2 +-
 include/linux/dmaengine.h   |    5 +++++
 6 files changed, 16 insertions(+), 11 deletions(-)

-- 
1.7.10.4

