Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0JZHxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:53:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:62911 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0JZHxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:53:42 -0400
Subject: [GIT PULL] omap DSS changes for 2.6.27
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 26 Oct 2010 10:53:42 +0300
Message-ID: <1288079622.2580.130.camel@tubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Oct 2010 07:53:21.0815 (UTC) FILETIME=[DC548A70:01CB74E2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull OMAP display subsystem changes:


The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Archit Taneja (2):
      OMAP: DSS2: Introduce dss_features files
      OMAP: DSS2: Use dss_features framework on DSS2 code

Grazvydas Ignotas (1):
      OMAP: DSS2: make filter coefficient tables human readable

Jarkko Nikula (1):
      OMAP: DSS2: Add SPI dependency to Kconfig of ACX565AKM panel

Nicolas Kaiser (2):
      video/omap: remove mux.h include
      arm/omap: simplify conditional

Senthilvadivu Guruswamy (4):
      OMAP: DSS2: DSI: Remove extra iounmap in error path
      OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
      OMAP: DSS2: OMAPFB: make VRFB depends on OMAP2,3
      OMAP: DSS2: OMAPFB: Allow usage of def_vrfb only for omap2,3

Stanley.Miao (1):
      OMAP: DSS2: don't power off a panel twice

Tasslehoff Kjappfot (1):
      OMAP: DSS2: OMAPFB: swap front and back porches for both hsync and vsync

Uwe Kleine-König (3):
      ARM: omap/fb: move omap_init_fb to .init.text
      ARM: omap/fb: move omapfb_reserve_sram to .init.text
      ARM: omap/fb: move get_fbmem_region() to .init.text

 arch/arm/plat-omap/fb.c                            |   14 +-
 arch/arm/plat-omap/include/plat/display.h          |   31 ---
 arch/arm/plat-omap/include/plat/vrfb.h             |   16 ++
 drivers/video/omap/lcd_omap3beagle.c               |    2 -
 drivers/video/omap2/displays/Kconfig               |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    6 +
 drivers/video/omap2/displays/panel-generic.c       |    6 +
 .../video/omap2/displays/panel-sharp-lq043t1dg01.c |    6 +
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |    6 +
 .../video/omap2/displays/panel-toppoly-tdo35s.c    |    6 +
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |    6 +
 drivers/video/omap2/dss/Makefile                   |    2 +-
 drivers/video/omap2/dss/core.c                     |    3 +
 drivers/video/omap2/dss/dispc.c                    |  270 +++++++++-----------
 drivers/video/omap2/dss/dsi.c                      |    1 -
 drivers/video/omap2/dss/dss_features.c             |  191 ++++++++++++++
 drivers/video/omap2/dss/dss_features.h             |   50 ++++
 drivers/video/omap2/dss/manager.c                  |   33 ++--
 drivers/video/omap2/dss/overlay.c                  |   24 +-
 drivers/video/omap2/omapfb/Kconfig                 |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   26 ++-
 21 files changed, 475 insertions(+), 228 deletions(-)
 create mode 100644 drivers/video/omap2/dss/dss_features.c
 create mode 100644 drivers/video/omap2/dss/dss_features.h


