Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2LNKXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:23:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38374 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2LNKXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:23:03 -0500
Message-ID: <50CAFDFF.3070802@ti.com>
Date: Fri, 14 Dec 2012 12:22:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [GIT PULL] fbdev changes for 3.8
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3E7774B1810CD517C924C73E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3E7774B1810CD517C924C73E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Florian, the fbdev maintainer, has been very busy lately, so I offered to=
 send
the pull request for fbdev for this merge window.

There are a few conflicts, but they look clear to me.
arch/arm/plat-omap/common.c is to be removed.

 Tomi

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d=
17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/fbdev-for-3.8

for you to fetch changes up to e7f5c9a16ea2648a3e85af8e34191026bf3dcb62:

  Merge tag 'omapdss-for-3.8' of git://gitorious.org/linux-omap-dss2/linu=
x into for-linus (2012-12-13 14:30:56 +0200)

----------------------------------------------------------------

fbdev changes for 3.8:

OMAPDSS changes, including:
- use dynanic debug prints
- OMAP platform dependency removals
- Creation of compat-layer, helping us to improve omapdrm
- Misc cleanups, aiming to make omadss more in line with the upcoming com=
mon
  display framework

Exynos DP changes for the 3.8 merge window:
- Device Tree support for Samsung Exynos DP
- SW Link training is cleaned up.
- HPD interrupt is supported.

Samsung Framebuffer changes for the 3.8 merge window:
- The bit definitions of header file are updated.
- Some minor typos are fixed.
- Some minor bugs of s3c_fb_check_var() are fixed.

FB related changes for SH Mobile, Freescale DIU

Add support for the Solomon SSD1307 OLED Controller

----------------------------------------------------------------
Aaro Koskinen (1):
      OMAPDSS: panel-n8x0: register the DSS driver after SPI probe

Ajay Kumar (5):
      video: exynos_dp: Add device tree support to DP driver
      video: exynos_dp: device tree documentation
      video: exynos_dp: Reset and initialize DP before requesting irq
      video: exynos_dp: Fix incorrect setting for INT_CTL
      video: exynos_dp: remove redundant parameters

Archit Taneja (10):
      OMAPDSS: Remove acb and acbi fields from omap_dss_device
      OMAPDSS: DISPC: Fix calc_scaling_44xx() bugs for writeback pipeline=

      OMAPDSS: DISPC: Don't allow predecimation for writeback
      OMAPDSS: DISPC: Use output width and height to calculate row/pix in=
c for writeback
      OMAPDSS: APPLY: Don't treat an overlay's channel out as shadow bits=

      OMAPDSS: APPLY: Remove unnecessary variable in dss_apply_irq_handle=
r
      OMAPDSS: APPLY: Remove unnecessary call to mg_clear_shadow_dirty
      OMAPDSS: Add overlay manager width and height limits as a dispc fea=
ture
      OMAPDSS: Add a dispc_features struct for OMAP5
      OMAPDSS: Use only "omapdss_dss" platform device to get context lost=
 count

Axel Lin (1):
      OMAPDSS: Add terminating entry for picodlp_i2c_id table

Chandrabhanu Mahapatra (5):
      OMAPDSS: Move definition of DEBUG flag to Makefile
      OMAPDSS: Create new debug config options
      OMAPDSS: Cleanup DSSDBG with dynamic pr_debug function
      OMAPDSS: Replace multi part debug prints with pr_debug
      OMAPDSS: Remove dss_debug variable

Chuansheng Liu (2):
      OMAPDSS: DISPC: Fix the usage of wait_for_completion_timeout
      OMAPDSS: APPLY: Fix the usage of wait_for_completion_timeout

Hideki EIRAKU (1):
      fbdev: sh_mobile_lcdc: use dma_mmap_coherent

Jingoo Han (14):
      video: s3c-fb: clean the bit definition for WINCON register
      video: s3c-fb: move the address definitions for VIDTCON registers
      video: s3c-fb: move the address definition for VIDOSD register
      video: s3c-fb: move the bit definitions for VIDINTCON0 register
      video: s3c-fb: move the bit definitions for WINxMAP and WPALCON reg=
