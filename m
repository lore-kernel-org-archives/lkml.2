Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2CZNpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:45:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33419 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab2CZNo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:44:58 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/5] spi: omap2-mcspi: driver updates
Date: Mon, 26 Mar 2012 19:14:35 +0530
Message-ID: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series does the following cleanups
- Converts the spi to module_platform_driver
- Use the devm functions so that the freeing need not 
  be done in the driver.
- Makes the driver use autosuspend
- Folds Benoit's bus_num removal patch in the series

Changes from the previous version
- Makes the driver use autosuspend
- Folds Benoit's bus_num removal patch in the series


This is also available through
git     : git://gitorious.org/linus-tree/linus-tree.git
branch  : spi



Benoit Cousson (1):
  spi/omap: Remove bus_num usage for instance index

Felipe Balbi (2):
  spi: omap2-mcspi: make it behave as a module
  spi: omap2-mcspi: convert to module_platform_driver

Shubhrajyoti D (2):
  spi: omap2-mcspi: use devm_* functions
  spi: omap2-mcspi: add support for pm_runtime autosuspend

 drivers/spi/spi-omap2-mcspi.c |  127 +++++++++++++++-------------------------
 1 files changed, 48 insertions(+), 79 deletions(-)

