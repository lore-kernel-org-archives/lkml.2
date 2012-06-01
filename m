Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2FAADM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:03:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42878 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758699Ab2FAADK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:03:10 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18urg86y/ouPpkLWDl43wLIPtGo0O+WGlTvBm5Ld0
	JgPNTTHfdQk3vi
Message-ID: <4FC806AE.8090804@gmx.de>
Date: Fri, 01 Jun 2012 00:02:54 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev updates for 3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the changes below.


Thanks,

Florian Tobias Schandinat


The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-updates-for-3.5

for you to fetch changes up to c895305e806b4346006d3cfba2b432d52268ecd3:

  video: bfin_adv7393fb: Fix cleanup code (2012-05-29 13:16:45 +0000)

----------------------------------------------------------------
fbdev updates for 3.5

It includes:
- driver for AUO-K1900 and AUO-K1901 epaper controller
- large updates for OMAP (e.g. decouple HDMI audio and video)
- some updates for Exynos and SH Mobile
- various other small fixes and cleanups

----------------------------------------------------------------
Alexander Guy (1):
      skeletonfb: fixed module exit function typo.

Archit Taneja (19):
      OMAPDSS: DISPC/RFBI: Use dispc_mgr_set_lcd_timings() for setting lcd size
      OMAPDSS: DISPC: Use a common function to set manager timings
      OMAPDSS: DISPC: Clean up manager timing/size functions
      OMAPDSS: HDMI: Fix ti_hdmi_4xxx_core_dump
      OMAPDSS: HDMI: define and dump CORE registers in correct order
      OMAPDSS: Fix DSI_FCLK clock source selection
      OMAPDSS: DISPC: Remove Fake VSYNC support
      OMAPDSS: APPLY: Add manager timings as extra_info in private data
      OMAPDSS: Apply manager timings instead of direct DISPC writes
      OMAPDSS: MANAGER: Create a function to check manager timings
      OMAPDSS: APPLY: Don't check manager settings if it is disabled
      OMAPDSS: APPLY: Remove display dependency from overlay and manager checks
      OMAPDSS: DPI/HDMI: Apply manager timings even if panel is disabled
      OMAPDSS: APPLY: Remove an unnecessary omap_dss_device pointer
      OMAPDSS: DISPC: Remove omap_dss_device pointer usage from dispc_mgr_pclk_rate()
      OMAPDSS: DISPC: Remove usage of dispc_mgr_get_device()
      OMAPDSS: DSI: Support command mode interleaving during video mode blanking periods
      OMAPDSS: VENC/DISPC: Delay dividing Y resolution for managers connected to VENC
      OMAPDSS: Apply VENC timings even if panel is disabled

Axel Castaneda Gonzalez (1):
      OMAPDSS: HDMI: Decouple wrapper enable/disable and audio start/stop

Axel Lin (1):
      video: pxa3xx-gcu: Simplify the logic to exit while loop in pxa3xx_gcu_wait_idle

Chandrabhanu Mahapatra (5):
      OMAPDSS: DISPC: Enable predecimation
      OMAPDSS: DISPC: Handle synclost errors in OMAP3
      OMAPDSS: DISPC: Correct DISPC functional clock usage
      OMAPDSS: DISPC: Update Accumulator configuration for chroma plane
      OMAPDSS: DISPC: Support rotation through TILER

Dan Carpenter (1):
      fb: handle NULL pointers in framebuffer release

David Brown (1):
      video: msm: Fix section mismatches in mddi.c

Donghwa Lee (3):
      video: EXYNOS: enable interrupt again after sw reset
      video: EXYNOS: changes mipi dsi regulator name from vdd10 to vdd11
      video: exynos mipi dsi: support reverse panel type

Emil Goode (1):
      video: bfin_adv7393fb: Fix cleanup code

Florian Tobias Schandinat (2):
      Merge branch 'fixes' of git://linuxtv.org/pinchartl/fbdev into fbdev-next
      Merge tag 'omapdss-for-3.5' of git://github.com/tomba/linux into fbdev-next

Grazvydas Ignotas (5):
      OMAPDSS: OMAPFB: check for matching memory size early
      OMAPDSS: provide default get_timings function for panels
      OMAPDSS: TPO-TD03MTEA1: add set/check timing functions
      OMAPDSS: VENC: allow switching venc output type at runtime
      OMAPDSS: OMAPFB: always allow to configure overlay

H Hartley Sweeten (4):
      video: smscufx.c: local functions should not be exposed globally
      video: fb_defio.c: local functions should not be exposed globally
      video: mb862xx-i2c: local functions should not be exposed globally
      video: mb862xxfbdrv.c: local functions should not be exposed globally

