Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266Ab0HFMtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:49:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54472 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0HFMti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:49:38 -0400
Subject: [GIT PULL] OMAP DSS updates for 2.6.36
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 15:49:15 +0300
Message-ID: <1281098955.3436.230.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Aug 2010 12:49:19.0636 (UTC) FILETIME=[C95B3D40:01CB3565]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull OMAP Display Subsystem patches from below. Mostly fixes and
improvements to existing features.

 Tomi


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git for-linus

Afzal Mohammed (1):
      OMAP: DSS2: OMAPFB: Fix probe error path

Archit Taneja (3):
      OMAP: DSS2: Remove extra return statement
      OMAP: DSS2: Fix error path in omap_dsi_update()
      OMAP: DSS2: Replace strncmp() with sysfs_streq() in overlay_manager_store()

Grazvydas Ignotas (1):
      OMAP: DSS2: OMAPFB: add support for FBIO_WAITFORVSYNC

Igor Grinberg (1):
      OMAP: DSS2: TDO35S: fix video signaling

Jani Nikula (21):
      OMAP: DSS2: Taal: Add panel hardware reset
      OMAP: DSS2: Taal: Add locks to protect taal data access
      OMAP: DSS2: Taal: Remove platform enable/disable
      OMAP: DSS2: Taal: Fix request_irq() error handling
      OMAP: DSS2: Taal: Remove ESD work cancel from driver probe error handling
      OMAP: DSS2: Taal: Improve taal_power_on() error handling
      OMAP: DSS2: Taal: Ensure panel is enabled in enable_te() and run_test()
      OMAP: DSS2: Taal: Change DSI bus locking to avoid deadlock in ESD work
      OMAP: DSS2: Taal: Check taal_power_on() return value in taal_resume()
      OMAP: DSS2: Taal: Change ESD work management
      OMAP: DSS2: Taal: Change probe error handling labels
      OMAP: DSS2: Taal: Add proper external TE support
      OMAP: DSS2: Add Nokia DSI command mode panel configuration struct
      OMAP: DSS2: Taal: Configure ESD check in DSI panel data
      OMAP: DSS2: Taal: Add panel specific configuration structure
      OMAP: DSS2: Taal: Print panel name in addition to revision
      OMAP: DSS2: Taal: CABC workaround is Taal specific
      OMAP: DSS2: OMAPFB: Check fb2display() return value
      OMAP: DSS2: OMAPFB: Remove redundant rotate range check
      OMAP: DSS2: OMAPFB: Remove redundant color register range check
      OMAP: DSS2: OMAPFB: Fix sysfs mirror input check

Maurus Cuelenaere (1):
      OMAP: DSS2: OMAPFB: Fix invalid bpp for PAL and NTSC modes

Tobias Klauser (1):
      OMAP: DSS2: storage class should be before const qualifier

Tomi Valkeinen (20):
      OMAP: DSS2: DSI: Increase HS TX timeout
      OMAP: DSS2: Fix update area calculations with multiple scaled overlays
      OMAP: DSS2: DSI: print errors in dsi_vc_flush_receive_data()
      OMAP: DSS2: DSI: use a private workqueue
      OMAP: DSS2: DSI: change dsi_vc_dcs_read_2 parameters
      OMAP: DSS2: DSI: handle error in synchronous write
      OMAP: DSS2: DSI: change DSI timeout functions
      OMAP: DSS2: Taal: add locks to taal_bl_update_status
      OMAP: DSS2: Taal: Use Nokia DSI panel data
      OMAP: DSS2: Taal: Add regulator configuration support
      OMAP: DSS2: DSI: Wait for DSI PLL clocks to be active before selecting them
      OMAP: DSS2: DSI: change dsi_vc_config_l4/vp()
      OMAP: DSS2: DSI: use BTA to end the frame transfer
      OMAP: DSS2: change manual update scaling setup
      OMAP: DSS2: DSI: Remove BTA after set_max_rx_packet_size
      OMAP: DSS2: DSI: Add error IRQ mask for DSI complexIO
      OMAP: DSS2: DSI: increase FIFO low threshold
      OMAP: DSS2: DSI: detect unsupported update requests
      OMAP: DSS2: Taal: Optimize enable_te, rotate, mirror when value unchanged
      OMAP: DSS2: adjust YUV overlay width to be even

Vaibhav Hiremath (1):
      OMAP3EVM: Replace vdvi regulator supply with vdds_dsi

Ville Syrjälä (14):
      OMAP: DSS2: Check if display supports update mode changes
      OMAP: DSS2: Make wait_for_go() succeed for disabled displays
      OMAP: DSS2: clear spurious SYNC_LOST_DIGIT interrupts
      OMAP: DSS2: OMAPFB: Refactor overlay address calculations
      OMAP: DSS2: OMAPFB: Check var even if there isn't memory
      OMAP: DSS2: OMAPFB: Skip unnecessary set_overlay_info()
      OMAP: DSS2: OMAPFB: Add support for switching memory regions
      OMAP: DSS2: OMAPFB: Add locking for memory regions
      OMAP: DSS2: OMAPFB: Convert the memory region locking to rwsem
      OMAP: DSS2: OMAPFB: Make lockdep happy
      OMAP: DSS2: OMAPFB: Add some locking debug checks
      OMAP: DSS2: DSI: Disable PCKFREE on error
      OMAP: DSS2: DSI: Print an error message if DSI clock calc fails
      OMAP: DSS2: DSI: Disable interface when disabling the display

 arch/arm/mach-omap2/board-omap3evm.c               |    7 +-
 arch/arm/plat-omap/include/plat/display.h          |    9 +-
 arch/arm/plat-omap/include/plat/nokia-dsi-panel.h  |   31 ++
 drivers/video/omap2/displays/panel-taal.c          |  567 +++++++++++++++----
 .../video/omap2/displays/panel-toppoly-tdo35s.c    |    8 +-
 drivers/video/omap2/dss/dispc.c                    |   16 +-
 drivers/video/omap2/dss/display.c                  |    4 +-
 drivers/video/omap2/dss/dsi.c                      |  463 ++++++++---------
 drivers/video/omap2/dss/dss.c                      |    6 +
 drivers/video/omap2/dss/dss.h                      |   11 +-
 drivers/video/omap2/dss/manager.c                  |  236 +++++----
 drivers/video/omap2/dss/overlay.c                  |    2 +-
 drivers/video/omap2/dss/rfbi.c                     |    2 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |  188 ++++++-
 drivers/video/omap2/omapfb/omapfb-main.c           |  229 ++++++---
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |   70 ++-
 drivers/video/omap2/omapfb/omapfb.h                |   29 +-
 include/linux/omapfb.h                             |    5 +-
 18 files changed, 1281 insertions(+), 602 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/plat/nokia-dsi-panel.h


