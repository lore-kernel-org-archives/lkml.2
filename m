Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2LLOmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:42:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab2LLOmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:42:38 -0500
Date: Wed, 12 Dec 2012 12:42:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.7-rc1] media updates
Message-ID: <20121212124218.6e485944@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

On patch series:
	- Missing MAINTAINERS entries were added for several drivers;
	- Adds V4L2 support for DMABUF handling, allowing zero-copy buffer
	  sharing between V4L2 devices and GPU;
	- Got rid of all warnings when compiling with W=1 on x86;
	- Add a new driver for Exynos hardware (s3c-camif);
	- Several bug fixes, cleanups and driver improvements;

Thanks!
Mauro

Latest commit at the branch: 
77c53d0b56264a8fc5844e087ad15fffe20c299d Merge branch 'for_3.8-rc1' into v4l_for_linus
The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 77c53d0b56264a8fc5844e087ad15fffe20c299d:

  Merge branch 'for_3.8-rc1' into v4l_for_linus (2012-12-11 11:28:37 -0200)

----------------------------------------------------------------

Alan Cox (2):
      [media] pvr2: fix minor storage
      [media] v4l2: sn9c102 incorrectly blocks FMT_SN9C10X

Alexey Klimov (1):
      MAINTAINERS: add an entry for radio-mr800 driver

Anatolij Gustschin (4):
      [media] V4L: soc_camera: allow reading from video device if supported
      [media] mt9v022: add v4l2 controls for blanking
      [media] mt9v022: support required register settings in snapshot mode
      [media] mt9v022: set y_skip_top field to zero as default

Antti Palosaari (1):
      [media] fc2580: write some registers conditionally

Archit Taneja (1):
      [media] omap_vout: Set DSS overlay_info only if paddr is non zero

David Härdeman (2):
      [media] rc-core: add separate defines for protocol bitmaps and numbers
      [media] hid-picolcd_cir: fix compilation

Ezequiel Garcia (2):
      [media] stk1160: Try to continue with fewer transfer buffers
      [media] stkwebcam: Fix sparse warning on undeclared symbol

Fabio Estevam (2):
      [media] coda: Do not use __cancel_delayed_work()
      [media] coda: Fix 'driver_data' for mx53

Frank Schäfer (3):
      [media] gspca_pac7302: correct register documentation
      [media] gspca_pac7302: use registers 0x01 and 0x03 for red and blue balance controls
      [media] ov2640: add support for V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_RGB565_2X8_BE

