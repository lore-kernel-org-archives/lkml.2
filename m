Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2FOHFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:05:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:37602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2FOHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:05:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165961713"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/9] dw_dmac: set of cleanups and small fixes
Date: Fri, 15 Jun 2012 10:05:04 +0300
Message-Id: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides set of the cleanups and small fixes against the
DesignWare DMA controller driver. It's a first portion of the patches to make
the driver usable on other platforms.

Andy Shevchenko (9):
  dw_dmac: fix constant in the comment
  dw_dmac: use proper casting to print dma_addr_t values
  dw_dmac: introduce dwc_dump_chan_regs to dump registers
  dw_dmac: print correct number of scanned descriptors
  dw_dmac: use __func__ constant in the debug prints
  dw_dmac: disable dma in optimal way in probe
  dw_dmac: disable BLOCK interrupts
  dw_dmac: introduce dwc_fast_fls()
  dw_dmac: move from __init to __devinit

 drivers/dma/dw_dmac.c      |  148 ++++++++++++++++++++------------------------
 drivers/dma/dw_dmac_regs.h |    2 +-
 2 files changed, 69 insertions(+), 81 deletions(-)

-- 
1.7.10

