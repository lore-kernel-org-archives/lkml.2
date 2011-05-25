Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab1EYIJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:09:42 -0400
Received: from linux-sh.org ([111.68.239.195]:40984 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1EYIJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:09:38 -0400
Date: Wed, 25 May 2011 17:09:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.40-rc1
Message-ID: <20110525080902.GA17603@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Which contains:

Amber Jain (5):
      OMAP: DSS2: Add new color formats for OMAP4
      OMAP: DSS2: Ensure non-zero FIR values are configured
      OMAP: DSS2: Use for loop where ever possible in SR(), RR()
      OMAP: DSS2: Add new registers for NV12 support
      OMAP: DSS2: Add support for NV12 format

Anatolij Gustschin (5):
      video: mb862xxfb: correct fix.smem_len field initialization
      video: mb862xxfb: use pre-initialized configuration for PCI GDCs
      video: mb862xxfb: relocate register space to get contiguous vram
      video: mb862xx: add support for controller's I2C bus adapter
      video: mb862xxfb: add support for L1 displaying

Archit Taneja (24):
      OMAP: DSS2: Fix: Return correct lcd clock source for OMAP2/3
      OMAP: DSS2: Fix: Return correct lcd clock source for OMAP2/3
      OMAP4: DSS2: Register configuration changes for DSI
      OMAP: DSS2: DSI: Introduce sync_vc functions
      OMAP2PLUS: DSS2: Change enum "dss_clk_source" to "omap_dss_clk_source"
      OMAP2PLUS: DSS2: Add clock sources to dss device clock configuration
      OMAP: DSS2: HDMI: Use dss_device clock configuration for HDMI PLL parameters
      OMAP2PLUS: DSS2: Remove hack config "CONFIG_OMAP2_DSS_USE_DSI_PLL"
      OMAP2PLUS: DSS2: Clean up omap_display_init()
      OMAP: DSS2: DSI: enable scp clock in dsi_dump_regs()
      OMAP: DSS2: Clean up DISPC overlay register definitions
      OMAP: DSS2: Clean up DISPC overlay manager register definitions
      OMAP: DSS2: Remove usage of struct dispc_reg
      OMAP: DSS2: DSI: Add extra omap_dss_device argument in functions exported by dsi
      OMAP: DSS2: Remove omap_dss_device argument from dsi_pll_init()
      OMAP: DSS2: Pass platform_device as an argument in dsi functions
      OMAP: DSS2: DSI: Use platform_device pointer to get dsi data
      OMAP: DSS2: DSI: Pass pointer to struct to packet_sent_handler isrs
      OMAP4: DSS2: DSI: Changes for DSI2 on OMAP4
      OMAP: DSS2: Taal: Use device name in backlight_device_register
      OMAP: DSS2: DSI: Remove DISPC pixel clock related info in dsi_dump_clocks()
      OMAP: DSS2: DSI: Use system workqueue for delayed work instead of a private workqueue
      OMAP: DSS2: DSI: Get number of DSI data lanes using DSI_GNQ register
      OMAP: DSS2: DSI: Get line buffer size from DSI_GNQ register

Axel Lin (1):
      video: da8xx-fb: fix section mismatch warning

Ben Hutchings (1):
      video: mb862xxfb: Require either FB_MB862XX_PCI_GDC or FB_MB862XX_LIME

Damian (3):
      sh_mobile_meram: MERAM framework for LCDC
      sh_mobile_meram: Add support for NV24 framebuffers
      sh_mobile_meram: Safely disable MERAM operation when not initialized

Enric Balletbo i Serra (2):
      OMAP: DSS2: Support for Seiko 70WVW1TZ3
      OMAP: DSS2: Support for Powertip PH480272T

Geert Uytterhoeven (3):
      fbdev/amifb: Correct check for video memory size
      fbdev/amifb: Do not call panic() if there's not enough Chip RAM
      fbdev/amifb: Remove superfluous alignment of frame buffer memory

Guennadi Liakhovetski (3):
      fbdev: sh_mobile_hdmi: runtime suspend HDMI on error and clean up paths
      fbdev: sh_mobile_lcdc: reduce scope of a variable
      fbdev: sh_mobile_lcdc: remove runtime PM calls from the notifier

Jani Nikula (2):
      OMAP: DSS2: Add method for querying display dimensions from DSS drivers
      OMAP: DSS2: OMAPFB: Remove implicit display update on unblank

Jingoo Han (7):
      video: s3c-fb: make runtime pm functions static
      video: s3c-fb: add spinlock to interrupt routine
      video: s3c-fb: correct window osd size offset values
      video: s3c-fb: add additional validate bpps
      video: s3c-fb: add window variant information for S5P
      video: s3c-fb: add gpio setup function to resume function
      video: s3c-fb: correct transparency checking in 32bpp

Julia Lawall (3):
      drivers/video: Convert release_resource to release_mem_region
      drivers/video/sm501fb.c: Convert release_resource to release_mem_region
      drivers/video/s3c2410fb.c: Convert release_resource to release_mem_region

Konstantin Khlebnikov (1):
      efifb: fix int to pointer cast warning

Liu Yuan (1):
      video, udlfb: Fix two build warnings about 'ignoring return value'

Mike Frysinger (1):
      OMAP2: avoid descending into disabled framebuffer dirs

Niels de Vos (1):
      OMAP: DSS2: OMAPFB: make DBG() more resistant in if-else constructions

Ondrej Zary (1):
      s3fb: add DDC support

Paul Mundt (1):
      s3fb: fix up DDC build with MTRR disabled.

Ricardo Neri (5):
      OMAP4: DSS2: Create a DSS features structure for OMAP4430 ES1.0
      OMAP4: DSS2: HDMI: Add DSS feature for CTS calculation
      OMAP4: DSS2: HDMI: Add enums and structures for audio
      OMAP4: DSS2: HDMI: Add functionality for audio configuration
      OMAP4: DSS2: HDMI: Implement ASoC Codec driver for HDMI audio

Stephen Rothwell (1):
      udlfb: include prefetch.h explicitly

Tomi Valkeinen (52):
      OMAP: DSS2: DSI: fix use_sys_clk & highfreq
      OMAP: DSS2: DSI: fix dsi_dump_clocks()
      OMAP: DSS2: DSI: Fix DSI PLL power bug
      OMAP: DSS2: fix panel Kconfig dependencies
      OMAP: DSS2: Move display.h to include/video/
      OMAP: DSS2: Move panel-generic-dpi.h to include/video/
      OMAP: DSS2: Move nokia-dsi-panel.h to include/video/
      OMAP: DSS2: DSI: fix use_sys_clk & highfreq
      OMAP: DSS2: DSI: fix dsi_dump_clocks()
      OMAP: DSS2: DSI: Fix DSI PLL power bug
      OMAP: DSS2: fix panel Kconfig dependencies
      OMAP: DSS2: move dss device clock configuration
      OMAP: DSS2: remove non-working msleep(40) workaround
      OMAP: DSS2: make 50ms bug-fix sleep optional
      OMAP: DSS2: VENC: make 20ms venc bug-fix sleep optional
      OMAP: DSS2: VENC: Remove sleeps at venc enable/disable
      OMAP: DSS2: OMAPFB: Handle errors when initializing panel
      OMAP: DSS2: VENC: Add missing start/stop_device calls
      OMAP: DSS2: make omap_dss_(un)register_device static
      OMAP: DSS2: use __exit for selected panel drivers
      OMAP: DSS2: Convert simple/strict_strto* to kstrto*
      OMAP: DSS2: improve clock debugfs output
      OMAP: DSS2: DSI: Add lane override functions
      OMAP: DSS2: DSI: Remove CIO LDO status check
      OMAP: DSS2: DSI: implement ULPS enter and exit
      OMAP: DSS2: DSI: add option to leave DSI lanes powered on
      OMAP: DSS2: DSI: rename complexio related functions
      OMAP: DSS2: Add FEAT_DSI_REVERSE_TXCLKESC
      OMAP: DSS2: DSI: fix _dsi_print_reset_status
      OMAP: DSS2: DSI: implement enable/disable SCP clk
      OMAP: DSS2: DSI: fix CIO init and uninit
      OMAP: DSS2: DSI: wait for TXCLKESC domain to come out of reset
      OMAP: DSS2: DSI: add parameter to enter ulps on disable
      OMAP: DSS2: DSI: Add DSI pad muxing support
      OMAP: DSS2: DSI: ensure VDDS_DSI is disabled on exit
      OMAP: DSS2: Taal: Implement configurable ESD interval
      OMAP: DSS2: Taal: Clean up ESD queueing
      OMAP: DSS2: Taal: Add sysfs file for ESD interval
      OMAP: DSS2: Taal: Separate panel reset
      OMAP: DSS2: Taal: Rename esd_wq to workqueue
      OMAP: DSS2: Taal: Implement ULPS functionality
      OMAP: DSS2: DSI: Add OMAP4 CIO irqs
      OMAP: DSS2: FEATURES: Add missing consts
      OMAP: DSS2: Remove DSS_IRQSTATUS
      OMAP: DSS2: Add missing dummy functions
      OMAPFB: fix wrong clock aliases and device name
      OMAP: DSS2: RFBI: add rfbi_bus_lock
      OMAP: DSS2: RFBI: clock enable/disable changes
      OMAP: DSS2: RFBI: add omap_rfbi_configure
      OMAP: DSS2: RFBI: cleanup
      OMAP: DSS2: OMAPFB: remove dead code
      OMAP: DSS2: OMAPFB: Reduce stack usage

Tormod Volden (2):
      savagefb: New S3_TWISTER and S3_PROSAVAGEDDR chip families
      savagefb: Enable LCD detection on mobile Twister

Vikram Pandita (1):
      OMAP: DSS2: DSI: enable interface for omap4

 arch/arm/mach-omap2/board-3430sdp.c                |    4 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   11 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    4 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    4 +-
 arch/arm/mach-omap2/board-devkit8000.c             |    4 +-
 arch/arm/mach-omap2/board-igep0020.c               |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    4 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    4 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |    4 +-
 arch/arm/mach-omap2/board-omap4panda.c             |    4 +-
 arch/arm/mach-omap2/board-overo.c                  |    4 +-
 arch/arm/mach-omap2/board-rx51-video.c             |    2 +-
 arch/arm/mach-omap2/board-zoom-display.c           |    2 +-
 arch/arm/mach-omap2/display.c                      |   77 +-
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    2 +-
 drivers/media/video/omap/omap_vout.c               |    2 +-
 drivers/media/video/omap/omap_voutdef.h            |    2 +-
 drivers/video/Kconfig                              |   42 +-
 drivers/video/Makefile                             |    1 +
 drivers/video/amifb.c                              |   27 +-
 drivers/video/da8xx-fb.c                           |    4 +-
 drivers/video/efifb.c                              |    4 +-
 drivers/video/mb862xx/Makefile                     |    5 +-
 drivers/video/mb862xx/mb862xx-i2c.c                |  177 ++
 drivers/video/mb862xx/mb862xx_reg.h                |   58 +-
 drivers/video/mb862xx/mb862xxfb.h                  |   36 +
 .../video/mb862xx/{mb862xxfb.c => mb862xxfbdrv.c}  |  152 ++-
 drivers/video/omap/dispc.c                         |    4 +-
 drivers/video/omap/omapfb_main.c                   |    2 +-
 drivers/video/omap/rfbi.c                          |    2 +-
 drivers/video/omap2/Makefile                       |    4 +-
 drivers/video/omap2/displays/Kconfig               |    9 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    2 +-
 drivers/video/omap2/displays/panel-generic-dpi.c   |   57 +-
 .../omap2/displays/panel-lgphilips-lb035q02.c      |    2 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |    2 +-
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |    6 +-
 drivers/video/omap2/displays/panel-taal.c          |  536 ++++-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   10 +-
 drivers/video/omap2/dss/Kconfig                    |   33 +-
 drivers/video/omap2/dss/core.c                     |   15 +-
 drivers/video/omap2/dss/dispc.c                    | 1552 +++++++------
 drivers/video/omap2/dss/dispc.h                    |  691 ++++++
 drivers/video/omap2/dss/display.c                  |   46 +-
 drivers/video/omap2/dss/dpi.c                      |  113 +-
 drivers/video/omap2/dss/dsi.c                      | 2367 +++++++++++++-------
 drivers/video/omap2/dss/dss.c                      |  118 +-
 drivers/video/omap2/dss/dss.h                      |   98 +-
 drivers/video/omap2/dss/dss_features.c             |  105 +-
 drivers/video/omap2/dss/dss_features.h             |   39 +-
 drivers/video/omap2/dss/hdmi.c                     |  461 ++++-
 drivers/video/omap2/dss/hdmi.h                     |  222 ++-
 drivers/video/omap2/dss/hdmi_omap4_panel.c         |    2 +-
 drivers/video/omap2/dss/manager.c                  |   14 +-
 drivers/video/omap2/dss/overlay.c                  |   43 +-
 drivers/video/omap2/dss/rfbi.c                     |  176 +--
 drivers/video/omap2/dss/sdi.c                      |    2 +-
 drivers/video/omap2/dss/venc.c                     |   23 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |   14 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  231 ++-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |   23 +-
 drivers/video/omap2/omapfb/omapfb.h                |    8 +-
 drivers/video/s3c-fb.c                             |  121 +-
 drivers/video/s3c2410fb.c                          |    8 +-
 drivers/video/s3fb.c                               |  209 ++-
 drivers/video/savage/savagefb-i2c.c                |    2 +
 drivers/video/savage/savagefb.h                    |    8 +-
 drivers/video/savage/savagefb_driver.c             |   15 +-
 drivers/video/sh7760fb.c                           |    6 +-
 drivers/video/sh_mobile_hdmi.c                     |   10 +-
 drivers/video/sh_mobile_lcdcfb.c                   |  126 +-
 drivers/video/sh_mobile_lcdcfb.h                   |    1 +
 drivers/video/sh_mobile_meram.c                    |  567 +++++
 drivers/video/sh_mobile_meram.h                    |   41 +
 drivers/video/sm501fb.c                            |   24 +-
 drivers/video/udlfb.c                              |   20 +-
 .../video/omap-panel-generic-dpi.h                 |    8 +-
 .../video/omap-panel-nokia-dsi.h                   |   14 +-
 .../plat/display.h => include/video/omapdss.h      |  114 +-
 include/video/sh_mobile_lcdc.h                     |    3 +
 include/video/sh_mobile_meram.h                    |   68 +
 82 files changed, 6771 insertions(+), 2272 deletions(-)
 create mode 100644 drivers/video/mb862xx/mb862xx-i2c.c
 rename drivers/video/mb862xx/{mb862xxfb.c => mb862xxfbdrv.c} (86%)
 create mode 100644 drivers/video/omap2/dss/dispc.h
 create mode 100644 drivers/video/sh_mobile_meram.c
 create mode 100644 drivers/video/sh_mobile_meram.h
 rename arch/arm/plat-omap/include/plat/panel-generic-dpi.h => include/video/omap-panel-generic-dpi.h (86%)
 rename arch/arm/plat-omap/include/plat/nokia-dsi-panel.h => include/video/omap-panel-nokia-dsi.h (65%)
 rename arch/arm/plat-omap/include/plat/display.h => include/video/omapdss.h (85%)
 create mode 100644 include/video/sh_mobile_meram.h
