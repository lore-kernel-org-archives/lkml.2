Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1KDNIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab1KDNIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:08:54 -0400
Message-ID: <4EB3D7FC.7030507@redhat.com>
Date: Fri, 04 Nov 2011 10:18:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.2-rc1] media updates part 2
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For:
	- move cx25821 out of staging;
	  (acked by Greg KH)
	- move the remaining media staging drivers to drivers/staging/media;
	  (acked by Greg KH)
	- a new staging driver at drivers/staging/media: as102;
	- a huge pile of patches that will allow soc_camera sensors to be re-used by
	  other drivers;
	- a new driver for MaxLinear MxL111SF DVB-T devices;
	- A new Exynos4 driver (s5k6aa);
	- some other random driver fixes, board additions;
	- Support for single ITE 9135 devices;
	- a few minor improvements needed by some drivers (like adding support for devices
	  capable of auto-detecting illumination blinking frequency);

Thanks!
Mauro

-

Latest commit at the branch: 
    b3f4e1eba45eda5d1213810ef3bc53e5247df2df [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set

The following changes since commit 1eb63378354ac37b7e27d256bbf84684751bac32:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2011-10-31 15:42:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Andy Walls (1):
      [media] cx18: Fix FM radio

Bastian Hecht (1):
      [media] media: ov5642: Add support for arbitrary resolution

Dan Carpenter (1):
      [media] cx25821: off by one in cx25821_vidioc_s_input()

Devin Heitmueller (9):
      [media] staging: as102: Fix CodingStyle errors in file as102_drv.c
      [media] staging: as102: Fix CodingStyle errors in file as102_fw.c
      [media] staging: as102: Fix CodingStyle errors in file as10x_cmd.c
      [media] staging: as102: Fix CodingStyle errors in file as10x_cmd_stream.c
      [media] staging: as102: Fix CodingStyle errors in file as102_fe.c
      [media] staging: as102: Fix CodingStyle errors in file as102_usb_drv.c
      [media] staging: as102: Fix CodingStyle errors in file as10x_cmd_cfg.c
      [media] staging: as102: Add Elgato EyeTV DTT Deluxe
      [media] staging: as102: Properly handle multiple product names

Guennadi Liakhovetski (86):
      [media] V4L: sh_mobile_ceu_camera: output image sizes must be a multiple of 4
      [media] V4L: sh_mobile_ceu_camera: don't try to improve client scaling, if perfect
      [media] V4L: sh_mobile_ceu_camera: fix field addresses in interleaved mode
      [media] V4L: sh_mobile_ceu_camera: remove duplicated code
      [media] V4L: imx074: support the new mbus-config subdev ops
      [media] V4L: soc-camera: add helper functions for new bus configuration type
      [media] V4L: mt9m001: support the new mbus-config subdev ops
      [media] V4L: mt9m111: support the new mbus-config subdev ops
      [media] V4L: mt9t031: support the new mbus-config subdev ops
      [media] V4L: mt9t112: support the new mbus-config subdev ops
      [media] V4L: mt9v022: support the new mbus-config subdev ops
      [media] V4L: ov2640: support the new mbus-config subdev ops
      [media] V4L: ov5642: support the new mbus-config subdev ops
      [media] V4L: ov6650: support the new mbus-config subdev ops
      [media] V4L: ov772x: rename macros to not pollute the global namespace
      [media] V4L: ov772x: support the new mbus-config subdev ops
      [media] V4L: ov9640: support the new mbus-config subdev ops
      [media] V4L: ov9740: support the new mbus-config subdev ops
      [media] V4L: rj54n1cb0c: support the new mbus-config subdev ops
      [media] ARM: ap4evb: switch imx074 configuration to default number of lanes
      [media] V4L: sh_mobile_csi2: verify client compatibility
      [media] V4L: sh_mobile_csi2: support the new mbus-config subdev ops
      [media] V4L: tw9910: remove a not really implemented cropping support
      [media] V4L: tw9910: support the new mbus-config subdev ops
      [media] V4L: soc_camera_platform: support the new mbus-config subdev ops
      [media] V4L: soc-camera: compatible bus-width flags
      [media] ARM: mach-shmobile: convert mackerel to mediabus flags
      [media] sh: convert ap325rxa to mediabus flags
      [media] ARM: PXA: use gpio_set_value_cansleep() on pcm990
      [media] V4L: atmel-isi: convert to the new mbus-config subdev operations
      [media] V4L: mx1_camera: convert to the new mbus-config subdev operations
      [media] V4L: mx2_camera: convert to the new mbus-config subdev operations
      [media] V4L: ov2640: remove undefined struct
      [media] V4L: mx3_camera: convert to the new mbus-config subdev operations
      [media] V4L: mt9m001, mt9v022: add a clarifying comment
      [media] V4L: omap1_camera: convert to the new mbus-config subdev operations
      [media] V4L: pxa_camera: convert to the new mbus-config subdev operations
      [media] V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev operations
      [media] V4L: soc-camera: camera client operations no longer compulsory
      [media] V4L: mt9m001: remove superfluous soc-camera client operations
      [media] V4L: mt9m111: remove superfluous soc-camera client operations
      [media] V4L: imx074: remove superfluous soc-camera client operations
      [media] V4L: mt9t031: remove superfluous soc-camera client operations
      [media] V4L: mt9t112: remove superfluous soc-camera client operations
      [media] V4L: mt9v022: remove superfluous soc-camera client operations
      [media] V4L: ov2640: remove superfluous soc-camera client operations
      [media] V4L: ov5642: remove superfluous soc-camera client operations
      [media] V4L: ov6650: remove superfluous soc-camera client operations
      [media] sh: ap3rxa: remove redundant soc-camera platform data fields
      [media] sh: migor: remove unused ov772x buswidth flag
      [media] V4L: ov772x: remove superfluous soc-camera client operations
      [media] V4L: ov9640: remove superfluous soc-camera client operations
      [media] V4L: ov9740: remove superfluous soc-camera client operations
      [media] V4L: rj54n1cb0c: remove superfluous soc-camera client operations
      [media] V4L: sh_mobile_csi2: remove superfluous soc-camera client operations
      [media] ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
      [media] V4L: soc_camera_platform: remove superfluous soc-camera client operations
      [media] V4L: tw9910: remove superfluous soc-camera client operations
      [media] V4L: soc-camera: remove soc-camera client bus-param operations and supporting code
      [media] V4L: mt9t112: fix broken cropping and scaling
      [media] V4L: sh-mobile-ceu-camera: fix mixed CSI2 & parallel camera case
      [media] V4L: omap1-camera: fix Oops with NULL platform data
      [media] V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
      [media] V4L: add two new ioctl()s for multi-size videobuffer management
      [media] V4L: videobuf2: update buffer state on VIDIOC_QBUF
      [media] V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
      [media] V4L: vb2: prepare to support multi-size buffers
      [media] V4L: vb2: add support for buffers of different sizes on a single queue
      [media] dmaengine: ipu-idmac: add support for the DMA_PAUSE control
      [media] V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
      [media] V4L: mx3-camera: prepare to support multi-size buffers
      [media] V4L: soc-camera: add 2 new ioctl() handlers
      [media] V4L: sh_mobile_ceu_camera: the host shall configure the pipeline
      [media] V4L: sh_mobile_csi2: do not guess the client, the host tells us
      [media] V4L: soc-camera: split a function into two
      [media] V4L: soc_camera_platform: do not leave dangling invalid pointers
      [media] V4L: soc-camera: call subdevice .s_power() method, when powering up or down
      [media] V4L: docbook documentation for struct v4l2_create_buffers
      [media] V4L: soc-camera: start removing struct soc_camera_device from client drivers
      [media] V4L: mt9m001, mt9v022: use internally cached pixel code
      [media] V4L: sh_mobile_csi2: fix unbalanced pm_runtime_put()
      [media] V4L: dynamically allocate video_device nodes in subdevices
      [media] V4L: add .g_std() core V4L2 subdevice operation
      [media] V4L: soc-camera: make (almost) all client drivers re-usable outside of the framework
      [media] V4L: replace soc-camera specific soc_mediabus.h with v4l2-mediabus.h
      [media] omap3isp: ccdc: remove redundant operation

Hans Verkuil (13):
      [media] soc_camera: add control handler support
      [media] sh_mobile_ceu_camera: implement the control handler
      [media] ov9640: convert to the control framework
      [media] ov772x: convert to the control framework
      [media] rj54n1cb0c: convert to the control framework
      [media] mt9v022: convert to the control framework
      [media] ov2640: convert to the control framework
      [media] ov6650: convert to the control framework
      [media] ov9740: convert to the control framework
      [media] mt9m001: convert to the control framework
      [media] mt9m111: convert to the control framework
      [media] mt9t031: convert to the control framework
      [media] soc_camera: remove the now obsolete struct soc_camera_ops

Ian Armstrong (1):
      [media] ivtv: Fix radio support

Janusz Krzysztofik (1):
      [media] media: ov6650: stylistic improvements

Laurent Pinchart (9):
      [media] omap3isp: Move media_entity_cleanup() from unregister() to cleanup()
      [media] omap3isp: Move *_init_entities() functions to the init/cleanup section
      [media] omap3isp: Add missing mutex_destroy() calls
      [media] omap3isp: Fix memory leaks in initialization error paths
      [media] omap3isp: Report the ISP revision through the media controller API
      [media] omap3isp: preview: Remove horizontal averager support
      [media] omap3isp: preview: Rename min/max input/output sizes defines
      [media] omap3isp: preview: Add crop support on the sink pad
      [media] omap_vout: Add poll() support

Malcolm Priestley (1):
      [media] it913x [VER 1.07] Support for single ITE 9135 devices

Mauro Carvalho Chehab (2):
      [media] move cx25821 out of staging
      staging: Move media drivers to staging/media

Michael Krufky (4):
      [media] DVB: add MaxLinear MxL111SF DVB-T demodulator driver
      [media] mxl111sf: add DVB-T support
      [media] mxl111sf: disable snr / ber calculations for DVB-T
      [media] mxl111sf: update demod_ops.info.name to "MaxLinear MxL111SF DVB-T demodulator"

Paul Bolle (1):
      [media] media: tea5764: reconcile Kconfig symbol and macro

Pierrick Hascoet (2):
      [media] staging: as102: Initial import from Abilis
      [media] staging: as102: Fix licensing oversight

Piotr Chmura (3):
      [media] staging: as102: Remove non-linux headers inclusion
      [media] staging: as102: Enable compilation
      [media] staging: as102: Add nBox Tuner Dongle support

Sachin Kamat (1):
      [media] MFC: Change MFC firmware binary name

Scott Jiang (1):
      [media] vb2: add vb2_get_unmapped_area in vb2 core

Sylwester Nawrocki (5):
      [media] staging: as102: Convert the comments to kernel-doc style
      [media] staging: as102: Unconditionally compile code dependent on DVB_CORE
      [media] staging: as102: Remove conditional compilation based on kernel version
      [media] v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
      [media] v4l: Add v4l2 subdev driver for S5K6AAFX sensor

Teka (1):
      [media] Support for Terratec G1

Timo Kokkonen (1):
      [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |    5 +-
 Documentation/DocBook/media/v4l/io.xml             |   27 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  139 ++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   88 +
 arch/arm/mach-pxa/pcm990-baseboard.c               |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    7 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   10 +-
 arch/sh/boards/mach-migor/setup.c                  |    4 +-
 drivers/dma/ipu/ipu_idmac.c                        |   65 +-
 drivers/media/dvb/ddbridge/Makefile                |    2 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    2 +
 drivers/media/dvb/dvb-usb/it913x.c                 |  105 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c         |  614 +++++++
 drivers/media/dvb/dvb-usb/mxl111sf-demod.h         |   55 +
 drivers/media/dvb/dvb-usb/mxl111sf.c               |  228 +++-
 drivers/media/dvb/dvb-usb/mxl111sf.h               |    2 +-
 drivers/media/dvb/ngene/Makefile                   |    2 +-
 drivers/media/radio/radio-tea5764.c                |    4 +-
 drivers/media/video/Kconfig                        |    9 +
 drivers/media/video/Makefile                       |    2 +
 drivers/media/video/atmel-isi.c                    |  142 +-
 drivers/media/video/cx18/cx18-driver.c             |    2 +
 drivers/{staging => media/video}/cx25821/Kconfig   |    0
 drivers/{staging => media/video}/cx25821/Makefile  |    0
 .../video}/cx25821/cx25821-alsa.c                  |    0
 .../video}/cx25821/cx25821-audio-upstream.c        |    0
 .../video}/cx25821/cx25821-audio-upstream.h        |    0
 .../video}/cx25821/cx25821-audio.h                 |    0
 .../video}/cx25821/cx25821-biffuncs.h              |    0
 .../video}/cx25821/cx25821-cards.c                 |    0
 .../video}/cx25821/cx25821-core.c                  |    0
 .../video}/cx25821/cx25821-gpio.c                  |    0
 .../{staging => media/video}/cx25821/cx25821-i2c.c |    0
 .../video}/cx25821/cx25821-medusa-defines.h        |    0
 .../video}/cx25821/cx25821-medusa-reg.h            |    0
 .../video}/cx25821/cx25821-medusa-video.c          |    0
 .../video}/cx25821/cx25821-medusa-video.h          |    0
 .../{staging => media/video}/cx25821/cx25821-reg.h |    0
 .../video}/cx25821/cx25821-sram.h                  |    0
 .../video}/cx25821/cx25821-video-upstream-ch2.c    |    0
 .../video}/cx25821/cx25821-video-upstream-ch2.h    |    0
 .../video}/cx25821/cx25821-video-upstream.c        |    0
 .../video}/cx25821/cx25821-video-upstream.h        |    0
 .../video}/cx25821/cx25821-video.c                 |    2 +-
 .../video}/cx25821/cx25821-video.h                 |    0
 drivers/{staging => media/video}/cx25821/cx25821.h |    3 +-
 drivers/media/video/em28xx/em28xx-cards.c          |    2 +
 drivers/media/video/imx074.c                       |   54 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    2 +
 drivers/media/video/marvell-ccic/mcam-core.c       |    3 +-
 drivers/media/video/mem2mem_testdev.c              |    7 +-
 drivers/media/video/mt9m001.c                      |  328 ++---
 drivers/media/video/mt9m111.c                      |  260 +---
 drivers/media/video/mt9t031.c                      |  347 ++---
 drivers/media/video/mt9t112.c                      |  269 ++--
 drivers/media/video/mt9v022.c                      |  447 +++---
 drivers/media/video/mx1_camera.c                   |   71 +-
 drivers/media/video/mx2_camera.c                   |   78 +-
 drivers/media/video/mx3_camera.c                   |  359 ++---
 drivers/media/video/omap/omap_vout.c               |   10 +
 drivers/media/video/omap1_camera.c                 |   62 +-
 drivers/media/video/omap3isp/isp.c                 |    3 +
 drivers/media/video/omap3isp/ispccdc.c             |   86 +-
 drivers/media/video/omap3isp/ispccp2.c             |  125 +-
 drivers/media/video/omap3isp/ispcsi2.c             |   91 +-
 drivers/media/video/omap3isp/isph3a_aewb.c         |    2 +-
 drivers/media/video/omap3isp/isph3a_af.c           |    2 +-
 drivers/media/video/omap3isp/isphist.c             |    2 +-
 drivers/media/video/omap3isp/isppreview.c          |  419 ++++--
 drivers/media/video/omap3isp/isppreview.h          |    9 +-
 drivers/media/video/omap3isp/ispreg.h              |    3 -
 drivers/media/video/omap3isp/ispresizer.c          |  104 +-
 drivers/media/video/omap3isp/ispstat.c             |   52 +-
 drivers/media/video/omap3isp/ispstat.h             |    2 +-
 drivers/media/video/omap3isp/ispvideo.c            |   11 +-
 drivers/media/video/omap3isp/ispvideo.h            |    1 +
 drivers/media/video/ov2640.c                       |  178 +--
 drivers/media/video/ov5642.c                       |  288 +++--
 drivers/media/video/ov6650.c                       |  504 ++----
 drivers/media/video/ov772x.c                       |  198 +--
 drivers/media/video/ov9640.c                       |  186 +--
 drivers/media/video/ov9640.h                       |    4 +-
 drivers/media/video/ov9740.c                       |  151 +--
 drivers/media/video/pwc/pwc-if.c                   |    6 +-
 drivers/media/video/pxa_camera.c                   |  140 +-
 drivers/media/video/rj54n1cb0c.c                   |  223 +--
 drivers/media/video/s5k6aa.c                       | 1680 ++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-capture.c        |    6 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c         |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    5 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    4 +-
 drivers/media/video/saa7134/saa7134.h              |   12 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  491 ++++---
 drivers/media/video/sh_mobile_csi2.c               |  132 +-
 drivers/media/video/soc_camera.c                   |  273 ++--
 drivers/media/video/soc_camera_platform.c          |   45 +-
 drivers/media/video/soc_mediabus.c                 |   33 +
 drivers/media/video/tw9910.c                       |  268 ++--
 drivers/media/video/v4l2-compat-ioctl32.c          |   76 +-
 drivers/media/video/v4l2-ctrls.c                   |    1 +
 drivers/media/video/v4l2-device.c                  |   36 +-
 drivers/media/video/v4l2-ioctl.c                   |   36 +
 drivers/media/video/videobuf2-core.c               |  391 ++++-
 drivers/media/video/vivi.c                         |    6 +-
 drivers/staging/Kconfig                            |   16 +-
 drivers/staging/Makefile                           |    8 +-
 drivers/staging/cx25821/README                     |    6 -
 drivers/staging/media/Kconfig                      |   37 +
 drivers/staging/media/Makefile                     |    7 +
 drivers/staging/media/as102/Kconfig                |    7 +
 drivers/staging/media/as102/Makefile               |    6 +
 drivers/staging/media/as102/as102_drv.c            |  351 ++++
 drivers/staging/media/as102/as102_drv.h            |  141 ++
 drivers/staging/media/as102/as102_fe.c             |  603 +++++++
 drivers/staging/media/as102/as102_fw.c             |  251 +++
 drivers/staging/media/as102/as102_fw.h             |   42 +
 drivers/staging/media/as102/as102_usb_drv.c        |  478 ++++++
 drivers/staging/media/as102/as102_usb_drv.h        |   59 +
 drivers/staging/media/as102/as10x_cmd.c            |  452 ++++++
 drivers/staging/media/as102/as10x_cmd.h            |  540 +++++++
 drivers/staging/media/as102/as10x_cmd_cfg.c        |  215 +++
 drivers/staging/media/as102/as10x_cmd_stream.c     |  223 +++
 drivers/staging/media/as102/as10x_handle.h         |   58 +
 drivers/staging/media/as102/as10x_types.h          |  198 +++
 drivers/staging/{ => media}/cxd2099/Kconfig        |    0
 drivers/staging/{ => media}/cxd2099/Makefile       |    0
 drivers/staging/{ => media}/cxd2099/TODO           |    0
 drivers/staging/{ => media}/cxd2099/cxd2099.c      |    0
 drivers/staging/{ => media}/cxd2099/cxd2099.h      |    0
 drivers/staging/{ => media}/dt3155v4l/Kconfig      |    0
 drivers/staging/{ => media}/dt3155v4l/Makefile     |    0
 drivers/staging/{ => media}/dt3155v4l/dt3155v4l.c  |    0
 drivers/staging/{ => media}/dt3155v4l/dt3155v4l.h  |    0
 drivers/staging/{ => media}/easycap/Kconfig        |    0
 drivers/staging/{ => media}/easycap/Makefile       |    0
 drivers/staging/{ => media}/easycap/README         |    0
 drivers/staging/{ => media}/easycap/easycap.h      |    0
 .../staging/{ => media}/easycap/easycap_ioctl.c    |    0
 drivers/staging/{ => media}/easycap/easycap_low.c  |    0
 drivers/staging/{ => media}/easycap/easycap_main.c |    0
 .../staging/{ => media}/easycap/easycap_settings.c |    0
 .../staging/{ => media}/easycap/easycap_sound.c    |    0
 .../staging/{ => media}/easycap/easycap_testcard.c |    0
 drivers/staging/{ => media}/go7007/Kconfig         |    0
 drivers/staging/{ => media}/go7007/Makefile        |    0
 drivers/staging/{ => media}/go7007/README          |    0
 drivers/staging/{ => media}/go7007/go7007-driver.c |    0
 drivers/staging/{ => media}/go7007/go7007-fw.c     |    0
 drivers/staging/{ => media}/go7007/go7007-i2c.c    |    0
 drivers/staging/{ => media}/go7007/go7007-priv.h   |    0
 drivers/staging/{ => media}/go7007/go7007-usb.c    |    0
 drivers/staging/{ => media}/go7007/go7007-v4l2.c   |    0
 drivers/staging/{ => media}/go7007/go7007.h        |    0
 drivers/staging/{ => media}/go7007/go7007.txt      |    0
 drivers/staging/{ => media}/go7007/s2250-board.c   |    0
 drivers/staging/{ => media}/go7007/s2250-loader.c  |    0
 drivers/staging/{ => media}/go7007/s2250-loader.h  |    0
 .../staging/{ => media}/go7007/saa7134-go7007.c    |    0
 drivers/staging/{ => media}/go7007/snd-go7007.c    |    0
 drivers/staging/{ => media}/go7007/wis-i2c.h       |    0
 drivers/staging/{ => media}/go7007/wis-ov7640.c    |    0
 drivers/staging/{ => media}/go7007/wis-saa7113.c   |    0
 drivers/staging/{ => media}/go7007/wis-saa7115.c   |    0
 .../staging/{ => media}/go7007/wis-sony-tuner.c    |    0
 drivers/staging/{ => media}/go7007/wis-tw2804.c    |    0
 drivers/staging/{ => media}/go7007/wis-tw9903.c    |    0
 drivers/staging/{ => media}/go7007/wis-uda1342.c   |    0
 drivers/staging/{ => media}/lirc/Kconfig           |    0
 drivers/staging/{ => media}/lirc/Makefile          |    0
 drivers/staging/{ => media}/lirc/TODO              |    0
 drivers/staging/{ => media}/lirc/TODO.lirc_zilog   |    0
 drivers/staging/{ => media}/lirc/lirc_bt829.c      |    0
 drivers/staging/{ => media}/lirc/lirc_ene0100.h    |    0
 .../staging/{ => media}/lirc/lirc_igorplugusb.c    |    0
 drivers/staging/{ => media}/lirc/lirc_imon.c       |    0
 drivers/staging/{ => media}/lirc/lirc_parallel.c   |    0
 drivers/staging/{ => media}/lirc/lirc_parallel.h   |    0
 drivers/staging/{ => media}/lirc/lirc_sasem.c      |    0
 drivers/staging/{ => media}/lirc/lirc_serial.c     |    0
 drivers/staging/{ => media}/lirc/lirc_sir.c        |    0
 drivers/staging/{ => media}/lirc/lirc_ttusbir.c    |    0
 drivers/staging/{ => media}/lirc/lirc_zilog.c      |    0
 drivers/staging/{ => media}/solo6x10/Kconfig       |    0
 drivers/staging/{ => media}/solo6x10/Makefile      |    0
 drivers/staging/{ => media}/solo6x10/TODO          |    0
 drivers/staging/{ => media}/solo6x10/core.c        |    0
 drivers/staging/{ => media}/solo6x10/disp.c        |    0
 drivers/staging/{ => media}/solo6x10/enc.c         |    0
 drivers/staging/{ => media}/solo6x10/g723.c        |    0
 drivers/staging/{ => media}/solo6x10/gpio.c        |    0
 drivers/staging/{ => media}/solo6x10/i2c.c         |    0
 drivers/staging/{ => media}/solo6x10/jpeg.h        |    0
 drivers/staging/{ => media}/solo6x10/offsets.h     |    0
 drivers/staging/{ => media}/solo6x10/osd-font.h    |    0
 drivers/staging/{ => media}/solo6x10/p2m.c         |    0
 drivers/staging/{ => media}/solo6x10/registers.h   |    0
 drivers/staging/{ => media}/solo6x10/solo6x10.h    |    0
 drivers/staging/{ => media}/solo6x10/tw28.c        |    0
 drivers/staging/{ => media}/solo6x10/tw28.h        |    0
 drivers/staging/{ => media}/solo6x10/v4l2-enc.c    |    0
 drivers/staging/{ => media}/solo6x10/v4l2.c        |    0
 include/linux/videodev2.h                          |   27 +
 include/media/ov772x.h                             |   26 +-
 include/media/s5k6aa.h                             |   51 +
 include/media/soc_camera.h                         |  104 +-
 include/media/soc_camera_platform.h                |    4 +-
 include/media/soc_mediabus.h                       |    2 +
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-subdev.h                        |    5 +-
 include/media/videobuf2-core.h                     |   50 +-
 216 files changed, 10316 insertions(+), 3785 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.c
 create mode 100644 drivers/media/dvb/dvb-usb/mxl111sf-demod.h
 rename drivers/{staging => media/video}/cx25821/Kconfig (100%)
 rename drivers/{staging => media/video}/cx25821/Makefile (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-alsa.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-biffuncs.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-cards.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-core.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-gpio.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-i2c.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-defines.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-sram.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.c (99%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821.h (99%)
 create mode 100644 drivers/media/video/s5k6aa.c
 delete mode 100644 drivers/staging/cx25821/README
 create mode 100644 drivers/staging/media/Kconfig
 create mode 100644 drivers/staging/media/Makefile
 create mode 100644 drivers/staging/media/as102/Kconfig
 create mode 100644 drivers/staging/media/as102/Makefile
 create mode 100644 drivers/staging/media/as102/as102_drv.c
 create mode 100644 drivers/staging/media/as102/as102_drv.h
 create mode 100644 drivers/staging/media/as102/as102_fe.c
 create mode 100644 drivers/staging/media/as102/as102_fw.c
 create mode 100644 drivers/staging/media/as102/as102_fw.h
 create mode 100644 drivers/staging/media/as102/as102_usb_drv.c
 create mode 100644 drivers/staging/media/as102/as102_usb_drv.h
 create mode 100644 drivers/staging/media/as102/as10x_cmd.c
 create mode 100644 drivers/staging/media/as102/as10x_cmd.h
 create mode 100644 drivers/staging/media/as102/as10x_cmd_cfg.c
 create mode 100644 drivers/staging/media/as102/as10x_cmd_stream.c
 create mode 100644 drivers/staging/media/as102/as10x_handle.h
 create mode 100644 drivers/staging/media/as102/as10x_types.h
 rename drivers/staging/{ => media}/cxd2099/Kconfig (100%)
 rename drivers/staging/{ => media}/cxd2099/Makefile (100%)
 rename drivers/staging/{ => media}/cxd2099/TODO (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.c (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.h (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Kconfig (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Makefile (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.c (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.h (100%)
 rename drivers/staging/{ => media}/easycap/Kconfig (100%)
 rename drivers/staging/{ => media}/easycap/Makefile (100%)
 rename drivers/staging/{ => media}/easycap/README (100%)
 rename drivers/staging/{ => media}/easycap/easycap.h (100%)
 rename drivers/staging/{ => media}/easycap/easycap_ioctl.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_low.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_main.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_settings.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_sound.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_testcard.c (100%)
 rename drivers/staging/{ => media}/go7007/Kconfig (100%)
 rename drivers/staging/{ => media}/go7007/Makefile (100%)
 rename drivers/staging/{ => media}/go7007/README (100%)
 rename drivers/staging/{ => media}/go7007/go7007-driver.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-fw.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-i2c.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-priv.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007-usb.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-v4l2.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007.txt (100%)
 rename drivers/staging/{ => media}/go7007/s2250-board.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.h (100%)
 rename drivers/staging/{ => media}/go7007/saa7134-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/snd-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-i2c.h (100%)
 rename drivers/staging/{ => media}/go7007/wis-ov7640.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7113.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7115.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-sony-tuner.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw2804.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw9903.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-uda1342.c (100%)
 rename drivers/staging/{ => media}/lirc/Kconfig (100%)
 rename drivers/staging/{ => media}/lirc/Makefile (100%)
 rename drivers/staging/{ => media}/lirc/TODO (100%)
 rename drivers/staging/{ => media}/lirc/TODO.lirc_zilog (100%)
 rename drivers/staging/{ => media}/lirc/lirc_bt829.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ene0100.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_igorplugusb.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_imon.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sasem.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_serial.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ttusbir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_zilog.c (100%)
 rename drivers/staging/{ => media}/solo6x10/Kconfig (100%)
 rename drivers/staging/{ => media}/solo6x10/Makefile (100%)
 rename drivers/staging/{ => media}/solo6x10/TODO (100%)
 rename drivers/staging/{ => media}/solo6x10/core.c (100%)
 rename drivers/staging/{ => media}/solo6x10/disp.c (100%)
 rename drivers/staging/{ => media}/solo6x10/enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/g723.c (100%)
 rename drivers/staging/{ => media}/solo6x10/gpio.c (100%)
 rename drivers/staging/{ => media}/solo6x10/i2c.c (100%)
 rename drivers/staging/{ => media}/solo6x10/jpeg.h (100%)
 rename drivers/staging/{ => media}/solo6x10/offsets.h (100%)
 rename drivers/staging/{ => media}/solo6x10/osd-font.h (100%)
 rename drivers/staging/{ => media}/solo6x10/p2m.c (100%)
 rename drivers/staging/{ => media}/solo6x10/registers.h (100%)
 rename drivers/staging/{ => media}/solo6x10/solo6x10.h (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.c (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.h (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2-enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2.c (100%)
 create mode 100644 include/media/s5k6aa.h

