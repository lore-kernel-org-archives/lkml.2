Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab2CVSif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:38:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58732 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756202Ab2CVSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:38:30 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18PlIdVSkEPsJtT5v3WxadV5XaeSTQNdZjntd4vhL
	mA7wYhMmH1LZKQ
Message-ID: <4F6B7189.7070509@gmx.de>
Date: Thu, 22 Mar 2012 18:38:01 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev updates for 3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the changes below.
Have a nice weekend.


Thanks,

Florian Tobias Schandinat


The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-updates-for-3.4

for you to fetch changes up to 6bff98b455cf3e666fd0e3d0d908eba874de0eee:

  Revert "video:uvesafb: Fix oops that uvesafb try to execute NX-protected page" (2012-03-21 13:28:31 +0000)

----------------------------------------------------------------
fbdev updates for 3.4

It includes:
- drivers for Samsung Exynos MIPI DSI and display port
- i740fb to support those old Intel chips
- large updates to OMAP, viafb and sh_mobile_lcdcfb
- some updates to s3c-fb and udlfb, few patches to others

----------------------------------------------------------------
Anatolij Gustschin (2):
      fbdev: da8xx:: fix reporting of the display timing info
      fbdev: da8xx: add support for SP10Q010 display

Archit Taneja (2):
      OMAPDSS: Features: Maintain dss_feats as a list
      OMAPDSS: DISPC: Fix scaling constraints for OMAP4

