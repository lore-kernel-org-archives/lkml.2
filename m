Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0EUI0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:26:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47120 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab0EUI0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:26:03 -0400
Subject: [GIT PULL] OMAP DSS updates for 2.6.35
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 11:24:58 +0300
Message-ID: <1274430298.4246.81.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 May 2010 08:24:59.0680 (UTC) FILETIME=[1A474200:01CAF8BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are latest updates for OMAP display subsystem. Small fixes, support
for new boards and panels.

 Tomi

The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Carlos Lopez (1):
      OMAP2: DSS: Add missing line for update bg color

Grazvydas Ignotas (1):
      OMAP: DSS2: TPO-TD03MTEA1: fix Kconfig dependency

Jani Nikula (6):
      OMAP: DSS2: fix lock_fb_info() and omapfb_lock() locking order
      OMAP: DSS2: check lock_fb_info() return value
      OMAP: DSS2: VENC: don't call platform_enable/disable() twice
      OMAP: DSS2: Fix device disable when driver is not loaded
      OMAP: DSS2: omap_dss_probe() conditional compilation cleanup
      OMAP: DSS2: Fix omap_dss_probe() error path

Kishore Y (1):
      OMAP3630: DSS2: Updating MAX divider value

Koen Kooi (1):
      board-omap3-beagle: add DSS2 support

Roger Quadros (7):
      OMAP: DSS2: Add Kconfig option for DPI display type
      OMAP: DSS2: Remove redundant enable/disable calls from SDI
      OMAP: DSS2: Use vdds_sdi regulator supply in SDI
      OMAP: RX51: Add LCD Panel support
      OMAP: RX51: Add Touch Controller in SPI board info
      OMAP: DSS2: Add ACX565AKM Panel Driver
      OMAP: RX51: Update board defconfig

Tomi Valkeinen (2):
      OMAP: DSS2: Make partial update width even
      OMAP: DSS2: Taal: add mutex to protect panel data

Vaibhav Hiremath (3):
      OMAP: Enable DSS2 in OMAP3EVM defconfig
      OMAP: AM3517: Enable DSS2 in AM3517EVM defconfig
      OMAP: LCD LS037V7DW01: Add Backlight driver support

Ville Syrjälä (1):
      OMAP: DSS2: Taal: Fix DSI bus locking problem

 arch/arm/configs/am3517_evm_defconfig              |   52 ++-
 arch/arm/configs/omap3_evm_defconfig               |   51 ++-
 arch/arm/configs/rx51_defconfig                    |   39 +-
 arch/arm/mach-omap2/Makefile                       |    1 +
 arch/arm/mach-omap2/board-omap3beagle.c            |  101 ++-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   28 +
 arch/arm/mach-omap2/board-rx51-video.c             |  109 +++
 arch/arm/mach-omap2/board-rx51.c                   |    2 +
 drivers/video/omap2/displays/Kconfig               |    9 +-
 drivers/video/omap2/displays/Makefile              |    1 +
 drivers/video/omap2/displays/panel-acx565akm.c     |  819 ++++++++++++++++++++
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |   78 ++
 drivers/video/omap2/displays/panel-taal.c          |  143 +++-
 drivers/video/omap2/dss/Kconfig                    |    6 +
 drivers/video/omap2/dss/Makefile                   |    3 +-
 drivers/video/omap2/dss/core.c                     |   85 ++-
 drivers/video/omap2/dss/display.c                  |    9 +-
 drivers/video/omap2/dss/dss.c                      |   24 +-
 drivers/video/omap2/dss/dss.h                      |   50 ++
 drivers/video/omap2/dss/manager.c                  |   21 +
 drivers/video/omap2/dss/sdi.c                      |   26 +-
 drivers/video/omap2/dss/venc.c                     |   15 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    5 +-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |   25 +-
 24 files changed, 1573 insertions(+), 129 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-rx51-video.c
 create mode 100644 drivers/video/omap2/displays/panel-acx565akm.c


