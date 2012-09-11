Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2IKRph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:45:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60696 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2IKRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:45:34 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: [PATCH 0/2] Add pinctrl support to omap2-mcspi
Date: Tue, 11 Sep 2012 13:46:37 -0400
Message-Id: <1347385599-27558-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables pinctrl support for McSPI. Platforms that boot only
from DT and rely on pinctrl to set pinmuxes appropriately require this
for omap2-mcspi operation.

It has been tested on AM335x BeagleBone with an Adafruit SPI LCD attached
and regression tested on Beagleboard xM booting in the !DT case, using
board-omap3evm.c. There is a dependency on the patch to enable PINCTRL
support (https://patchwork.kernel.org/patch/1376331/) for
ARCH_OMAP2PLUS_TYPICAL.

Matt Porter (2):
  spi: omap2-mcspi: add pinctrl support
  ARM: OMAP2+: Enable pinctrl dummy states

 arch/arm/mach-omap2/devices.c |    4 ++++
 drivers/spi/spi-omap2-mcspi.c |    9 +++++++++
 2 files changed, 13 insertions(+)

-- 
1.7.9.5