ister
      video: s3c-fb: move the bit definitions for DITHMODE register
      video: s3c-fb: add the bit definitions for VIDCON0_VIDOUT_WB
      video: s3c-fb: fix typo in comment
      video: s3c-fb: fix help message for FB_S3C_DEBUG_REGWRITE
      video: s3c-fb: use FIMD_V8_VIDTCON0 for EXYNOS5 FIMD
      video: s3c-fb: use dev_get_drvdata() instead of platform_get_drvdat=
a()
      video: s3c-fb: add "drop through" comment
      video: s3c-fb: return an error when bpp is invalid
      video: s3c-fb: fix red offset and length for ARGB232 format

Laurent Pinchart (19):
      fbdev: sh_mobile_lcdc: Get display dimensions from the channel stru=
cture
      fbdev: sh_mobile_lcdc: Rename mode argument to modes
      fbdev: sh_mobile_lcdc: Remove priv argument from channel and overla=
y init
      ARM: mach-shmobile: ag5evm: Add LCDC tx_dev field to platform data
      fbdev: sh_mipi_dsi: Add channel field to platform data
      ARM: mach-shmobile: Initiliaze the new sh_mipi_dsi_info channel fie=
ld
      fbdev: sh_mipi_dsi: Use the sh_mipi_dsi_info channel field
      fbdev: sh_mipi_dsi: Use the LCDC entity default mode
      fbdev: sh_mipi_dsi: Remove last reference to LCDC platform data
      ARM: mach-shmobile: Remove the unused sh_mipi_dsi_info lcd_chan fie=
ld
      fbdev: sh_mipi_dsi: Remove the unused sh_mipi_dsi_info lcd_chan fie=
ld
      fbdev: sh_mobile_lcdc: Store the backlight brightness internally
      ARM: mach-shmobile: mackerel: Removed unused get_brightness callbac=
k
      sh: ap325rxa: Remove unused get_brightness LCDC callback
      sh: ecovec24: Remove unused get_brightness LCDC callback
      fbdev: sh_mobile_lcdc: Remove unused get_brightness pdata callback
      ARM: mach-shmobile: ag5evm: Use the backlight API for brightness co=
ntrol
      sh: kfr2r09: Use the backlight API for brightness control
      fbdev: sh_mobile_lcdc: Make sh_mobile_lcdc_sys_bus_ops static

Manjunathappa (1):
      video: da8xx-fb: clk_get on connection id fck

Manjunathappa, Prakash (2):
      da8xx-fb: adopt fb_videomode data for panel information
      da8xx-fb: cleanup LCDC configurations

Matthias Brugger (1):
      OMAPFB: Delete if statement evaluating a constant.

Maxime Ripard (1):
      drivers/video: add support for the Solomon SSD1307 OLED Controller

Pantelis Antoniou (1):
      da8xx: Fix revision check on the da8xx driver

Peter Ujfalusi (1):
      OMAPDSS: Correct check for the callback pointer in dss_dsi_disable_=
pads()

Ricardo Neri (8):
      OMAPDSS: HDMI: Rename resource variable at probe.
      OMAPDSS: HDMI: Convert to devm_request_and_ioremap
      OMAPDSS: HDMI: Make panel return dssdev register errors
      OMAPDSS: HDMI: Handle panel init error at probe
      OMAPDSS: HDMI: Uninit display on device add error
      OMAPDSS: HDMI: Add op to get audio DMA port address offset
      OMAPDSS: HDMI: Create platform device for audio support
      OMAPDSS: HDMI: Remove __exit macro from hdmi_uninit_display

Sachin Kamat (1):
      drivers/video/console/softcursor.c: remove redundant NULL check bef=
ore kfree()

Sean Paul (8):
      video: exynos_dp: Check DPCD return codes
      video: exynos_dp: Clean up SW link training
      video: exynos_dp: Get pll lock before pattern set
      video: exynos_dp: Improve EDID error handling
      video: exynos_dp: Fix bug when checking dp->irq
      video: exynos_dp: Remove sink control to D0
      video: exynos_dp: Move hotplug into a workqueue
      video: exynos_dp: Enable hotplug interrupts

Timur Tabi (9):
      MAINTAINERS: Make Timur Tabi the maintainer for the Freescale DIU d=
river
      drivers/video: fsl-diu-fb: simplify platforms that have only one po=
