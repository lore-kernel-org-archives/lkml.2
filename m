Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2FSKea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:45792 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2FSKe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="182050939"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 00/10] dw_dmac: set of cleanups and small fixes
Date: Tue, 19 Jun 2012 13:34:00 +0300
Message-Id: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides set of the cleanups and small fixes against the
DesignWare DMA controller driver. It's a first portion of the patches to make
the driver usable on other platforms.

since v1:
 - add dwc_chan_reset
 - disable block interrupts only in probe (discussed with Viresh Kumar)
 - fix comment line in probe in patch 6

Andy Shevchenko (10):
  dw_dmac: fix constant in the comment
  dw_dmac: use proper casting to print dma_addr_t values
  dw_dmac: introduce dwc_dump_chan_regs to dump registers
  dw_dmac: print correct number of scanned descriptors
  dw_dmac: use __func__ constant in the debug prints
  dw_dmac: disable dma in optimal way in probe
  dw_dmac: disable BLOCK interrupts
  dw_dmac: introduce dwc_fast_fls()
  dw_dmac: move from __init to __devinit
  dw_dmac: introduce dwc_chan_reset

 drivers/dma/dw_dmac.c      |  183 ++++++++++++++++++++------------------------
 drivers/dma/dw_dmac_regs.h |    2 +-
 2 files changed, 85 insertions(+), 100 deletions(-)

-- 
1.7.10

