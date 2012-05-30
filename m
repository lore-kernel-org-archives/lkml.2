Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2E3K46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:56:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34479 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2E3K44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:56:56 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
Date: Wed, 30 May 2012 16:26:29 +0530
Message-ID: <1338375394-16268-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is done as a preparatory step for adding phy drivers
for dwc3 and musb.

This series adds a new driver for ocp2scp to which phy drivers are connected.

I'm planning to send phy drivers asap. Meanwhile I'd like to get some
review comments for this series. I have also plans to send device tree
adaptation of the ocp2scp driver.

Developed on
http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next

If it has to be based on some other tree, please let me know.

Kishon Vijay Abraham I (5):
  arm: omap: hwmod: make *phy_48m* as the main_clk of ocp2scp
  arm: omap: remove ocp2scp_usb_phy_ick clock node
  drivers: misc: omap: add a new driver for ocp2scp
  ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
  arm: omap: ocp2scp: create omap device for ocp2scp

 arch/arm/mach-omap2/clock44xx_data.c       |   11 ---
 arch/arm/mach-omap2/devices.c              |   72 +++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   22 +++++
 drivers/misc/Kconfig                       |    8 ++
 drivers/misc/Makefile                      |    1 +
 drivers/misc/omap-ocp2scp.c                |  135 ++++++++++++++++++++++++++++
 include/linux/platform_data/omap_ocp2scp.h |   31 +++++++
 7 files changed, 269 insertions(+), 11 deletions(-)
 create mode 100644 drivers/misc/omap-ocp2scp.c
 create mode 100644 include/linux/platform_data/omap_ocp2scp.h

-- 
1.7.5.4