Axel Lin (1):
      video: convert drivers/video/* to use module_spi_driver()

Ben Collins (2):
      udlfb: Make sure to get correct endian keys from vendor descriptor
      udlfb: Add module_param to allow forcing pixel_limit

Bernie Thompson (2):
      udlfb: add maintainer
      udlfb: fix hcd_buffer_free panic on unplug/replug

Dan Carpenter (1):
      viafb: NULL dereference on allocation failure in query_edid()

Danny Kukawka (2):
      OMAPDSS: VENC: fix NULL pointer dereference in DSS2 VENC sysfs debug attr on OMAP4
      riva/fbdev: fix several -Wuninitialized

Donghwa Lee (3):
      video: support MIPI-DSI controller driver
      video: backlight: support s6e8ax0 panel driver based on MIPI DSI
      MAINTAINERS: add entry for exynos mipi display drivers

Florian Tobias Schandinat (26):
      Merge commit 'v3.3-rc1' into fbdev-next
      viafb: add auxiliary device management infrastructure
      viafb: set correct polarity for second adapter
      viafb: fill xres and yres
      viafb: make single framebuffer multiple adapter mode work
      viafb: make SAMM to also work on LCD
      viafb: fix I2C emulation on GPIO ports
      viafb: add initial EDID support
      Merge branch 'viafb-samm' into viafb-next
      Merge branch 'viafb-aux' into viafb-next
      i740fb: fix compile error when CONFIG_MTRR is not selected
      viafb: another workaround for OLPCs weird wiring
      viafb: Fix bug in centering code
      Merge branch 'fbdev-for-linus' into fbdev-next
      Merge branch 'fbdev-for-linus' into fbdev-next
      viafb: LCD bpp cleanup
      Merge pull request #1 from bernieplug/fbdev-next
      Merge commit 'v3.3-rc6' into fbdev-next
      viafb: modetable conversion
      viafb: avoid refresh and mode lookup in set_par
      Merge branch 'for-next' of git://linuxtv.org/pinchartl/fbdev into fbdev-next
      Merge branch 'viafb-next' of git://github.com/schandinat/linux-2.6 into fbdev-next
      Merge branch 'for-3.4' of git://gitorious.org/linux-omap-dss2/linux into fbdev-next
      Merge commit 'v3.3' into fbdev-next
      Revert "MAINTAINERS: add entry for exynos mipi display drivers"
      Revert "video:uvesafb: Fix oops that uvesafb try to execute NX-protected page"

Grazvydas Ignotas (2):
      OMAPDSS: TPO-TD03MTEA1: fix suspend hang
      OMAPDSS: TPO-TD03MTEA1: update default gamma

Jean Delvare (1):
      fbdev: bfin_adv7393fb: Drop needless include

Jingoo Han (8):
      video: use gpio_request_one
      video: s3c-fb: fix checkpatch error
      video: s3c-fb: add alpha value width setting
      video: s3c-fb: add video clock running at data under-flow
      video: support DP controller driver
      video: s3c-fb: use devm_request_irq()
      video: s3c-fb: Add support EXYNOS5 FIMD
      MAINTAINERS: add maintainer entry for Exynos DP driver

Julia Lawall (4):
      OMAPDSS: use devm_ functions
      drivers/video/au*fb.c: use devm_ functions
      drivers/video/pxa168fb.c: use devm_ functions
      drivers/video/pvr2fb.c: ensure arguments to request_irq and free_irq are compatible

Kay Sievers (1):
      udlfb: remove sysfs framebuffer device with USB .disconnect()

Kuninori Morimoto (2):
      fbdev: remove dependency of FB_SH_MOBILE_MERAM from FB_SH_MOBILE_LCDC
      fbdev: sh_mipi_dsi: add extra phyctrl for sh_mipi_dsi_info

Lajos Molnar (3):
      OMAPDSS: DISPC: Fix OMAP4 supported color formats
      OMAPDSS: DISPC: Fix FIR coefficients
      OMAPDSS: MANAGER/APPLY: Add runtime_pm protection around wait_for_go/vsync functions

Laurent Pinchart (55):
      fbdev: sh_mobile_lcdc: Reorder code into sections
      fbdev: sh_mobile_lcdc: Mark init-only symbols with __devinit(const)
      fbdev: sh_mobile_lcdc: Move pm runtime enable to probe()
      fbdev: sh_mobile_lcdc: Don't pass struct device around
      fbdev: sh_mobile_lcdc: Create functions to turn the display on/off
      fbdev: sh_mobile_hdmi: Don't access LCDC channel in notifier callback
      sh_mobile_hdmi: Remove platform data lcd_dev field
      fbdev: sh_mobile_lcdc: Add sh_mobile_lcdc_entity definition
      fbdev: sh_mobile_hdmi: Implement sh_mobile_lcdc_entity interface
      fbdev: sh_mipi_dsi: Implement sh_mobile_lcdc_entity interface
      fbdev: sh_mobile_lcdc: Handle HDMI/MIPI transmitter device directly
      arm: mach-shmobile: Add LCDC tx_dev field to platform data
      fbdev: sh_mipi_dsi: Don't hook up into board_cfg display operations
      fbdev: sh_mobile_hdmi: Don't hook up into board_cfg display operations
      arm: mach-shmobile: Don't initialize the hdmi_info lcd_chan field
      fbdev: sh_mobile_hdmi: Remove sh_mobile_hdmi_info lcd_chan field
      fbdev: sh_mobile_lcdc: Remove board configuration owner field
      fbdev: sh_mobile_lcdc: Remove board configuration board_data field
      fbdev: sh_mobile_lcdc: Move brightness ops to sh_mobile_lcdc_bl_info
      fbdev: sh_mobile_lcdc: Merge board_cfg and lcd_size_cfg into panel_cfg
      sh_mobile_lcdc: Add an lcdc channel pointer to sh_mobile_lcdc_entity
      sh_mobile_hdmi: Use sh_mobile_lcdc_entity::channel to access fb_info
      fbdev: sh_mobile_lcdc: Remove fb_info parameter to display_on operation
      fbdev: sh_mobile_lcdc: Return display connection state in display_on
      sh_mobile_lcdc: Add display notify callback to sh_mobile_lcdc_chan
      sh_mobile_hdmi: Use LCDC notification callback
      fbdev: sh_mobile_lcdc: Pass a video mode to the notify callback
      fbdev: sh_mobile_hdmi: Don't set sh_hdmi::mode in the display on handler
      fbdev: sh_mobile_hdmi: Don't access LCDC fb_info
      fbdev: sh_mobile_lcdc: Store display mode in a struct fb_videomode
      fbdev: sh_mobile_lcdc: Rename (lcd|num)_cfg (lcd|num)_modes
      fbdev: sh_mobile_lcdc: Reorganize the sh_mobile_lcdc_chan structure
      fbdev: sh_mobile_lcdc: Add sh_mobile_format_info() function
      fbdev: sh_mobile_lcdc: Store the format in struct sh_mobile_lcdc_chan
      fbdev: sh_mobile_lcdc: Split fb init/cleanup from channel init/cleanup
      fbdev: sh_mobile_lcdc: Pass physical device pointer to DMA functions
      fbdev: sh_mobile_lcdc: Store configuration in channel structure
      fbdev: sh_mobile_lcdc: Pass channel pointer to sh_mobile_wait_for_vsync
      arm: mach-shmobile: Split MERAM resources into regs and meram
      fbdev: sh_mobile_meram: Request memory regions for memory resources
      fbdev: sh_mobile_meram: Add _cfg suffix to struct sh_mobile_meram_icb
      fbdev: sh_mobile_meram: Make variables unsigned where applicable
      fbdev: sh_mobile_meram: Make current_reg field store the current reg set
      fbdev: sh_mobile_meram: Add struct sh_mobile_meram_icb
      fbdev: sh_mobile_meram: Don't inline everything
      fbdev: sh_mobile_meram: Divide the code into sections
      fbdev: sh_mobile_meram: Use genalloc to manage MERAM allocation
      fbdev: sh_mobile_meram: Allocate ICBs automatically
      arm: mach-shmobile: Don't set MERAM ICB numbers in platform data
      fbdev: sh_mobile_meram: Remove unused sh_mobile_meram_icb_cfg fields
      fbdev: sh_mobile_lcdc: Don't store copy of platform data
      arm: mach-shmobile: Constify sh_mobile_meram_cfg structures
      fbdev: sh_mobile_meram: Don't perform update in register operation
      fbdev: sh_mobile_meram: Remove unneeded sanity checks
      fbdev: sh_mobile_meram: Implement system suspend/resume

Manjunathappa, Prakash (3):
      video: da8xx-fb: reset LCDC only if functional clock changes with DVFS
      video: da8xx-fb: Fix build warning on unused label
      video:da8xx-fb: calculate pixel clock period for the panel

Mark Brown (1):
      video: s3c-fb: Convert to devm style allocation

Martin Decky (1):
      udlfb: Improve debugging printouts with refresh rate

Mythri P K (6):
      OMAPDSS: HDMI: remove duplicate video interface code
      OMAPDSS: HDMI: update static timing table
      OMAPDSS: HDMI: change the timing match logic
      OMAPDSS: HDMI: remove duplicate code and mode parameter
      OMAPDSS: HDMI: Move Avi-infoframe struct to hdmi_ip_data
      OMAPDSS: HDMI: Add M2 divider while calculating clkout

Olivier Sobrie (1):
      udlfb: Fix invalid return codes in edid sysfs entry store function

Ondrej Zary (1):
      Resurrect Intel740 driver: i740fb

Peter Korsgaard (1):
      atmel_lcdfb: support 16bit BGR:565 mode, remove unsupported 15bit modes

Philipp Zabel (1):
      video: pxafb: add clk_prepare/clk_unprepare calls

Ricardo Neri (4):
      OMAPDSS: HDMI: Correct source of the pixel clock in ACR calculation
      OMAPDSS: Add DSS feature for HDMI MCLK for audio
      OMAPDSS: HDMI: Implement initialization of MCLK
      OMAPDSS: HDMI: Modify logic to configure MCLK

Tomi Valkeinen (30):
      OMAPDSS: FEAT: Add FIFO_MERGE feature
      OMAPDSS: APPLY: add fifo merge support funcs
      OMAPDSS: APPLY: add fifo-merge support
      OMAPDSS: DISPC: print fifo threshold values in bytes
      OMAPDSS: DISPC: move fifo threhold calc to dispc.c
      OMAPDSS: DISPC: Add naive threshold calc for fifomerge
      Merge branch 'work/fifomerge'
      Merge commit 'v3.3-rc4'
      OMAPDSS: cleanup probe functions
      OMAPFB: remove old blizzard driver
      OMAPFB: Remove OMAP2/3 support from old omapfb driver
      OMAPDSS: Remove video SRAM support
      OMAPFB: Remove video SRAM support (old omapfb)
      OMAP2+: remove unneeded #include omapfb.h
      OMAP: N770: remove HWA742 platform data
      OAMPFB: remove unused omapfb_set_ctrl_platform_data()
      OMAPFB: remove early mem alloc from old omapfb
      OMAPFB: remove mem info from platform_data
      OMAPFB: remove unused fb_format_to_dss_mode()
      OMAPFB: Move old omapfb private structs to a private include file
      OMAPFB: remove omapfb_set_platform_data()
      OMAP1: pass LCD config with omapfb_set_lcd_config()
      OMAP: Remove OMAP_TAG_LCD and OMAP_TAG_FBMEM
      OMAP1: Remove unused LCD devices from board files
      OMAPFB: remove remaining OMAP arch checks
      Merge branch 'work/old-omapfb-removal'
      Merge commit 'v3.3-rc6'
      OMAPDSS: APPLY: print warning if wait_pending_extra_info_updates fails
      OMAPDSS: APPLY: fix clearing shadow dirty flag with manual update
      OMAPDSS: register dss drivers in module init

Tony Lindgren (1):
      ARM: OMAP2+: Fix compile error when FB_OMAP2 is not set

Vasily Khoruzhick (1):
      pxafb: do console locking before calling fb_blank()

Wang YanQing (2):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page
      video:uvesafb: notice user when we failed to save hardware state

Yegor Yefremov (1):
      OMAPDSS: add Innolux AT080TN52 display support

 MAINTAINERS                                        |   33 +-
 arch/arm/mach-omap1/board-ams-delta.c              |    9 +-
 arch/arm/mach-omap1/board-fsample.c                |   15 +-
 arch/arm/mach-omap1/board-h2.c                     |   15 +-
 arch/arm/mach-omap1/board-h3.c                     |    9 +-
 arch/arm/mach-omap1/board-htcherald.c              |    9 +-
 arch/arm/mach-omap1/board-innovator.c              |   11 +-
 arch/arm/mach-omap1/board-nokia770.c               |   19 +-
 arch/arm/mach-omap1/board-osk.c                    |   14 +-
 arch/arm/mach-omap1/board-palmte.c                 |   10 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   10 +-
 arch/arm/mach-omap1/board-palmz71.c                |   10 +-
 arch/arm/mach-omap1/board-perseus2.c               |   15 +-
 arch/arm/mach-omap1/board-sx1.c                    |   16 +-
 arch/arm/mach-omap2/io.c                           |    1 -
 arch/arm/mach-shmobile/board-ag5evm.c              |   24 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |  302 ++--
 arch/arm/mach-shmobile/board-bonito.c              |    6 +-
 arch/arm/mach-shmobile/board-mackerel.c            |  106 +-
 arch/arm/plat-omap/common.c                        |    2 -
 arch/arm/plat-omap/fb.c                            |  334 +----
 arch/arm/plat-omap/fb.h                            |   10 -
 arch/arm/plat-omap/include/plat/blizzard.h         |   12 -
 arch/arm/plat-omap/include/plat/board.h            |    2 -
 arch/arm/plat-omap/include/plat/hwa742.h           |    8 -
 arch/arm/plat-omap/include/plat/vram.h             |   21 +-
 arch/arm/plat-samsung/include/plat/regs-fb.h       |   33 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   22 +-
 arch/sh/boards/mach-ecovec24/setup.c               |   20 +-
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c            |   10 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |    8 +-
 arch/sh/boards/mach-migor/lcd_qvga.c               |    3 +-
 arch/sh/boards/mach-migor/setup.c                  |   16 +-
 arch/sh/boards/mach-se/7724/setup.c                |   12 +-
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h        |   16 +-
 arch/sh/include/mach-migor/mach/migor.h            |    2 +-
 drivers/video/Kconfig                              |   39 +-
 drivers/video/Makefile                             |    3 +
 drivers/video/atmel_lcdfb.c                        |   12 +-
 drivers/video/au1100fb.c                           |   32 +-
 drivers/video/au1200fb.c                           |    9 +-
 drivers/video/bf537-lq035.c                        |   12 +-
 drivers/video/bf54x-lq043fb.c                      |    4 +-
 drivers/video/bfin-lq035q1-fb.c                    |    8 +-
 drivers/video/bfin_adv7393fb.c                     |    7 +-
 drivers/video/da8xx-fb.c                           |   79 +-
 drivers/video/exynos/Kconfig                       |   37 +
 drivers/video/exynos/Makefile                      |    8 +
 drivers/video/exynos/exynos_dp_core.c              | 1058 +++++++++++++
 drivers/video/exynos/exynos_dp_core.h              |  206 +++
 drivers/video/exynos/exynos_dp_reg.c               | 1173 ++++++++++++++
 drivers/video/exynos/exynos_dp_reg.h               |  335 ++++
 drivers/video/exynos/exynos_mipi_dsi.c             |  600 +++++++
 drivers/video/exynos/exynos_mipi_dsi_common.c      |  896 +++++++++++
 drivers/video/exynos/exynos_mipi_dsi_common.h      |   46 +
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |  618 ++++++++
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.h    |  112 ++
 drivers/video/exynos/exynos_mipi_dsi_regs.h        |  149 ++
 drivers/video/exynos/s6e8ax0.c                     |  898 +++++++++++
 drivers/video/exynos/s6e8ax0.h                     |   21 +
 drivers/video/fbmem.c                              |   18 +-
 drivers/video/i740_reg.h                           |  309 ++++
 drivers/video/i740fb.c                             | 1337 ++++++++++++++++
 drivers/video/msm/mddi_client_nt35399.c            |    7 +-
 drivers/video/msm/mddi_client_toshiba.c            |    7 +-
 drivers/video/omap/Kconfig                         |   16 +-
 drivers/video/omap/Makefile                        |   12 +-
 drivers/video/omap/blizzard.c                      | 1648 --------------------
 drivers/video/omap/dispc.c                         | 1547 ------------------
 drivers/video/omap/dispc.h                         |   46 -
 drivers/video/omap/hwa742.c                        |   21 +-
 drivers/video/omap/lcd_inn1610.c                   |   10 +-
 drivers/video/omap/lcd_mipid.c                     |   14 +-
 drivers/video/omap/omapfb.h                        |   25 +-
 drivers/video/omap/omapfb_main.c                   |   30 +-
 drivers/video/omap/rfbi.c                          |  598 -------
 drivers/video/omap2/displays/panel-acx565akm.c     |   13 +-
 drivers/video/omap2/displays/panel-generic-dpi.c   |   23 +
 .../omap2/displays/panel-lgphilips-lb035q02.c      |   12 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   12 +-
 drivers/video/omap2/displays/panel-taal.c          |    4 +-
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |  177 ++-
 drivers/video/omap2/dss/apply.c                    |  275 +++-
 drivers/video/omap2/dss/core.c                     |  135 +-
 drivers/video/omap2/dss/dispc.c                    |  121 +-
 drivers/video/omap2/dss/dispc_coefs.c              |    9 +-
 drivers/video/omap2/dss/display.c                  |   10 -
 drivers/video/omap2/dss/dsi.c                      |   65 +-
 drivers/video/omap2/dss/dss.c                      |   17 +-
 drivers/video/omap2/dss/dss.h                      |   10 +-
 drivers/video/omap2/dss/dss_features.c             |  181 ++-
 drivers/video/omap2/dss/dss_features.h             |   54 +-
 drivers/video/omap2/dss/hdmi.c                     |  278 ++--
 drivers/video/omap2/dss/manager.c                  |   12 +-
 drivers/video/omap2/dss/rfbi.c                     |   36 +-
 drivers/video/omap2/dss/ti_hdmi.h                  |   56 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          |   94 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.h          |   47 -
 drivers/video/omap2/dss/venc.c                     |   32 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  101 +--
 drivers/video/omap2/vram.c                         |   99 +--
 drivers/video/pvr2fb.c                             |    4 +-
 drivers/video/pxa168fb.c                           |   15 +-
 drivers/video/pxafb.c                              |   10 +-
 drivers/video/riva/fbdev.c                         |    5 +-
 drivers/video/s3c-fb.c                             |  133 ++-
 drivers/video/sh_mipi_dsi.c                        |   99 +-
 drivers/video/sh_mobile_hdmi.c                     |  297 +---
 drivers/video/sh_mobile_lcdcfb.c                   | 1298 +++++++++-------
 drivers/video/sh_mobile_lcdcfb.h                   |   84 +-
 drivers/video/sh_mobile_meram.c                    |  690 +++++----
 drivers/video/udlfb.c                              |  180 ++-
 drivers/video/uvesafb.c                            |   14 +-
 drivers/video/via/Makefile                         |    5 +-
 drivers/video/via/chip.h                           |    3 -
 drivers/video/via/dvi.c                            |    7 +-
 drivers/video/via/dvi.h                            |    3 +-
 drivers/video/via/hw.c                             |  130 +-
 drivers/video/via/hw.h                             |    9 +-
 drivers/video/via/lcd.c                            |   82 +-
 drivers/video/via/lcd.h                            |    3 +-
 drivers/video/via/share.h                          |  331 ----
 drivers/video/via/via_aux.c                        |   88 ++
 drivers/video/via/via_aux.h                        |   93 ++
 drivers/video/via/via_aux_ch7301.c                 |   50 +
 drivers/video/via/via_aux_edid.c                   |  100 ++
 drivers/video/via/via_aux_sii164.c                 |   54 +
 drivers/video/via/via_aux_vt1621.c                 |   44 +
 drivers/video/via/via_aux_vt1622.c                 |   50 +
 drivers/video/via/via_aux_vt1625.c                 |   50 +
 drivers/video/via/via_aux_vt1631.c                 |   46 +
 drivers/video/via/via_aux_vt1632.c                 |   54 +
 drivers/video/via/via_aux_vt1636.c                 |   46 +
 drivers/video/via/via_i2c.c                        |   10 +-
 drivers/video/via/viafbdev.c                       |   87 +-
 drivers/video/via/viafbdev.h                       |    6 +
 drivers/video/via/viamode.c                        |  713 ++--------
 drivers/video/via/viamode.h                        |   11 +-
 include/linux/fb.h                                 |    1 +
 include/linux/omapfb.h                             |   32 +-
 include/video/exynos_dp.h                          |  131 ++
 include/video/exynos_mipi_dsim.h                   |  359 +++++
 include/video/sh_mipi_dsi.h                        |    1 +
 include/video/sh_mobile_hdmi.h                     |    2 -
 include/video/sh_mobile_lcdc.h                     |   35 +-
 include/video/sh_mobile_meram.h                    |   45 +-
 include/video/udlfb.h                              |    1 +
 148 files changed, 12349 insertions(+), 8209 deletions(-)
 delete mode 100644 arch/arm/plat-omap/fb.h
 delete mode 100644 arch/arm/plat-omap/include/plat/blizzard.h
 delete mode 100644 arch/arm/plat-omap/include/plat/hwa742.h
 create mode 100644 drivers/video/exynos/Kconfig
 create mode 100644 drivers/video/exynos/Makefile
 create mode 100644 drivers/video/exynos/exynos_dp_core.c
 create mode 100644 drivers/video/exynos/exynos_dp_core.h
 create mode 100644 drivers/video/exynos/exynos_dp_reg.c
 create mode 100644 drivers/video/exynos/exynos_dp_reg.h
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi.c
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi_common.c
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi_common.h
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi_lowlevel.h
 create mode 100644 drivers/video/exynos/exynos_mipi_dsi_regs.h
 create mode 100644 drivers/video/exynos/s6e8ax0.c
 create mode 100644 drivers/video/exynos/s6e8ax0.h
 create mode 100644 drivers/video/i740_reg.h
 create mode 100644 drivers/video/i740fb.c
 delete mode 100644 drivers/video/omap/blizzard.c
 delete mode 100644 drivers/video/omap/dispc.c
 delete mode 100644 drivers/video/omap/dispc.h
 delete mode 100644 drivers/video/omap/rfbi.c
 create mode 100644 drivers/video/via/via_aux.c
 create mode 100644 drivers/video/via/via_aux.h
 create mode 100644 drivers/video/via/via_aux_ch7301.c
 create mode 100644 drivers/video/via/via_aux_edid.c
 create mode 100644 drivers/video/via/via_aux_sii164.c
 create mode 100644 drivers/video/via/via_aux_vt1621.c
 create mode 100644 drivers/video/via/via_aux_vt1622.c
 create mode 100644 drivers/video/via/via_aux_vt1625.c
 create mode 100644 drivers/video/via/via_aux_vt1631.c
 create mode 100644 drivers/video/via/via_aux_vt1632.c
 create mode 100644 drivers/video/via/via_aux_vt1636.c
 create mode 100644 include/video/exynos_dp.h
 create mode 100644 include/video/exynos_mipi_dsim.h