rt
      drivers/video: fsl-diu-fb: add support for set_gamma ioctls
      drivers/video: fsl-diu-fb: streamline enabling of interrupts
      drivers/video: fsl-diu-fb: improve message displays
      drivers/video: fsl-diu-fb: remove unused 'cursor_reset' variable
      drivers/video: fsl-diu-fb: clean up reset of primary display
      drivers/video: fsl-diu-fb: don't touch registers for unused feature=
s
      drivers/video: fsl-diu-fb: store EDID data in the global object

Tomi Valkeinen (113):
      Merge tag 'v3.7-rc1'
      OMAPDSS: add missing sizes.h includes
      OMAPDSS: fix compilation warnings
      OMAPDSS: remove Kconfig dependencies
      Merge branch '3.8/dss-version'
      Merge branch '3.8/vrfb-conversion'
      OMAPDSS: DSI: fix dsi_get_dsidev_from_id()
      OMAPDSS: fix registering the vsync isr in apply
      OMAPDSS: DISPC: constify function parameters
      OMAPDSS: combine LCD related config into one func
      OMAPDSS: remove declarations for non-existing funcs
      OMAPDSS: DISPC: remove struct omap_overlay use
      OMAPDSS: DISPC: cleanup lcd and digit enable
      OMAPDSS: DISPC: add dispc_mgr_get_sync_lost_irq()
      OMAPDSS: DISPC: cleanup lcd/digit enable/disable
      OMAPDSS: remove omap_dss_device's suspend/resume
      OMAPDSS: get the dss version from core pdev
      OMAPDSS: remove dispc_irq_handler declaration
      OMAPDSS: DISPC: fix dispc_mgr_lclk_rate for DIGIT output
      OMAPDSS: export dss_get_def_display_name()
      OMAPDSS: remove initial display code from omapdss
      OMAPDSS: DISPC: use dss_feat_get_num_ovls()
      OMAPDSS: DISPC: rename dispc_mgr_enable/disable to _sync
      OMAPDSS: DISPC: make _enable_mgr_out public as "dispc_mgr_enable"
      OMAPDSS: add dispc_ovl_enabled()
      OMAPDSS: DISPC: Add IRQ enable/status helpers
      OMAPDSS: HDMI: split power_on/off to two parts
      OMAPDSS: HDMI: use core power on/off with edid & detect
      OMAPDSS: HDMI: add 1920x1200 video mode
      OMAPDSS: HDMI: make hdmi pclk check more permissive
      OMAPFB: remove use of extended edid block
      OMAPFB: improve mode selection from EDID
      OMAPDSS: fix DSI2 PLL clk names
      OMAPDSS: DISPC: fix loop in error handler
      OMAPDSS: DISPC: remove dssdev depependency from error handler
      OMAPDSS: split hdmi muxing function
      Merge branch '3.8/misc-2'
      OMAPDSS: fix DPI & DSI init order
      OMAPDSS: DSI: skip odd dividers when pck >=3D 100MHz
      OMAPDSS: DSI: workaround for HSDiv problem
      OMAPDSS: add dss_calc_clock_rates() back
      OMAPDSS: setup default dss fck
      OMAPDSS: hide dss_select_dispc_clk_source()
      OMAPDSS: DPI: use dpi.dsidev to see whether to use dsi pll
      OMAPDSS: DPI: verify if DSI PLL is operational
      OMAPDSS: DPI: always use DSI PLL if available
      Merge branch '3.8/dsi-pll-work'
      OMAPDSS: DISPC: fix DS variable name
      OMAPDSS: DISPC: fix sparse warning
      OMAPDSS: HACK: look for regulators with omap4 names
      OMAP: FB: use DMA_BIT_MASK() for fb's coherent_dma_mask
      OMAPFB: use dma_alloc_attrs to allocate memory
      OMAP: RX51: remove use of vram
      OMAP: common.c: remove init call to vram
      OMAP: remove vram allocator
      Revert "OMAPDSS: HDMI: Create platform device for audio support"
      Merge tag 'v3.7-rc4'
      Merge branch '3.8/vram-conversion' of git://gitorious.org/linux-oma=
