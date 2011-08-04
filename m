Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1HDP71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:59:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56185 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1HDP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:59:26 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Abhilash K V <abhilash.kv@ti.com>,
        Sanjeev Premi <premi@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/2] AM3517: Booting up
Date: Thu, 4 Aug 2011 21:29:07 +0530
Message-ID: <1312473547-1147-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set gets the kernel booting up on a AM3517 EVM.
The board is able to boot with ramdisk after this,but the MMC and Ethernet
drivers are not up yet. Lots of warnings remain which will be addressed in
subsequent patches.

The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.0.0-rc7 and last commit on top of which these patches
were added is:

	885cf6ff7d3dad4cc44be74b0577d3a554d3ab71: Linux-omap rebuilt:
	Updated to -rc7, added new boards

Cc: Sanjeev Premi <premi@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
---

Abhilash K V (1):
  AM35x: Using OMAP3 generic hwmods

Vaibhav Hiremath (1):
  omap_twl: Prevent SR to enable for am3517/am3505 devices

 arch/arm/mach-omap2/board-am3517evm.c        |   11 +++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             |    3 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 ++++++++++++++++++
 arch/arm/mach-omap2/omap_twl.c               |    8 ++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    3 +++
 5 files changed, 42 insertions(+), 1 deletions(-)

