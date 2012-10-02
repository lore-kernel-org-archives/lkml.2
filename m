Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2JBLme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:42:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:55043 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab2JBLmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:42:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="199571508"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/4] dw_dmac: few cleanups to the driver
Date: Tue,  2 Oct 2012 14:41:57 +0300
Message-Id: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few cleanups to the driver which already acked and reviewed.
I decide to split last series to two parts. This is first part.

Heikki Krogerus (4):
  dmaengine: dw_dmac: use helper macro module_platform_driver()
  dmaengine: dw_dmac: add module alias
  dmaengine: dw_dmac: remove CLK dependency
  dmaengine: dw_dmac: amend description and indentation

 drivers/dma/Kconfig   |    1 -
 drivers/dma/dw_dmac.c |   20 ++++++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

-- 
1.7.10.4