p-dss2/linux
      OMAPFB: fix compilation error
      Merge tag 'omapdss-for-3.7-rc' of git://gitorious.org/linux-omap-ds=
s2/linux
      Merge branch 'lcdc-next' of git://linuxtv.org/pinchartl/fbdev into =
for-linus
      Merge branch 'fbdev-next' of github.com:timur-tabi/linux-2.6 into f=
or-linus
      OMAPDSS: remove declarations for non-existing functions
      OMAPDSS: DPI: fix crash with dpi_verify_dsi_pll()
      OMAPDSS: don't WARN if there's no DSI device
      OMAPDSS: DISPC: add no_framedone_tv feat
      OMAPDSS: DISPC: use get_framedone_irq in disable_digit_out
      OMAPDSS: DISPC: Remove blocking code from dispc_wb_enable()
      OMAPDSS: cleanup WB enable/is_enabled functions
      OMAPDSS: DISPC: use WARN_ON() in dispc_mgr_go
      OMAPDSS: DISPC: pclk & lclk rates for writeback
      OMAPDSS: DISPC: pass pclk to calc_core_clk()
      OMAPDSS: DISPC: pass pclk & lclk to check_horiz_timing_omap3
      OMAPDSS: DISPC: pass pclk & lclk to calc_scaling
      OMAPDSS: DISPC: pass pclk & lclk to dispc_ovl_calc_scaling
      OMAPDSS: create display-sysfs.c
      OMAPDSS: add dss_get_core_pdev()
      Merge branch 'samsung-fb-next' of git://github.com/jingoo/linux int=
o for-linus
      Merge branch 'exynos-dp-next' of git://github.com/jingoo/linux into=
 for-linus
      [media] omap_vout: use omapdss's version instead of cpu_is_*
      [media] omap_vout: remove extra include
      OMAPFB: remove exported udpate window
      OMAPFB: move dssdev->sync call out from omapfb_realloc_fbmem
      OMAPFB: simplify locking
      OMAPFB: remove warning when trying to alloc at certain paddress
      OMAPDSS: manage output-dssdev connection in output drivers
      OMAPFB: connect ovl managers to all dssdevs
      OMAPDSS: add omapdss_compat_init()
      OMAPDSS: move ovl & ovl-mgr init to apply.c
      OMAPDSS: move ovl-mgr function setup to apply.c
      OMAPDSS: move ovl function setup to apply.c
      OMAPDSS: add manager ops
      OMAPDSS: manage framedone irq with mgr ops
      OMAPDSS: move blocking mgr enable/disable to compat layer
      OMAPDSS: move omap_dispc_wait_for_irq_interruptible_timeout to disp=
c-compat.c
      OMAPDSS: move irq handling to dispc-compat
      OMAPDSS: DISPC: add dispc_ovl_check()
      OMAPDSS: DPI: use dispc's check_timings
      OMAPDSS: move display sysfs init to compat layer
      OMAPDSS: separate compat files in the Makefile
      OMAPDSS: export dss_mgr_ops functions
      OMAPDSS: export dss_feat functions
      OMAPDSS: export dispc functions
      OMAPDSS: use omapdss_compat_init() in other drivers
      Merge omapdss compat layer work
      OMAPDSS: DISPC: get dss clock rate from dss driver
      OMAPDSS: DISPC: remove dispc fck uses
      OMAPFB: use devm_kzalloc to allocate omapfb2_device
      OMAPFB: fix error handling in omapfb_find_best_mode()
      OMAPFB: remove silly loop in fb2display()
      Revert "OMAPFB: simplify locking"
      OMAPDSS: fix TV-out issue with DSI PLL
      Merge tag 'omapdss-for-3.8' of git://gitorious.org/linux-omap-dss2/=
linux into for-linus

