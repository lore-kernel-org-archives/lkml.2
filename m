Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2IQRUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:20:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65006 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2IQRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:20:51 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: [PATCH v2 0/2] Add pinctrl support to omap2-mcspi
Date: Mon, 17 Sep 2012 13:22:16 -0400
Message-Id: <1347902538-21208-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- warns that pins are not configured by the driver rather than
	  exiting 
	- dummy states are only enabled for OMAP platforms where DT is
	  not populated

This series enables pinctrl support for McSPI. Platforms that boot only
from DT and rely on pinctrl to set pinmuxes appropriately require this
for omap2-mcspi operation.

It has been tested on AM335x BeagleBone with an Adafruit SPI LCD attached
and regression tested on Beagleboard xM booting in the !DT case, using
board-omap3evm.c. 

The series applies on top of Tony's dt-devel branch.

Matt Porter (2):
  spi: omap2-mcspi: add pinctrl support
  ARM: OMAP2+: Enable pinctrl dummy states

 arch/arm/mach-omap2/devices.c |    5 +++++
 drivers/spi/spi-omap2-mcspi.c |    8 ++++++++
 2 files changed, 13 insertions(+)

-- 
1.7.9.5

