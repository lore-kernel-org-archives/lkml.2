Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab2CTKaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:30:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2CTKaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:30:08 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 0/3] SPI updates 
Date: Tue, 20 Mar 2012 15:59:46 +0530
Message-ID: <1332239389-1897-1-git-send-email-shubhrajyoti@ti.com>
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

This is also available through
git     : git://gitorious.org/linus-tree/linus-tree.git
branch  : spi


Felipe Balbi (2):
  spi: omap2-mcspi: make it behave as a module
  spi: omap2-mcspi: convert to module_platform_driver

Shubhrajyoti D (1):
  spi: omap2-mcspi: use devm_* functions

 drivers/spi/spi-omap2-mcspi.c |   46 ++++++++---------------------------------
 1 files changed, 9 insertions(+), 37 deletions(-)