Wei Yongjun (1):
      OMAPDSS: HDMI: fix missing unlock on error in hdmi_dump_regs()

 Documentation/arm/OMAP/DSS                         |   10 +-
 .../devicetree/bindings/video/exynos_dp.txt        |   80 ++
 .../devicetree/bindings/video/ssd1307fb.txt        |   24 +
 MAINTAINERS                                        |    6 +
 arch/arm/mach-davinci/da830.c                      |    2 +-
 arch/arm/mach-davinci/da850.c                      |    2 +-
 arch/arm/mach-davinci/devices-da8xx.c              |   22 +-
 arch/arm/mach-davinci/pm_domain.c                  |    1 +
 arch/arm/mach-omap2/board-rx51-video.c             |   14 -
 arch/arm/mach-omap2/board-rx51.c                   |    3 -
 arch/arm/mach-omap2/display.c                      |   53 +-
 arch/arm/mach-omap2/sdrc.c                         |   16 -
 arch/arm/mach-shmobile/board-ag5evm.c              |  198 ++--
 arch/arm/mach-shmobile/board-ap4evb.c              |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    6 -
 arch/arm/plat-omap/common.c                        |    2 -
 arch/arm/plat-omap/fb.c                            |   66 +-
 arch/arm/plat-omap/include/plat/sdrc.h             |    7 -
 arch/arm/plat-omap/include/plat/vram.h             |   43 -
 arch/sh/boards/mach-ap325rxa/setup.c               |    6 -
 arch/sh/boards/mach-ecovec24/setup.c               |    6 -
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c            |   16 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |    7 +-
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h        |    6 +-
 drivers/media/platform/omap/omap_vout.c            |   23 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |    2 +-
 drivers/media/platform/omap/omap_voutdef.h         |    2 +-
 drivers/media/platform/omap/omap_voutlib.c         |   38 +-
 drivers/media/platform/omap/omap_voutlib.h         |    3 +
 drivers/staging/omapdrm/omap_drv.c                 |   11 +
 drivers/video/Kconfig                              |   17 +-
 drivers/video/Makefile                             |    1 +
 drivers/video/console/softcursor.c                 |    3 +-
 drivers/video/da8xx-fb.c                           |  170 ++-
 drivers/video/exynos/exynos_dp_core.c              |  697 ++++++++-----
 drivers/video/exynos/exynos_dp_core.h              |   21 +-
 drivers/video/exynos/exynos_dp_reg.c               |   77 +-
 drivers/video/exynos/exynos_dp_reg.h               |    3 +-
 drivers/video/fsl-diu-fb.c                         |  201 ++--
 drivers/video/omap2/Kconfig                        |    3 -
 drivers/video/omap2/Makefile                       |    1 -
 drivers/video/omap2/displays/panel-acx565akm.c     |   23 -
 drivers/video/omap2/displays/panel-generic-dpi.c   |   36 -
 .../omap2/displays/panel-lgphilips-lb035q02.c      |   34 -
 drivers/video/omap2/displays/panel-n8x0.c          |   89 +-
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      |   24 -
 drivers/video/omap2/displays/panel-picodlp.c       |   45 +-
 .../video/omap2/displays/panel-sharp-ls037v7dw01.c |   17 -
 drivers/video/omap2/displays/panel-taal.c          |   72 --
 drivers/video/omap2/displays/panel-tfp410.c        |   33 -
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   20 -
 drivers/video/omap2/dss/Kconfig                    |   35 +-
 drivers/video/omap2/dss/Makefile                   |    7 +-
 drivers/video/omap2/dss/apply.c                    |  331 ++++--
 drivers/video/omap2/dss/core.c                     |   72 +-
 drivers/video/omap2/dss/dispc-compat.c             |  667 ++++++++++++
 drivers/video/omap2/dss/dispc-compat.h             |   30 +
 drivers/video/omap2/dss/dispc.c                    | 1102 ++++++--------=
