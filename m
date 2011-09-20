Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1ITO5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:57:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44145 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ITO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:57:40 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
        <tony@atomide.com>, <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <kyungmin.park@samsung.com>, <hverkuil@xs4all.nl>,
        <m.szyprowski@samsung.com>, <g.liakhovetski@gmx.de>,
        <santosh.shilimkar@ti.com>, <khilman@deeprootsystems.com>,
        <david.woodhouse@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 0/5] OMAP3EVM: Add support for MT9T111 sensor
Date: Tue, 20 Sep 2011 20:26:47 +0530
Message-ID: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset
	-adds support for MT9T111 sensor on omap3evm.
	Currently the sensor driver supports only
	VGA resolution.
	-enables MT9T111 sensor in omap2plus_defconfig.

This is applied on top of the following patchset
http://www.spinics.net/lists/linux-media/msg37270.html 
which adds YUYV input support for OMAP3ISP.
---

Deepthy Ravi (2):
  ispccdc: Configure CCDC_SYN_MODE register for     UYVY8_2X8 and
    YUYV8_2X8 formats
  omap2plus_defconfig: Enable omap3isp and MT9T111     sensor drivers

Vaibhav Hiremath (3):
  omap3evm: Enable regulators for camera interface
  [media] v4l: Add mt9t111 sensor driver
  omap3evm: Add Camera board init/hookup file

 arch/arm/configs/omap2plus_defconfig        |   10 +
 arch/arm/mach-omap2/Makefile                |    5 +
 arch/arm/mach-omap2/board-omap3evm-camera.c |  185 ++++
 arch/arm/mach-omap2/board-omap3evm.c        |   25 +
 drivers/media/video/Kconfig                 |    7 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/mt9t111.c               |  793 ++++++++++++++++
 drivers/media/video/mt9t111_reg.h           | 1367 +++++++++++++++++++++++++++
 drivers/media/video/omap3isp/ispccdc.c      |   11 +-
 include/media/mt9t111.h                     |   45 +
 10 files changed, 2446 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
 create mode 100644 drivers/media/video/mt9t111.c
 create mode 100644 drivers/media/video/mt9t111_reg.h
 create mode 100644 include/media/mt9t111.h

