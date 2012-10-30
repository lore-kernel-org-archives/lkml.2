Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab2J3McY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:32:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:2316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab2J3McX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="234568330"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/3] dw_dmac: add PCI driver and move dw stuff to its own folder
Date: Tue, 30 Oct 2012 14:32:09 +0200
Message-Id: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is split of the dw_dmac to support different platform devices with one
core driver. It uses platform_driver model and weak link to the parent driver.
The pros and cons are still under discussion here:
http://www.spinics.net/lists/kernel/msg1408495.html

Andy Shevchenko (2):
  dma: move dw_dmac driver to an own directory
  MAINTAINERS: add recently created files to dw_dmac section

Heikki Krogerus (1):
  dmaengine: dw_dmac: add PCI part of the driver

 MAINTAINERS                         |    3 +-
 drivers/dma/Kconfig                 |    9 +++
 drivers/dma/Makefile                |    2 +-
 drivers/dma/dw/Makefile             |    2 +
 drivers/dma/{ => dw}/dw_dmac.c      |    2 +-
 drivers/dma/dw/dw_dmac_pci.c        |  133 +++++++++++++++++++++++++++++++++++
 drivers/dma/{ => dw}/dw_dmac_regs.h |    0
 7 files changed, 147 insertions(+), 4 deletions(-)
 create mode 100644 drivers/dma/dw/Makefile
 rename drivers/dma/{ => dw}/dw_dmac.c (99%)
 create mode 100644 drivers/dma/dw/dw_dmac_pci.c
 rename drivers/dma/{ => dw}/dw_dmac_regs.h (100%)

-- 
1.7.10.4

