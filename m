Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0EUGjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:39:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58732 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab0EUGjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:39:03 -0400
Date: Fri, 21 May 2010 08:39:00 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Arm i.MX changes
Message-ID: <20100521063900.GA17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:35:30 up 25 days, 1 min, 16 users,  load average: 0.69, 0.40,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Arm i.MX related changes. They are normally
going via Russell King, but I missed him closing his tree this time.

Sascha


The following changes since commit f72caf7e496465182eeda842ac66a5e75404ddf1:
  Linus Torvalds (1):
        Merge branch 'for-2.6.35' of git://linux-nfs.org/~bfields/linux

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6 for-linus

Alberto Panizzo (2):
      MX3X: Add Keypad device definition for MX3X arch
      mx31_3ds: Support the keypad situated in the personality board

Amit Kucheria (1):
      mxc: Change gpt timer code to be more generic by using V2 instead of MX3

Daniel Mack (5):
      ARM: mx3/lilly1131: add USB support
      ARM: MXC: mxcmmc: misc cleanups
      ARM: MXC: mxcmmc: Teach the driver SDIO operations
      ARM: MXC: mxcmmc: work around a bug in the SDHC busy line handling
      ARM: mx3: Fix a race condition in mxcmmc

Dinh Nguyen (9):
      mx5: Add registration of GPIOs for MX5 devices
      mxc: Update GPIO for USB support on Freescale MX51 Babbage HW
      mx5: Add USB device definitions for Freescale MX51 Babbage HW
      mx5: Enable board specific functions for enabling USB host on Babbage
      mxc: Add generic USB HW initialization for MX51
      mx5: Add USB to Freescale MX51 defconfig
      mx5: change usb clock source from pll3 to pll2
      mx5: enable usb gadget for freescale mx51 babbage board
      mx5: bring usb phy out of reset on freescale mx51 babbage hw

Ivo Clarysse (2):
      MXC: mxc_nand: set NFC registers after reset
      MXC: mxc_nand: support i.MX21

Magnus Lilja (1):
      MXC: Add USB OTG (device) for i.MX31 PDK (3DS) board.

Philippe Rétornaz (3):
      mx31moboard: Fix usb PHY reset
      mx31moboard: Move usb OTG device registration
      mx31moboard: OTG host support for smartbot board

Valentin Longchamp (1):
      mx31smartbot: change the config of a gpio

Vladimir Zapolskiy (2):
      imx3: Add rtc platform device support
      imx31: add rtc device on litekit board.

Wolfram Sang (6):
      arm/plat-mxc: Fix forgotten renaming in timer.c
      arm/mach-mx2/3: Fix watchdog-devices to match the current driver
      arm/mach-mx3: add watchdog device to Phytec-boards
      arm/mach-mx2: add watchdog device to Phytec-boards
      arm/mx25: add watchdog device
      arm/mx51: add watchdog device

 arch/arm/configs/mx51_defconfig                    |   17 ++-
 arch/arm/mach-mx2/devices.c                        |    9 +-
 arch/arm/mach-mx2/mach-pca100.c                    |    1 +
 arch/arm/mach-mx2/mach-pcm038.c                    |    1 +
 arch/arm/mach-mx25/devices.c                       |   15 ++
 arch/arm/mach-mx25/devices.h                       |    1 +
 arch/arm/mach-mx3/Kconfig                          |    1 +
 arch/arm/mach-mx3/devices.c                        |   40 +++++-
 arch/arm/mach-mx3/devices.h                        |    2 +
 arch/arm/mach-mx3/mach-mx31_3ds.c                  |   87 ++++++++++
 arch/arm/mach-mx3/mach-mx31lilly.c                 |  145 +++++++++++++++++
 arch/arm/mach-mx3/mach-mx31moboard.c               |  104 +++++--------
 arch/arm/mach-mx3/mach-pcm037.c                    |    1 +
 arch/arm/mach-mx3/mach-pcm043.c                    |    1 +
 arch/arm/mach-mx3/mx31lite-db.c                    |    1 +
 arch/arm/mach-mx3/mx31moboard-devboard.c           |    9 +
 arch/arm/mach-mx3/mx31moboard-marxbot.c            |    8 +
 arch/arm/mach-mx3/mx31moboard-smartbot.c           |   53 ++++++-
 arch/arm/mach-mx5/board-mx51_babbage.c             |  167 ++++++++++++++++++++
 arch/arm/mach-mx5/clock-mx51.c                     |   45 ++++++
 arch/arm/mach-mx5/devices.c                        |  109 +++++++++++++-
 arch/arm/mach-mx5/devices.h                        |    4 +
 arch/arm/plat-mxc/ehci.c                           |  100 ++++++++++++-
 arch/arm/plat-mxc/gpio.c                           |    5 +-
 arch/arm/plat-mxc/include/mach/board-mx31moboard.h |    3 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |   17 ++
 arch/arm/plat-mxc/include/mach/iomux-mx51.h        |   34 +++--
 arch/arm/plat-mxc/include/mach/mxc_ehci.h          |   14 ++-
 arch/arm/plat-mxc/time.c                           |   46 +++---
 arch/arm/plat-mxc/tzic.c                           |    4 +-
 drivers/mmc/core/sdio.c                            |    6 +
 drivers/mmc/host/mxcmmc.c                          |  114 ++++++++++++--
 drivers/mtd/nand/mxc_nand.c                        |  125 ++++++++-------
 drivers/usb/host/ehci-mxc.c                        |    4 +-
 include/linux/mmc/host.h                           |    3 +
 35 files changed, 1097 insertions(+), 199 deletions(-)
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
