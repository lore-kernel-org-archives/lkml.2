Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2JQKba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:31:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:6595 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab2JQKb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:31:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,599,1344236400"; 
   d="scan'208";a="236302133"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/4] dw_dmac: few cleanups to the driver
Date: Wed, 17 Oct 2012 13:31:14 +0300
Message-Id: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few cleanups to the driver which partialy acked and reviewed.

Since v1:
- patch 1/4 ("use helper macro module_platform_driver()") is removed from the
  series: it brings issues rather than cleans up
- patch 2/4 ("add module alias") is postponed

Andy Shevchenko (2):
  dw_dmac: change {dev_}printk() to corresponding macros
  dw_dmac: don't call platform_get_drvdata twice

Heikki Krogerus (2):
  dmaengine: dw_dmac: remove CLK dependency
  dmaengine: dw_dmac: amend description and indentation

 drivers/dma/Kconfig   |    1 -
 drivers/dma/dw_dmac.c |   25 +++++++++++--------------
 2 files changed, 11 insertions(+), 15 deletions(-)

-- 
1.7.10.4