Heiko Stübner (4):
      fb_defio: add first_io callback
      video: auo_k190x: add code shared by controller drivers
      video: auo_k190x: add driver for AUO-K1900 variant
      video: auo_k190x: add driver for AUO-K1901 variant

Jan Weitzel (1):
      ARM: OMAP2+ Add Primview displays to panel-generic

Jingoo Han (10):
      video: s3c-fb: add runtime_get/put to suspend/resume
      video: exynos_dp: check DP PLL Lock status
      video: exynos_dp: replace char pointer with char array for adjust_request variable
      video: exynos_dp: add analog and pll control setting
      video: exynos_dp: fix max loop count in EQ sequence of link training
      video: exynos_dp: remove unnecessary header includes
      video: s3c-fb: use pr_debug instead of printk
      video: exynos_dp: use devm_ functions
      video: exynos_dp: move sw reset prioir to enabling sw defined function
      video: exynos_dp: reduce delay time when configuring video setting

Julia Lawall (3):
      drivers/video/ep93xx-fb.c: clean up error-handling code
      drivers/video/mbx/mbxfb.c: correct ioremap_nocache test
      drivers/video/intelfb/intelfbdrv.c: add missing agp_backend_release

Kuninori Morimoto (4):
      fbdev: sh_mobile_hdmi: add hdmi_bit_set() function
      fbdev: sh_mobile_hdmi: add interrupt output option
      fbdev: sh_mobile_hdmi: 32bit register access support
      fbdev: sh_mobile_hdmi: add HDMI Control Register support

Laurent Pinchart (1):
      fb: exynos: Fix MIPI/DSI front/back porch settings

Marek Vasut (1):
      i.MX28: Shut down the LCD controller to avoid BootROM sampling bug

Mark Brown (5):
      OMAP: DSS2: Remove suspicous and unused TAAL regulator API usage
      OMAPDSS: VENC: Check for errors from regulator_enable()
      OMAPDSS: TPO-TD03MTEA1: Check for errors from regulator_enable()
      OMAPDSS: TPO-TD03MTEA1: Correct comment for power on delay
      video: s3c-fb: s3c_fb_missing_pixclock() can't be __devinit

Peter Huewe (3):
      video/sis: Remove unused structs SiS_SDRDRAM_TYPE/SiS_DDRDRAM_TYPE/SiS_DRAMType
      video/sis: Annotate SiS_DRAMType as __devinitconst
      video/via: Convert to kstrtou8_from_user

Peter Meerwald (1):
      OMAPFB: remove unused FB_OMAP_BOOTLOADER_INIT config option

Ricardo Neri (15):
      OMAPDSS: Provide an interface for audio support
      OMAPDSS: HDMI: Split audio_enable into audio_enable/disable
      OMAPDSS: HDMI: Split video_enable into video_enable/disable
      OMAPDSS: HDMI: Remove ASoC codec
      OMAPDSS: HDMI: OMAP4: Remove CEA-861 audio infoframe and IEC-60958 enums
      OMAPDSS: HDMI: OMAP4: Remove invalid I2S settings
      OMAPDSS: HDMI: Decouple HDMI audio from ASoC
      OMAPDSS: HDMI: OMAP4: Expand configuration for IEC-60958 audio
      OMAPDSS: HDMI: Relocate N/CTS calculation
      OMAPDSS: HDMI: Add support for more audio sample rates in N/CTS calculation
      OMAPDSS: HDMI: Add an audio configuration function
      OMAPDSS: HDMI: OMAP4: Remap speaker order to match ALSA order
      OMAPDSS: HDMI: Panel: Simplify the name of the HDMI mutex
      OMAPDSS: HDMI: Implement DSS driver interface for audio
      OMAPDSS: HDMI: OMAP4: Update IRQ flags for the HPD IRQ request

Russ Dill (1):
      OMAPDSS: TFP410: use gpio_set_value_cansleep

Steven J. Hill (1):
      cobalt_lcdfb: LCD panel framebuffer support for SEAD-3 platform.

Sylwester Nawrocki (3):
      video: exynos mipi dsi: Do not use deprecated suspend/resume callbacks
      video: exynos mipi dsi: Avoid races in probe()
      video: exynos mipi dsi: Properly interpret the interrupt source flags

Thomas Abraham (4):
      video: s3c-fb: move video interface timing out of window setup data
      video: s3c-fb: remove 'default_win' element from platform data
      ARM: s3c64xx: Decouple lcd type from display controller window data
      ARM: Samsung: Rework platform data of s3c-fb driver

