Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2JROeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:34:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:11550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2JROeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,607,1344236400"; 
   d="scan'208";a="207676604"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 0/6] dw_dmac: few cleanups to the driver
Date: Thu, 18 Oct 2012 17:34:06 +0300
Message-Id: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few cleanups to the driver which partialy acked and reviewed.

Since v2:
 - add one more clean up (patch 6/6)
 - make a separate patch to WARN a user in dwc_handle_error (suggested by
   Felipe Balbi)
 - add a description to patch 4/6

Andy Shevchenko (4):
  dw_dmac: change dev_printk() to corresponding macros
  dw_dmac: don't call platform_get_drvdata twice
  dw_dmac: change dev_crit to dev_WARN in dwc_handle_error
  dw_dmac: introduce to_dw_desc() macro

Heikki Krogerus (2):
  dmaengine: dw_dmac: remove CLK dependency
  dmaengine: dw_dmac: amend description and indentation

 drivers/dma/Kconfig        |    1 -
 drivers/dma/dw_dmac.c      |   33 ++++++++++++++-------------------
 drivers/dma/dw_dmac_regs.h |    2 ++
 3 files changed, 16 insertions(+), 20 deletions(-)

-- 
1.7.10.4