Gregor Jasny (1):
      [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table

Hans Verkuil (2):
      [media] vpif_capture: protect dma_queue by a spin_lock
      [media] vpif_display: protect dma_queue by a spin_lock

Hans de Goede (4):
      [media] pwc: Fix codec1 cameras no longer working
      [media] MAINTAINERS: Add entries for the radioShark and radioShark2 drivers
      [media] MAINTAINERS: Add an entry for the pwc webcam driver
      [media] gspca-sonixb: Add USB-id for Genius Eye 310

Jesper Juhl (2):
      [media] s5p-tv: don't include linux/version.h in mixer_video.c
      [media] stk1160: Check return value of stk1160_read_reg() in stk1160_i2c_read_reg()

Juergen Lock (1):
      [media] rtl28xxu: add NOXON DAB/DAB+ USB dongle rev 2

Kirill Smelkov (3):
      [media] vivi: Kill BUFFER_TIMEOUT macro
      [media] v4l2: Fix typo in struct v4l2_captureparm description
      [media] vivi: Kill TSTAMP_* macros

Lad, Prabhakar (4):
      [media] media: davinci: vpbe: fix build warning
      [media] media: davinci: vpbe: migrate driver to videobuf2
      [media] media: davinci: vpbe: set device capabilities
      MAINTAINERS: Add entry for Davinci video drivers

Laurent Pinchart (20):
      [media] smiapp-pll: Add missing trailing newlines to warning messages
      [media] smiapp-pll: Create a structure for OP and VT limits
      [media] smiapp-pll: Constify limits argument to smiapp_pll_calculate()
      [media] v4l: Don't warn during link validation when encountering a V4L2 devnode
      [media] v4l: vb2-dma-contig: shorten vb2_dma_contig prefix to vb2_dc
      [media] v4l: vb2-dma-contig: reorder functions
      [media] uvcvideo: Set error_idx properly for extended controls API failures
      [media] uvcvideo: Return -EACCES when trying to access a read/write-only control
      [media] uvcvideo: Don't fail when an unsupported format is requested
      [media] uvcvideo: Set device_caps in VIDIOC_QUERYCAP
      [media] uvcvideo: Return -ENOTTY for unsupported ioctls
      [media] uvcvideo: Add VIDIOC_[GS]_PRIORITY support
      [media] uvcvideo: Mark first output terminal as default video node
      [media] uvcvideo: Fix control value clamping for unsigned integer controls
      [media] omap3isp: Use monotonic timestamps for statistics buffers
      [media] omap3isp: Remove unneeded module memory address definitions
      [media] omap3isp: Replace printk with dev_*
      [media] omap3isp: preview: Add support for 8-bit formats at the sink pad
      [media] omap3isp: Prepare/unprepare clocks before/after enable/disable
      [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check

Malcolm Priestley (2):
      [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
      [media] add MAINTAINERS entry for a few dvb files

Marek Szyprowski (5):
      [media] v4l: vb2: add prepare/finish callbacks to allocators
      [media] v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
      [media] v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
      [media] v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned
      [media] dma-mapping: fix dma_common_get_sgtable() conditional compilation

Martin Blumenstingl (2):
      [media] em28xx: Better support for the Terratec Cinergy HTC USB XS
      [media] drxk: Use the #define instead of hardcoded values

Matthijs Kooijman (1):
      [media] ene-ir: Fix cleanup on probe failure

Mauro Carvalho Chehab (94):
      [media] siano: allow compiling it without RC support
      [media] common/*/Kconfig: Remove unused helps
      [media] remove include/linux/dvb/dmx.h
      [media] Remove include/linux/dvb/ stuff
      [media] drxk_hard: fix a few warnings
      MAINTAINERS: update email and git tree
      [media] siano: get rid of warning: no previous prototype
      [media] drxd_hard: get rid of warning: no previous prototype
      [media] rtl2830.c: get rid of warning: no previous prototype
      [media] rtl2832: get rid of warning: no previous prototype
      [media] stb0899_drv: get rid of warning: no previous prototype
      [media] stv0367: get rid of warning: no previous prototype
      [media] tda10071: get rid of warning: no previous prototype
      [media] tda18271c2dd.c: get rid of warning: no previous prototype
      [media] cx18: get rid of warning: no previous prototype
      [media] cx23885: get rid of warning: no previous prototype
      [media] cx23885-alsa: fix a false gcc warning at dprintk()
      [media] cx25821: get rid of warning: no previous prototype
      [media] dm1105: get rid of warning: no previous prototype
      [media] ivtv: get rid of warning: no previous prototype
      [media] ivtv-ioctl.c: remove an useless check
      [media] mantis: get rid of warning: no previous prototype
      [media] saa7164: get rid of warning: no previous prototype
      [media] radio-aimslab.c: get rid of warning: no previous prototype
      [media] radio-isa: get rid of warning: no previous prototype
      [media] radio-sf16fmi: get rid of warning: no previous prototype
      [media] ene_cir: get rid of warning: no previous prototype
      [media] ite-cir.c: get rid of warning: no previous prototype
      [media] nuvoton-cir: get rid of warning: no previous prototype
      [media] nuvoton-cir: carrier detect support is broken - remove it
      [media] max2165: get rid of warning: no previous prototype
      [media] au0828: get rid of warning: no previous prototype
      [media] cx231xx: get rid of warning: no previous prototype
      [media] cx231xx-avcore: get rid of a sophisticated do-nothing code
      [media] az6027: get rid of warning: no previous prototype
      [media] dvb-usb-v2: get rid of warning: no previous prototype
      [media] lmedm04: get rid of warning: no previous prototype
      [media] vp702x: get rid of warning: no previous prototype
      [media] pvrusb2: get rid of warning: no previous prototype
      [media] pwc-if: get rid of warning: no previous prototype
      [media] pwc-if: must check vb2_queue_init() success
      [media] dib9000: get rid of warning: no previous prototype
      [media] gscpa: get rid of warning: suggest braces around empty body
      [media] jeilinj: fix return of the response code
      [media] gspca: warning fix: index is unsigned, so it will never be below 0
      [media] dt3155v4l: vb2_queue_init() can now fail. Check is required
      [media] go7007-v4l2: warning fix: index is unsigned, so it will never be below 0
      [media] dvb_frontend: Don't declare values twice at a table
      [media] cx88: reorder inline to prevent a gcc warning
      [media] cx88: get rid of a warning at dprintk() macro
      [media] dmxdev: fix a comparition of unsigned expression warning
      [media] drxk: get rid of some unused vars
      [media] dvb-frontends: get rid of some "always false" warnings
      [media] soc_camera/ov2640: Don't use a temp var for an unused value
      [media] ngene: better comment unused code to avoid warnings
      [media] saa7134,saa7164: warning: comparison of unsigned fixes
      [media] meye: fix a warning
      [media] m2m-deinterlace: remove unused vars
      [media] tlg2300: index is unsigned, so never below zero
      [media] fmdrv: better define fmdbg() macro to avoid warnings
      [media] v4l2-common: h_bp var is unused at v4l2_detect_gtf()
      [media] tua9001: fix a warning
      [media] anysee: fix a warning
      [media] em28xx-cards: fix a warning
      [media] s2255drv: index is always positive
      [media] usbvision-core: fix a warning
      [media] zr364xx: urb actual_length is unsigned
      [media] bttv-driver: fix two warnings
      [media] cx25840-core: get rid of warning: no previous prototype
      [media] au0828-dvb: ret is never tested. Get rid of it
      [media] soc_camera: ret is never used. get rid of it
      [media] fmdrv: Don't check if unsigned are below zero
      fintek-cir: get rid of warning: no previous prototype
      [media] drxk_hard: fix the return code from an error handler
      [media] xc4000: Fix a few warnings
      MAINTAINERS: change BTTV status to Odd fixes
      MAINTAINERS: add an explicit entry for cx88
      MAINTAINERS: add an explicit entry for saa7134
      MAINTAINERS: add an explicit entry for em28xx
      MAINTAINERS: add an explicit entry for tm6000
      MAINTAINERS: fix/add missing uapi entries for media files
      MAINTAINERS: add an entry for az6007 DVB driver
      MAINTAINERS: add an entry for tuner-xc2028 driver
      MAINTAINERS: add support for tea5761/tea5767 tuners
      [media] siano: fix RC compilation
      [media] siano: fix build with allmodconfig
      Revert "[media] siano: fix build with allmodconfig"
      [media] siano: fix build with allmodconfig
      videobuf2-dma-contig: Only support if HAVE_GENERIC_DMA_COHERENT
      Revert "videobuf2-dma-contig: Only support if HAVE_GENERIC_DMA_COHERENT"
      Merge remote-tracking branch 'linus/master' into staging/for_v3.8
      Merge tag 'v3.7' into v4l_for_linus
      Merge branch 'for_3.8-rc1' into v4l_for_linus

Murali Karicheri (1):
      [media] media:davinci: clk - {prepare/unprepare} for common clk

Nicolas THERY (1):
      [media] mem2mem: replace BUG_ON with WARN_ON

Paul Bolle (1):
      [media] staging: lirc_serial: silence GCC warning

Peter Senna Tschudin (10):
      [media] drivers/media/pci/ttpci/budget-av.c: fix error return code
      [media] drivers/media/pci/cx25821/cx25821-video-upstream.c: fix error return code
      [media] drivers/media/pci/ngene/ngene-core.c: fix error return code
      [media] drivers/media/pci/dm1105/dm1105.c: fix error return code
      [media] drivers/media/radio/radio-cadet.c: fix error return code
      [media] drivers/media/usb/tm6000/tm6000-video.c: fix error return code
      [media] drivers/media/usb/hdpvr/hdpvr-core.c: fix error return code
      [media] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: fix error return code
      [media] cx25821: fix error return code and clean up
      [media] cx25821: Replace kmemdup for kstrdup and clean up

Randy Dunlap (1):
      [media] i2c/s5k4ecgx: fix printk format warning

Rémi Cardona (2):
      [media] ds3000: Declare MODULE_FIRMWARE usage
      [media] ds3000: remove useless 'locking'

Sachin Kamat (4):
      [media] s5p-mfc: Fix compilation warning
      [media] exynos-gsc: Fix compilation warning
      [media] s5p-mfc: Make 'clk_ref' static in s5p_mfc_pm.c
      [media] s5p-fimc: Make 'fimc_pipeline_s_stream' function static

Sakari Ailus (11):
      [media] v4l: Correct definition of v4l2_buffer.flags related to cache management
      [media] smiapp-pll: Correct type for min_t()
      [media] smiapp-pll: Try other pre-pll divisors
      [media] smiapp: Input for PLL configuration is mostly static
      [media] smiapp-pll: Parallel bus support
      [media] v4l, smiapp, smiapp-pll, adp1653: Update contact information
      MAINTAINERS: Update maintainer for smiapp and adp1653 drivers
      [media] omap3isp: Add CSI configuration registers from control block to ISP resources
      [media] omap3isp: Add PHY routing configuration
      [media] omap3isp: Configure CSI-2 phy based on platform data
      [media] omap3isp: Find source pad from external entity

Sean Young (5):
      [media] winbond-cir: do not rename input name
      MAINTAINERS: add entries for some RC devices
      [media] winbond-cir: fix idle mode
      [media] winbond-cir: increase IR receiver resolution
      [media] winbond-cir: add carrier detection

Shaik Ameer Basha (3):
      [media] exynos-gsc: change driver compatible string
      [media] exynos-gsc: fix variable type in gsc_m2m_device_run()
      [media] s5p-fimc: fix variable type in fimc_device_run()

Shawn Guo (1):
      [media] media: mx1_camera: mark the driver BROKEN

Shubhrajyoti D (1):
      [media] adv7604: convert struct i2c_msg initialization to C99 format

Srinivas Kandagatla (4):
      [media] media/bfin: use module_platform_driver macro
      [media] media/m2m: use module_platform_driver macro
      [media] [3.6.0-,3/5] media/mx2_emmaprp: use module_platform_driver macro
      [media] media/ir_rx51: use module_platform_driver macro

Stefan Richter (1):
      [media] firedtv: add MAINTAINERS entry

Sumit Semwal (4):
      [media] v4l: Add DMABUF as a memory type
      [media] v4l: vb2: add support for shared buffer (dma_buf)
      [media] v4l: vb: remove warnings about MEMORY_DMABUF
      [media] v4l: vb2-dma-contig: add support for dma_buf importing

Sylwester Nawrocki (3):
      [media] s5p-fimc: Add missing new line character
      MAINTAINERS: Add entry for S3C24XX/S3C64XX SoC CAMIF driver
      [media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface

Tomasz Stanislawski (18):
      [media] Documentation: media: description of DMABUF importing in V4L2
      [media] v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
      [media] v4l: vb2-dma-contig: add support for scatterlist in userptr mode
      [media] v4l: vb2-vmalloc: add support for dmabuf importing
      [media] v4l: vivi: support for dmabuf importing
      [media] v4l: uvc: add support for DMABUF importing
      [media] v4l: mem2mem_testdev: add support for dmabuf importing
      [media] v4l: s5p-tv: mixer: support for dmabuf importing
      [media] v4l: s5p-fimc: support for dmabuf importing
      [media] v4l: add buffer exporting via dmabuf
      [media] Documentation: media: description of DMABUF exporting in V4L2
      [media] v4l: vb2: add buffer exporting via dmabuf
      [media] v4l: vb2-dma-contig: add support for DMABUF exporting
      [media] v4l: vb2-dma-contig: add reference counting for a device from allocator context
      [media] v4l: vb2-dma-contig: align buffer size to PAGE_SIZE
      [media] v4l: s5p-fimc: support for dmabuf exporting
      [media] v4l: s5p-tv: mixer: support for dmabuf exporting
      [media] v4l: s5p-mfc: support for dmabuf exporting

Wei Yongjun (9):
      [media] cx23885: use list_move_tail instead of list_del/list_add_tail
      [media] cx88: use list_move_tail instead of list_del/list_add_tail
      [media] v4l2: use list_move_tail instead of list_del/list_add_tail
      [media] staging :go700: use module_i2c_driver to simplify the code
      [media] i2c: vs6624: use module_i2c_driver to simplify the code
      [media] i2c: adv7183: use module_i2c_driver to simplify the code
      [media] davinci: vpif_capture: fix return type check for v4l2_subdev_call()
      [media] davinci: vpif_display: fix return type check for v4l2_subdev_call()
      [media] davinci: vpif: fix return value check for vb2_dma_contig_init_ctx()

YAMANE Toshiaki (7):
      [media] Staging/media: fixed spacing coding style in go7007/wis-ov7640.c
      [media] Staging/media: Use dev_ printks in go7007/wis-ov7640.c
      [media] Staging/media: fixed spacing coding style in go7007/wis-saa7115.c
      [media] staging/media: Use dev_ or pr_ printks in go7007/wis-saa7115.c
      [media] Staging/media: fixed spacing coding style in go7007/wis-saa7113.c
      [media] staging/media: Use dev_ or pr_ printks in go7007/wis-saa7113.c
      [media] staging/media: Use dev_ printks in go7007/go7007-fw.c

 Documentation/DocBook/media/v4l/compat.xml         |    7 +
 Documentation/DocBook/media/v4l/io.xml             |  188 ++-
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  212 +++
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
 MAINTAINERS                                        |  250 ++-
 arch/arm/mach-omap2/devices.c                      |   10 +
 arch/arm/mach-pxa/pcm990-baseboard.c               |    6 +
 drivers/base/dma-mapping.c                         |    4 +-
 drivers/hid/hid-picolcd_cir.c                      |    2 +-
 drivers/media/common/Kconfig                       |    7 +
 drivers/media/common/b2c2/Kconfig                  |    5 -
 drivers/media/common/siano/Kconfig                 |   18 +-
 drivers/media/common/siano/Makefile                |    6 +-
 drivers/media/common/siano/smscoreapi.c            |    2 +-
 drivers/media/common/siano/smsir.c                 |    2 +-
 drivers/media/common/siano/smsir.h                 |    9 +
 drivers/media/dvb-core/dmxdev.c                    |    2 +-
 drivers/media/dvb-core/dmxdev.h                    |    1 +
 drivers/media/dvb-core/dvb-usb-ids.h               |    1 +
 drivers/media/dvb-core/dvb_frontend.c              |   10 -
 drivers/media/dvb-frontends/cx22700.c              |    4 +-
 drivers/media/dvb-frontends/cx24123.c              |    2 +-
 drivers/media/dvb-frontends/dib9000.h              |    2 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    8 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   24 +-
 drivers/media/dvb-frontends/drxk_hard.h            |    6 +-
 drivers/media/dvb-frontends/ds3000.c               |   15 +-
 drivers/media/dvb-frontends/l64781.c               |    4 +-
 drivers/media/dvb-frontends/mt312.c                |    4 +-
 drivers/media/dvb-frontends/rtl2830.c              |    6 +-
 drivers/media/dvb-frontends/rtl2832.c              |    6 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb-frontends/stv0367.c              |   19 +-
 drivers/media/dvb-frontends/tda10071.c             |    6 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    1 +
 drivers/media/firewire/firedtv.h                   |    1 +
 drivers/media/i2c/adp1653.c                        |    4 +-
 drivers/media/i2c/adv7183.c                        |   13 +-
 drivers/media/i2c/adv7604.c                        |   16 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    2 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   14 +-
 drivers/media/i2c/s5k4ecgx.c                       |    2 +-
 drivers/media/i2c/smiapp-pll.c                     |  219 +--
 drivers/media/i2c/smiapp-pll.h                     |   61 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   74 +-
 drivers/media/i2c/smiapp/smiapp-limits.c           |    2 +-
 drivers/media/i2c/smiapp/smiapp-limits.h           |    2 +-
 drivers/media/i2c/smiapp/smiapp-quirk.c            |    2 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h            |    2 +-
 drivers/media/i2c/smiapp/smiapp-reg-defs.h         |    2 +-
 drivers/media/i2c/smiapp/smiapp-reg.h              |    2 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |    2 +-
 drivers/media/i2c/smiapp/smiapp-regs.h             |    2 +-
 drivers/media/i2c/smiapp/smiapp.h                  |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   88 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   55 +-
 drivers/media/i2c/vs6624.c                         |   13 +-
 drivers/media/mmc/siano/Kconfig                    |    3 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    7 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    1 +
 drivers/media/pci/cx18/cx18-i2c.c                  |    2 +-
 drivers/media/pci/cx18/cx18-streams.c              |    2 +-
 drivers/media/pci/cx23885/altera-ci.c              |   45 +-
 drivers/media/pci/cx23885/cimax2.c                 |   17 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |    6 +-
 drivers/media/pci/cx23885/cx23885-av.c             |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    8 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-f300.c           |    1 +
 drivers/media/pci/cx23885/cx23885-input.c          |    7 +-
 drivers/media/pci/cx23885/cx23885-input.h          |    2 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c          |    2 +
 drivers/media/pci/cx23885/cx23885-ir.c             |    1 +
 drivers/media/pci/cx23885/cx23888-ir.c             |    1 +
 drivers/media/pci/cx23885/netup-init.c             |    1 +
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |   44 +-
 drivers/media/pci/cx25821/cx25821-biffuncs.h       |    6 +-
 drivers/media/pci/cx25821/cx25821-i2c.c            |    4 +-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c |   54 +-
 drivers/media/pci/cx25821/cx25821-video-upstream.c |   47 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    8 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |   14 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    7 +-
 drivers/media/pci/cx88/cx88-core.c                 |   12 +-
 drivers/media/pci/cx88/cx88-input.c                |    8 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   18 +-
 drivers/media/pci/cx88/cx88.h                      |    4 +-
 drivers/media/pci/dm1105/dm1105.c                  |    8 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    6 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             |    4 -
 drivers/media/pci/ivtv/ivtv-firmware.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |    8 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    4 +-
 drivers/media/pci/mantis/mantis_input.c            |    5 +-
 drivers/media/pci/mantis/mantis_uart.c             |    2 +-
 drivers/media/pci/mantis/mantis_vp1033.c           |    6 +-
 drivers/media/pci/meye/meye.c                      |    2 +-
 drivers/media/pci/ngene/ngene-cards.c              |    4 +-
 drivers/media/pci/ngene/ngene-core.c               |    7 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    3 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7164/saa7164-api.c            |   26 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |    6 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |   16 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    4 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |   15 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |    8 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |    6 +-
 drivers/media/pci/ttpci/av7110.h                   |    1 +
 drivers/media/pci/ttpci/budget-av.c                |    4 +-
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/blackfin/bfin_capture.c     |   14 +-
 drivers/media/platform/coda.c                      |    4 +-
 drivers/media/platform/davinci/Kconfig             |    2 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |    8 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   16 +-
 drivers/media/platform/davinci/isif.c              |    5 +-
 drivers/media/platform/davinci/vpbe.c              |   10 +-
 drivers/media/platform/davinci/vpbe_display.c      |  303 ++--
 drivers/media/platform/davinci/vpbe_osd.c          |    9 +-
 drivers/media/platform/davinci/vpif.c              |    8 +-
 drivers/media/platform/davinci/vpif_capture.c      |   34 +-
 drivers/media/platform/davinci/vpif_display.c      |   28 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/fsl-viu.c                   |    6 +-
 drivers/media/platform/m2m-deinterlace.c           |   24 +-
 drivers/media/platform/mem2mem_testdev.c           |    4 +-
 drivers/media/platform/mx2_emmaprp.c               |   14 +-
 drivers/media/platform/omap/omap_vout.c            |   36 +-
 drivers/media/platform/omap3isp/isp.c              |   83 +-
 drivers/media/platform/omap3isp/isp.h              |    5 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |    6 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |  227 ++-
 drivers/media/platform/omap3isp/ispcsiphy.h        |   10 -
 drivers/media/platform/omap3isp/isphist.c          |    8 +-
 drivers/media/platform/omap3isp/isppreview.c       |   41 +-
 drivers/media/platform/omap3isp/ispreg.h           |   99 +-
 drivers/media/platform/omap3isp/ispstat.c          |    5 +-
 drivers/media/platform/omap3isp/ispstat.h          |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    3 +-
 drivers/media/platform/s3c-camif/Makefile          |    5 +
 drivers/media/platform/s3c-camif/camif-capture.c   | 1672 ++++++++++++++++++++
 drivers/media/platform/s3c-camif/camif-core.c      |  662 ++++++++
 drivers/media/platform/s3c-camif/camif-core.h      |  393 +++++
 drivers/media/platform/s3c-camif/camif-regs.c      |  606 +++++++
 drivers/media/platform/s3c-camif/camif-regs.h      |  269 ++++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |   11 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |   16 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   13 +-
 drivers/media/platform/soc_camera/Kconfig          |    1 +
 drivers/media/platform/soc_camera/soc_camera.c     |   14 +-
 drivers/media/platform/vivi.c                      |    8 +-
 drivers/media/radio/radio-aimslab.c                |    2 +-
 drivers/media/radio/radio-cadet.c                  |    3 +-
 drivers/media/radio/radio-isa.c                    |   10 +-
 drivers/media/radio/radio-sf16fmi.c                |    2 +-
 drivers/media/radio/radio-tea5764.c                |    4 +-
 drivers/media/radio/si4713-i2c.c                   |    2 +-
 drivers/media/radio/wl128x/fmdrv.h                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    2 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |    2 +-
 drivers/media/rc/ati_remote.c                      |    2 +-
 drivers/media/rc/ene_ir.c                          |   33 +-
 drivers/media/rc/fintek-cir.c                      |    6 +-
 drivers/media/rc/gpio-ir-recv.c                    |    2 +-
 drivers/media/rc/iguanair.c                        |    2 +-
 drivers/media/rc/imon.c                            |   40 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    4 +-
 drivers/media/rc/ir-lirc-codec.c                   |    4 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |    4 +-
 drivers/media/rc/ir-nec-decoder.c                  |    4 +-
 drivers/media/rc/ir-rc5-decoder.c                  |   14 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |    6 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    8 +-
 drivers/media/rc/ir-rx51.c                         |   13 +-
 drivers/media/rc/ir-sanyo-decoder.c                |    4 +-
 drivers/media/rc/ir-sony-decoder.c                 |   17 +-
 drivers/media/rc/ite-cir.c                         |    6 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    2 +-
 drivers/media/rc/mceusb.c                          |    2 +-
 drivers/media/rc/nuvoton-cir.c                     |   13 +-
 drivers/media/rc/nuvoton-cir.h                     |    1 -
 drivers/media/rc/rc-loopback.c                     |    2 +-
 drivers/media/rc/rc-main.c                         |   73 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/rc/streamzap.c                       |    2 +-
 drivers/media/rc/ttusbir.c                         |    2 +-
 drivers/media/rc/winbond-cir.c                     |  113 +-
 drivers/media/tuners/fc2580.c                      |   61 +-
 drivers/media/tuners/max2165.c                     |    2 +-
 drivers/media/tuners/tua9001.c                     |    2 +-
 drivers/media/tuners/xc4000.c                      |    2 +-
 drivers/media/usb/au0828/au0828-cards.c            |    2 +-
 drivers/media/usb/au0828/au0828-dvb.c              |    5 +-
 drivers/media/usb/au0828/au0828-video.c            |   16 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |    9 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    8 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |    2 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |    4 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    4 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   14 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |   12 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    6 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |    8 +-
 drivers/media/usb/dvb-usb/az6027.c                 |   11 +-
 drivers/media/usb/dvb-usb/dib0700.h                |    2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   16 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  146 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |    4 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    2 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |    2 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |    8 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   15 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   84 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   16 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/usb/gspca/gspca.c                    |    3 +-
 drivers/media/usb/gspca/gspca.h                    |    2 +-
 drivers/media/usb/gspca/jeilinj.c                  |    6 +-
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c       |    6 +
 drivers/media/usb/gspca/pac7302.c                  |   62 +-
 drivers/media/usb/gspca/sonixb.c                   |    1 +
 drivers/media/usb/hdpvr/hdpvr-core.c               |    2 +
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    6 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    4 +-
 drivers/media/usb/pwc/pwc-ctrl.c                   |    2 +
 drivers/media/usb/pwc/pwc-if.c                     |    8 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/siano/Kconfig                    |    3 +-
 drivers/media/usb/sn9c102/sn9c102_core.c           |    2 +
 drivers/media/usb/stk1160/stk1160-i2c.c            |    2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |   23 +-
 drivers/media/usb/stk1160/stk1160.h                |    5 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    5 +-
 drivers/media/usb/tlg2300/pd-dvb.c                 |    1 +
 drivers/media/usb/tlg2300/pd-video.c               |    4 +-
 drivers/media/usb/tm6000/tm6000-input.c            |   20 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    1 +
 drivers/media/usb/usbvision/usbvision.h            |    2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   29 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   10 +
 drivers/media/usb/uvc/uvc_entity.c                 |    2 +
 drivers/media/usb/uvc/uvc_queue.c                  |    2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   89 +-
 drivers/media/usb/uvc/uvc_video.c                  |    1 +
 drivers/media/usb/uvc/uvcvideo.h                   |    8 +
 drivers/media/usb/zr364xx/zr364xx.c                |    3 +-
 drivers/media/v4l2-core/Kconfig                    |    3 +
 drivers/media/v4l2-core/v4l2-common.c              |    3 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   19 +
 drivers/media/v4l2-core/v4l2-dev.c                 |    1 +
 drivers/media/v4l2-core/v4l2-event.c               |    2 +-
 drivers/media/v4l2-core/v4l2-fh.c                  |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   11 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   19 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   22 +-
 drivers/media/v4l2-core/videobuf-core.c            |    4 +
 drivers/media/v4l2-core/videobuf2-core.c           |  300 +++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |  700 +++++++-
 drivers/media/v4l2-core/videobuf2-memops.c         |   40 -
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   56 +
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    4 +-
 drivers/staging/media/go7007/go7007-fw.c           |   42 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |    2 +-
 drivers/staging/media/go7007/s2250-board.c         |   13 +-
 drivers/staging/media/go7007/wis-ov7640.c          |   20 +-
 drivers/staging/media/go7007/wis-saa7113.c         |   20 +-
 drivers/staging/media/go7007/wis-saa7115.c         |   20 +-
 drivers/staging/media/go7007/wis-sony-tuner.c      |   13 +-
 drivers/staging/media/go7007/wis-tw2804.c          |   13 +-
 drivers/staging/media/go7007/wis-tw9903.c          |   13 +-
 drivers/staging/media/go7007/wis-uda1342.c         |   13 +-
 drivers/staging/media/lirc/lirc_serial.c           |    6 +-
 include/linux/dvb/dmx.h                            |   29 -
 include/linux/dvb/video.h                          |   29 -
 include/media/adp1653.h                            |    4 +-
 include/media/davinci/vpbe_display.h               |   15 +-
 include/media/davinci/vpbe_osd.h                   |    2 +-
 include/media/ir-kbd-i2c.h                         |    2 +-
 include/media/mt9v022.h                            |   16 +
 include/media/rc-core.h                            |    4 +-
 include/media/rc-map.h                             |   64 +-
 include/media/s3c_camif.h                          |   45 +
 include/media/smiapp.h                             |    2 +-
 include/media/v4l2-event.h                         |    2 +-
 include/media/v4l2-fh.h                            |    2 +-
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-mem2mem.h                       |    3 +
 include/media/videobuf2-core.h                     |   38 +
 include/media/videobuf2-memops.h                   |    5 -
 include/uapi/linux/videodev2.h                     |   37 +-
 313 files changed, 7754 insertions(+), 1863 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml
 create mode 100644 drivers/media/platform/s3c-camif/Makefile
 create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
 delete mode 100644 include/linux/dvb/Kbuild
 delete mode 100644 include/linux/dvb/dmx.h
 delete mode 100644 include/linux/dvb/video.h
 create mode 100644 include/media/mt9v022.h
 create mode 100644 include/media/s3c_camif.h



-- 

Cheers,
Mauro