Thomas Weber (2):
      OMAPDSS: Add Mitsubishi AA084SB01 display support
      OMAPDSS: Add EDT ET0500G0DH6 display support

Timur Tabi (1):
      drivers/video: fsl-diu-fb: don't initialize the THRESHOLDS registers

Tomi Valkeinen (38):
      OMAPDSS: add set_min_bus_tput pointer to omapdss's platform data
      OMAPDSS: Ensure OPP100 when DSS is operational
      OMAPDSS: DSI: remove option to use pck for DSI PLL clkin
      OMAPDSS: panel-dvi: add PD gpio handling
      OMAP: board-files: remove custom PD GPIO handling for DVI output
      OMAPDSS: TFP410: rename dvi -> tfp410
      OMAPDSS: TFP410: rename dvi files to tfp410
      OMAPDSS: Taal: move reset gpio handling to taal driver
      OMAPDSS: DSI: implement generic DSI pin config
      Merge branch 'archit/set-timing-work'
      Merge branch 'for-l-o-3.5'
      OMAPFB: fix parsing of vram parameter
      OMAPDSS: TFP410: pdata rewrite
      OMAPDSS: DSI: use dsi_get_dsidev_id(dsidev) instead of dsidev->id
      OMAPDSS: clean up the omapdss platform data mess
      OMAPDSS: remove return from platform_driver_unreg
      OMAPDSS: use platform_driver_probe for core/dispc/dss
      OMAPDSS: create custom pdevs for DSS omap_devices
      OMAPDSS: create DPI & SDI devices
      OMAPDSS: create DPI & SDI drivers
      OMAPDSS: remove uses of dss_runtime_get/put
      OMAPDSS: handle output-driver reg/unreg more dynamically
      OMAPDSS: move the creation of debugfs files
      OMAPDSS: use platform_driver_probe for dsi/hdmi/rfbi/venc/dpi/sdi
      OMAPDSS: add __init & __exit
      OMAPFB: add __init & __exit
      OMAPDSS: change default_device handling
      OMAPDSS: interface drivers register their panel devices
      OMAPDSS: init omap_dss_devices internally
      OMAPDSS: DSI: improve DSI module id handling
      OMAPDSS: separate pdata based initialization
      Merge branch 'dss-devtree-cleanup'
      Merge branch 'omapdss-hdmi-audio'
      OMAPDSS: use DSI_FIFO_BUG workaround only for manual update displays
      OMAPDSS: DISPC: fix usage of dispc_ovl_set_accu_uv
      OMAPDSS: remove compiler warnings when CONFIG_BUG=n
      OMAPFB: remove compiler warnings when CONFIG_BUG=n
      OMAPDSS: VRFB: remove compiler warnings when CONFIG_BUG=n

 Documentation/arm/OMAP/DSS                         |   46 +
 arch/arm/mach-exynos/mach-nuri.c                   |   26 +-
 arch/arm/mach-exynos/mach-origen.c                 |   24 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   28 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   26 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   38 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   37 +-
 arch/arm/mach-omap2/board-am3517evm.c              |   25 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   30 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   30 +-
 arch/arm/mach-omap2/board-igep0020.c               |   32 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   37 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   29 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   29 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   39 +-
 arch/arm/mach-omap2/board-overo.c                  |   25 +-
 arch/arm/mach-omap2/display.c                      |  196 ++++-
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   27 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   25 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   25 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   24 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   92 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |   90 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   26 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   26 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   25 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   24 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   24 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   27 +-
 arch/arm/mach-s5pv210/mach-aquila.c                |   36 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   26 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   24 +-
 arch/arm/plat-samsung/include/plat/fb.h            |   11 +-
 drivers/video/Kconfig                              |   35 +-
 drivers/video/Makefile                             |    3 +
 drivers/video/auo_k1900fb.c                        |  198 ++++
 drivers/video/auo_k1901fb.c                        |  251 +++++
 drivers/video/auo_k190x.c                          | 1046 ++++++++++++++++++++
 drivers/video/auo_k190x.h                          |  129 +++
 drivers/video/bfin_adv7393fb.c                     |   43 +-
 drivers/video/cobalt_lcdfb.c                       |   45 +-
 drivers/video/ep93xx-fb.c                          |   32 +-
 drivers/video/exynos/exynos_dp_core.c              |   69 +-
 drivers/video/exynos/exynos_dp_core.h              |    3 +-
 drivers/video/exynos/exynos_dp_reg.c               |   45 +-
 drivers/video/exynos/exynos_dp_reg.h               |   29 +
 drivers/video/exynos/exynos_mipi_dsi.c             |   49 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |   36 +-
 drivers/video/exynos/s6e8ax0.c                     |   15 +-
 drivers/video/fb_defio.c                           |    6 +-
 drivers/video/fbsysfs.c                            |    2 +
 drivers/video/fsl-diu-fb.c                         |    1 -
 drivers/video/intelfb/intelfbdrv.c                 |    2 +
 drivers/video/mb862xx/mb862xx-i2c.c                |    2 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |    2 +-
 drivers/video/mbx/mbxfb.c                          |    2 +-
 drivers/video/mxsfb.c                              |   13 +
 drivers/video/omap/Kconfig                         |    8 -
 drivers/video/omap2/displays/Kconfig               |    8 +-
 drivers/video/omap2/displays/Makefile              |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    7 -
 drivers/video/omap2/displays/panel-generic-dpi.c   |  107 ++-
 drivers/video/omap2/displays/panel-n8x0.c          |    8 -
 drivers/video/omap2/displays/panel-taal.c          |  108 +--
 .../omap2/displays/{panel-dvi.c => panel-tfp410.c} |  186 ++--
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   22 +-
 drivers/video/omap2/dss/Kconfig                    |   13 +-
 drivers/video/omap2/dss/apply.c                    |  134 ++-
 drivers/video/omap2/dss/core.c                     |  255 +++--
 drivers/video/omap2/dss/dispc.c                    |  747 ++++++++++----
 drivers/video/omap2/dss/dispc.h                    |   72 ++
 drivers/video/omap2/dss/display.c                  |   49 +-
 drivers/video/omap2/dss/dpi.c                      |   75 +-
 drivers/video/omap2/dss/dsi.c                      |  537 +++++++----
 drivers/video/omap2/dss/dss.c                      |   65 +-
 drivers/video/omap2/dss/dss.h                      |  151 +--
 drivers/video/omap2/dss/dss_features.c             |   30 +-
 drivers/video/omap2/dss/dss_features.h             |    5 +
 drivers/video/omap2/dss/hdmi.c                     |  443 ++++-----
 drivers/video/omap2/dss/hdmi_panel.c               |  236 ++++-
 drivers/video/omap2/dss/manager.c                  |   19 +-
 drivers/video/omap2/dss/overlay.c                  |   16 +-
 drivers/video/omap2/dss/rfbi.c                     |   84 ++-
 drivers/video/omap2/dss/sdi.c                      |   63 +-
 drivers/video/omap2/dss/ti_hdmi.h                  |   32 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          |  480 ++++++---
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.h          |  161 +---
 drivers/video/omap2/dss/venc.c                     |  133 ++-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |   17 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   12 +-
 drivers/video/omap2/omapfb/omapfb.h                |    1 +
 drivers/video/omap2/vrfb.c                         |    4 +-
 drivers/video/pxa3xx-gcu.c                         |    5 +-
 drivers/video/s3c-fb.c                             |  148 ++--
 drivers/video/sh_mobile_hdmi.c                     |  219 ++++-
 drivers/video/sis/init.h                           |   45 -
 drivers/video/sis/sis_main.c                       |   41 +-
 drivers/video/skeletonfb.c                         |    2 +-
 drivers/video/smscufx.c                            |    4 +-
 drivers/video/udlfb.c                              |    2 +-
 drivers/video/via/viafbdev.c                       |   34 +-
 include/linux/fb.h                                 |    1 +
 include/video/auo_k190xfb.h                        |  106 ++
 include/video/exynos_dp.h                          |    2 +-
 include/video/exynos_mipi_dsim.h                   |    1 +
 include/video/omap-panel-nokia-dsi.h               |    3 +
 .../{omap-panel-dvi.h => omap-panel-tfp410.h}      |   18 +-
 include/video/omapdss.h                            |   75 ++-
 include/video/sh_mobile_hdmi.h                     |   12 +-
 109 files changed, 5705 insertions(+), 2590 deletions(-)
 create mode 100644 drivers/video/auo_k1900fb.c
 create mode 100644 drivers/video/auo_k1901fb.c
 create mode 100644 drivers/video/auo_k190x.c
 create mode 100644 drivers/video/auo_k190x.h
 rename drivers/video/omap2/displays/{panel-dvi.c => panel-tfp410.c} (56%)
 create mode 100644 include/video/auo_k190xfb.h
 rename include/video/{omap-panel-dvi.h => omap-panel-tfp410.h} (63%)
