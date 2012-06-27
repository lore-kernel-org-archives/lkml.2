Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2F0W0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:26:36 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:49130 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753987Ab2F0W0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:26:34 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/8] ARM: LPC32xx specific updates for next, second set
Date: Thu, 28 Jun 2012 00:26:10 +0200
Message-Id: <1340835978-20331-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second round of patches for mach-lpc32xx, for v3.6. It builds upon
the first round of 22 patches and includes clock updates that separate out
initialization from the board specific init to clock.c.

Further, a defconfig update for LPC32xx, dts file update and mmc bugfix is
included.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--

You can also pull from

  git://git.antcom.de/linux-2.6.git lpc32xx-next2

Roland Stigge (6):
 ARM: LPC32xx: Init MMC via clock
 ARM: LPC32xx: Add further bits to MMC init
 ARM: LPC32xx: Remove wrong re-initialization of MMC clock register
 ARM: LPC32xx: Update DTS file for EA3250 board
 ARM: LPC32xx: Defconfig update
 ARM: LPC32xx: Remove USB and I2C init from phy3250.c
Alexandre Pereira da Silva (2):
 ARM: LPC32xx: Cleanup USB clock init
 ARM: LPC32xx: Remove unused gpios

 arch/arm/boot/dts/ea3250.dts                  |   17 ++++
 arch/arm/configs/lpc32xx_defconfig            |    2 
 arch/arm/mach-lpc32xx/clock.c                 |   90 ++++++++++++++++++++++----
 arch/arm/mach-lpc32xx/include/mach/platform.h |   14 ++++
 arch/arm/mach-lpc32xx/phy3250.c               |   20 -----
 5 files changed, 112 insertions(+), 31 deletions(-)