------
 drivers/video/omap2/dss/display-sysfs.c            |  321 ++++++
 drivers/video/omap2/dss/display.c                  |  386 +------
 drivers/video/omap2/dss/dpi.c                      |  126 ++-
 drivers/video/omap2/dss/dsi.c                      |  247 +++--
 drivers/video/omap2/dss/dss.c                      |  138 ++-
 drivers/video/omap2/dss/dss.h                      |  124 +--
 drivers/video/omap2/dss/dss_features.c             |   79 +-
 drivers/video/omap2/dss/dss_features.h             |   12 +-
 drivers/video/omap2/dss/hdmi.c                     |  158 ++-
 drivers/video/omap2/dss/hdmi_panel.c               |   82 +-
 drivers/video/omap2/dss/manager.c                  |   39 -
 drivers/video/omap2/dss/output.c                   |   90 +-
 drivers/video/omap2/dss/overlay.c                  |   17 -
 drivers/video/omap2/dss/rfbi.c                     |   23 +-
 drivers/video/omap2/dss/sdi.c                      |   11 +-
 drivers/video/omap2/dss/ti_hdmi.h                  |    3 +
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          |   11 +-
 drivers/video/omap2/dss/venc.c                     |   11 +-
 drivers/video/omap2/dss/venc_panel.c               |   19 -
 drivers/video/omap2/omapfb/Kconfig                 |    1 -
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |   48 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |  212 ++--
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |    6 +-
 drivers/video/omap2/omapfb/omapfb.h                |   20 +-
 drivers/video/omap2/vram.c                         |  514 ---------
 drivers/video/omap2/vrfb.c                         |  142 ++-
 drivers/video/s3c-fb.c                             |   24 +-
 drivers/video/sh_mipi_dsi.c                        |   69 +-
 drivers/video/sh_mobile_lcdcfb.c                   |   74 +-
 drivers/video/sh_mobile_lcdcfb.h                   |    1 +
 drivers/video/ssd1307fb.c                          |  396 +++++++
 include/linux/fsl-diu-fb.h                         |    9 +
 include/video/da8xx-fb.h                           |   25 +-
 include/video/omapdss.h                            |  105 +-
 .../plat/vrfb.h =3D> include/video/omapvrfb.h        |    2 +
 include/video/samsung_fimd.h                       |  168 +--
 include/video/sh_mipi_dsi.h                        |    4 +-
 include/video/sh_mobile_lcdc.h                     |    1 -
 96 files changed, 4355 insertions(+), 3873 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/exynos_dp.txt=

 create mode 100644 Documentation/devicetree/bindings/video/ssd1307fb.txt=

 delete mode 100644 arch/arm/plat-omap/include/plat/vram.h
 create mode 100644 drivers/video/omap2/dss/dispc-compat.c
 create mode 100644 drivers/video/omap2/dss/dispc-compat.h
 create mode 100644 drivers/video/omap2/dss/display-sysfs.c
 delete mode 100644 drivers/video/omap2/vram.c
 create mode 100644 drivers/video/ssd1307fb.c
 rename arch/arm/plat-omap/include/plat/vrfb.h =3D> include/video/omapvrf=
b.h (95%)



--------------enig3E7774B1810CD517C924C73E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQyv4AAAoJEPo9qoy8lh71v44P/1CKnQ5X8MPqZhQa6ebIuONi
Raa/2SX5zKG3a53Fn3WdKQ1ABzPDgwNyvjZaxLYvUL9tGq2MwAw41jVpYEwT380R
2F2mAGnHQGYO1HvVzZo8qdrf2upPecwYrYKftsBFoeDhgUIOZDVFyz8ANWYc4LzY
PAakMrvwHJzDkLEeIFvjOGbQD4VasrA4qvSg2UIeGZAyh+24g+OxYY1on8hJIP+T
yaW9z8mYr6siG9qQScIW6HhJdS0Q46mcyQ5L5cAOlOnFcNFox1GU3fGsxQbtj94F
zGCjuhkXAb6wzzL7e0xKlW9Kt5ECDttrySxkVS2OZPJ1i3GhNqbcyV0ybwk6tuzM
BmfdN9BKs/omgHcPlx6DPE89DsaS7gXSEt5kWJe/QBDVFpDJuCYskk964Om93BqW
Ezbg9a8xG5meB2HZNILsGQcgmvoixneYllNZh34kSWuuQLe1LeoT398iuoRI9JaD
hpWR2NwdtbiOjP+7/iNZdX2zLg8UKI/prjrElU/j0jmgaPKKDXkr8nURkxTRJ7DK
kz4K40jKMgcnelmSFUaErEsnuofBhocYMjrRPRp/SNRaxxdUk5xf0J7F8iCYnTAp
hIETjuMkZplHjer2GXCogNtKKYz/YCUtTIGnyeJ0ydRW75ctC04Hhlc63ESbhIj1
iyN15JbazQHUeon4lua1
=zrYk
-----END PGP SIGNATURE-----

--------------enig3E7774B1810CD517C924C73E--
