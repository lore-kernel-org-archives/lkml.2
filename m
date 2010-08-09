Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab0HIEh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 00:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0HIEhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:37:25 -0400
Date: Mon, 9 Aug 2010 01:37:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.36] drivers/media updates
Message-ID: <20100809013758.00cd03e9@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

It contains some patches that were waiting for updates at some ARM trees, several 
improvements at Remote Controllers (including the migration of some drivers from
staging), a new driver for the camera found on Samsung cellphones, and some other
misc improvements, fixes and cleanups.

Thanks,
Mauro
---

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-08-08 10:10:11 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andy Shevchenko (2):
      V4L/DVB: drivers: usbvideo: remove custom implementation of hex_to_bin()
      V4L/DVB: media: video: pvrusb2: remove custom hex_to_bin()

Andy Walls (20):
      V4L/DVB: cx25840: Make cx25840 i2c register read transactions atomic
      V4L/DVB: cx23885: Add correct detection of the HVR-1250 model 79501
      V4L/DVB: cx23885: Add a VIDIOC_LOG_STATUS ioctl function for analog video devices
      V4L/DVB: v4l2_subdev: Add s_io_pin_config to v4l2_subdev_core_ops
      V4L/DVB: cx25840: Add s_io_pin_config core subdev ops for the CX2388[578]
      V4L/DVB: v4l2_subdev, cx23885: Differentiate IR carrier sense and I/O pin inversion
      V4L/DVB: cx23885: For CX23888 IR, configure the IO pin mux IR pins explcitly
      V4L/DVB: v4l2_subdev: Move interrupt_service_routine ptr to v4l2_subdev_core_ops
      V4L/DVB: cx25840: Add support for CX2388[57] A/V core integrated IR controllers
      V4L/DVB: cx23885: Add a v4l2_subdev group id for the CX2388[578] integrated AV core
      V4L/DVB: cx23885: Add preliminary IR Rx support for the HVR-1250 and TeVii S470
      V4L/DVB: cx23885: Protect PCI interrupt mask manipulations with a spinlock
      V4L/DVB: cx23885: Move AV Core irq handling to a work handler
      V4L/DVB: cx23885: Require user to explicitly enable CX2388[57] IR via module param
      V4L/DVB: cx23885: Change Kconfig dependencies to new IR_CORE functions
      V4L/DVB: cx23885, cx25840: Report IR max pulse width regardless of mod/demod use
      V4L/DVB: cx23885, cx25840: Report the actual length of an IR Rx timeout event
      V4L/DVB: cx23885, cx25840: Change IR measurment records to use struct ir_raw_event
      V4L/DVB: v4l2_subdev: Get rid of now unused IR pulse width defines
      V4L/DVB: IR keymap: Add print button for HP OEM version of MCE remote

Arnuschky (1):
      V4L/DVB: Report supported QAM modes on bt8xx

Dan Carpenter (1):
      V4L/DVB: media: ir-keytable: null dereference in debug code

Guennadi Liakhovetski (2):
      V4L/DVB: soc-camera: prohibit S_CROP, if internal G_CROP has failed
      V4L/DVB: V4L: do not autoselect components on embedded systems

Hans Verkuil (15):
      V4L/DVB: v4l2: Add new control handling framework
      V4L/DVB: v4l2-ctrls: reorder 'case' statements to match order in header
      V4L/DVB: Documentation: add v4l2-controls.txt documenting the new controls API
      V4L/DVB: v4l2: hook up the new control framework into the core framework
      V4L/DVB: saa7115: convert to the new control framework
      V4L/DVB: msp3400: convert to the new control framework
      V4L/DVB: saa717x: convert to the new control framework
      V4L/DVB: cx25840/ivtv: replace ugly priv control with s_config
      V4L/DVB: cx25840: convert to the new control framework
      V4L/DVB: cx2341x: convert to the control framework
      V4L/DVB: wm8775: convert to the new control framework
      V4L/DVB: cs53l32a: convert to new control framework
      V4L/DVB: wm8739: convert to the new control framework
      V4L/DVB: ivtv: convert gpio subdev to new control framework
      V4L/DVB: ivtv: convert to the new control framework

Janne Grunau (1):
      V4L/DVB: staging/lirc: fix Kconfig dependencies

Jarod Wilson (7):
      V4L/DVB: IR/imon: remove incorrect calls to input_free_device
      V4L/DVB: IR/imon: remove bad ir_input_dev use
      V4L/DVB: IR/mceusb: remove bad ir_input_dev use
      V4L/DVB: staging/lirc: fix non-CONFIG_MODULES build horkage
      V4L/DVB: IR/mceusb: less generic callback name and remove cruft
      V4L/DVB: staging/lirc: port lirc_streamzap to ir-core
      V4L/DVB: IR: put newly ported streamzap driver in proper home

Jean Delvare (3):
      V4L/DVB: cx23885: Return -ENXIO on slave nack
      V4L/DVB: cx23885: Check for slave nack on all transactions
      V4L/DVB: cx23885: i2c_wait_done returns 0 or 1, don't check for < 0 return value

Jean-François Moine (18):
      V4L/DVB: gspca - sonixj / sq930x / t613: Remove unused variable in struct sd
      V4L/DVB: gspca - main: Version change
      V4L/DVB: gspca - sq930x: Bad init sequence for sensor mt9v111
      V4L/DVB: gspca - sq930x: Change the gain value for Micron sensors
      V4L/DVB: gspca - sq930x: Change the default values of gain and exposure
      V4L/DVB: gspca - sq930x: Change image format to Bayer mode
      V4L/DVB: gspca - sq930x: Change the horizontal blanking of sensor mt9v111
      V4L/DVB: gspca - sq930x: Cleanup source, add comments
      V4L/DVB: gspca - vc032x: Add more controls for poxxxx
      V4L/DVB: gspca - vc032x: Do sensor probe at resume time
      V4L/DVB: gspca - vc032x: Force main register write at probe time (poxxxx)
      V4L/DVB: gspca - main: Fix a crash in gspca_frame_add()
      V4L/DVB: gspca - zc3xx: Cleanup source
      V4L/DVB: gspca - zc3xx: Check the USB exchanges
      V4L/DVB: gspca - zc3xx: Do the sensor probe at resume time
      V4L/DVB: gspca - zc3xx: Possible use of the highest alternate setting
      V4L/DVB: gspca - zc3xx: Add the light frequency control for sensor hv7131r
      V4L/DVB: gspca - zc3xx: Redefine the exchanges of sensor mt9v111 (mi0360soc)

Kulikov Vasiliy (1):
      V4L/DVB: dvb: siano: free spinlock before schedule()

Laurent Pinchart (2):
      V4L/DVB: uvcvideo: Drop corrupted compressed frames
      V4L/DVB: uvcvideo: Add support for Miricle 307K thermal webcam

Mauro Carvalho Chehab (1):
      V4L/DVB: v4l2-ctrls: Whitespace cleanups

Maxim Levitsky (13):
      V4L/DVB: IR: Kconfig fixes
      V4L/DVB: IR: minor fixes
      V4L/DVB: IR: replace spinlock with mutex
      V4L/DVB: IR: replace workqueue with kthread
      V4L/DVB: IR: JVC: make repeat work
      V4L/DVB: IR: nec decoder: fix repeat
      V4L/DVB: IR: NECX: support repeat
      V4L/DVB: IR: Allow not to compile keymaps in
      V4L/DVB: IR: add helper function for hardware with small o/b buffer
      V4L/DVB: IR: extend interfaces to support more device settings
      V4L/DVB: IR: report unknown scancodes the in-kernel decoders found
      V4L/DVB: STAGING: remove lirc_ene0100 driver
      V4L/DVB: IR: Port ene driver to new IR subsystem and enable it

Michael Grzeschik (3):
      V4L/DVB: mx2_camera: fix for list bufnum in frame_done_emma
      V4L/DVB: mx2_camera: add rising edge for pixclock
      V4L/DVB: mt9m111: init chip after read CHIP_VERSION

Pawel Osciak (1):
      V4L/DVB: v4l: s5p-fimc: Fix coding style issues

Philipp Wiesner (1):
      V4L/DVB: mt9m111: Added indication that MT9M131 is supported by this driver

Rajashekhara, Sudhakar (1):
      V4L/DVB: tvp7002: fix write to H-PLL Feedback Divider LSB register

Sylwester Nawrocki (1):
      V4L/DVB: v4l: Add driver for Samsung S5P SoC video postprocessor

 .../DocBook/v4l/lirc_device_interface.xml          |   16 +
 Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |   78 +
 Documentation/video4linux/v4l2-controls.txt        |  648 +++++++
 MAINTAINERS                                        |    6 +
 drivers/media/IR/Kconfig                           |   36 +-
 drivers/media/IR/Makefile                          |    2 +
 drivers/media/IR/ene_ir.c                          | 1023 +++++++++++
 drivers/media/IR/ene_ir.h                          |  235 +++
 drivers/media/IR/imon.c                            |   20 +-
 drivers/media/IR/ir-core-priv.h                    |   13 +-
 drivers/media/IR/ir-jvc-decoder.c                  |   14 +-
 drivers/media/IR/ir-keytable.c                     |   13 +-
 drivers/media/IR/ir-lirc-codec.c                   |  124 ++-
 drivers/media/IR/ir-nec-decoder.c                  |   25 +-
 drivers/media/IR/ir-raw-event.c                    |  159 ++-
 drivers/media/IR/ir-sysfs.c                        |    2 +
 drivers/media/IR/keymaps/Makefile                  |    2 +-
 drivers/media/IR/keymaps/rc-empty.c                |   44 -
 drivers/media/IR/keymaps/rc-rc5-streamzap.c        |   81 +
 drivers/media/IR/keymaps/rc-rc6-mce.c              |    2 +
 drivers/media/IR/mceusb.c                          |   21 +-
 drivers/media/IR/rc-map.c                          |   23 +
 drivers/media/IR/streamzap.c                       |  741 ++++++++
 drivers/media/common/tuners/Kconfig                |    2 +-
 drivers/media/dvb/bt8xx/dst.c                      |   10 +-
 drivers/media/dvb/frontends/Kconfig                |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    6 +-
 drivers/media/video/Kconfig                        |   16 +-
 drivers/media/video/Makefile                       |    3 +-
 drivers/media/video/cs53l32a.c                     |  107 +-
 drivers/media/video/cx2341x.c                      |  747 +++++++--
 drivers/media/video/cx23885/Kconfig                |    2 +-
 drivers/media/video/cx23885/Makefile               |    5 +-
 drivers/media/video/cx23885/cx23885-av.c           |   35 +
 drivers/media/video/cx23885/cx23885-av.h           |   27 +
 drivers/media/video/cx23885/cx23885-cards.c        |  114 ++-
 drivers/media/video/cx23885/cx23885-core.c         |  124 ++-
 drivers/media/video/cx23885/cx23885-i2c.c          |   27 +-
 drivers/media/video/cx23885/cx23885-input.c        |   72 +-
 drivers/media/video/cx23885/cx23885-ir.c           |   24 +-
 drivers/media/video/cx23885/cx23885-reg.h          |    1 +
 drivers/media/video/cx23885/cx23885-vbi.c          |    2 +-
 drivers/media/video/cx23885/cx23885-video.c        |   23 +-
 drivers/media/video/cx23885/cx23885.h              |    9 +-
 drivers/media/video/cx23885/cx23888-ir.c           |  142 +-
 drivers/media/video/cx25840/Makefile               |    2 +-
 drivers/media/video/cx25840/cx25840-audio.c        |  144 +--
 drivers/media/video/cx25840/cx25840-core.c         |  540 +++++--
 drivers/media/video/cx25840/cx25840-core.h         |   52 +-
 drivers/media/video/cx25840/cx25840-ir.c           | 1279 ++++++++++++++
 drivers/media/video/gspca/gspca.c                  |   21 +-
 drivers/media/video/gspca/sonixj.c                 |   10 +-
 drivers/media/video/gspca/sq930x.c                 |  347 +---
 drivers/media/video/gspca/t613.c                   |    4 +-
 drivers/media/video/gspca/vc032x.c                 |  360 ++++-
 drivers/media/video/gspca/zc3xx.c                  | 1715 +++++++++----------
 drivers/media/video/ivtv/ivtv-controls.c           |  276 +---
 drivers/media/video/ivtv/ivtv-controls.h           |    6 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   26 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    4 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   23 +-
 drivers/media/video/ivtv/ivtv-firmware.c           |    6 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |   77 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    7 +
 drivers/media/video/ivtv/ivtv-ioctl.c              |   31 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   24 +-
 drivers/media/video/msp3400-driver.c               |  248 +--
 drivers/media/video/msp3400-driver.h               |   18 +-
 drivers/media/video/msp3400-kthreads.c             |   16 +-
 drivers/media/video/mt9m111.c                      |   40 +-
 drivers/media/video/mx2_camera.c                   |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |   14 +-
 drivers/media/video/s5p-fimc/Makefile              |    3 +
 drivers/media/video/s5p-fimc/fimc-core.c           | 1586 +++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-core.h           |  471 +++++
 drivers/media/video/s5p-fimc/fimc-reg.c            |  527 ++++++
 drivers/media/video/s5p-fimc/regs-fimc.h           |  293 +++
 drivers/media/video/saa7115.c                      |  183 +--
 drivers/media/video/saa717x.c                      |  323 +---
 drivers/media/video/soc_camera.c                   |    9 +-
 drivers/media/video/tvp7002.c                      |   10 +-
 drivers/media/video/usbvideo/usbvideo.c            |   12 +-
 drivers/media/video/uvc/uvc_driver.c               |    9 +
 drivers/media/video/uvc/uvc_queue.c                |   13 +-
 drivers/media/video/uvc/uvc_video.c                |   19 +-
 drivers/media/video/uvc/uvcvideo.h                 |    5 +-
 drivers/media/video/v4l2-common.c                  |  479 +-----
 drivers/media/video/v4l2-ctrls.c                   | 1851 ++++++++++++++++++++
 drivers/media/video/v4l2-dev.c                     |    8 +-
 drivers/media/video/v4l2-device.c                  |    7 +
 drivers/media/video/v4l2-ioctl.c                   |   46 +-
 drivers/media/video/wm8739.c                       |  179 +--
 drivers/media/video/wm8775.c                       |   79 +-
 drivers/staging/lirc/Kconfig                       |   29 +-
 drivers/staging/lirc/Makefile                      |    2 -
 drivers/staging/lirc/lirc_ene0100.c                |  646 -------
 drivers/staging/lirc/lirc_it87.c                   |    9 +-
 drivers/staging/lirc/lirc_parallel.c               |    4 +-
 drivers/staging/lirc/lirc_streamzap.c              |  821 ---------
 include/linux/videodev2.h                          |    1 +
 include/media/cx2341x.h                            |   97 +
 include/media/cx25840.h                            |   87 +
 include/media/ir-core.h                            |   41 +-
 include/media/lirc.h                               |    5 +-
 include/media/rc-map.h                             |    1 +
 include/media/v4l2-ctrls.h                         |  460 +++++
 include/media/v4l2-dev.h                           |    4 +
 include/media/v4l2-device.h                        |    4 +
 include/media/v4l2-subdev.h                        |   54 +-
 109 files changed, 13451 insertions(+), 5048 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-controls.txt
 create mode 100644 drivers/media/IR/ene_ir.c
 create mode 100644 drivers/media/IR/ene_ir.h
 delete mode 100644 drivers/media/IR/keymaps/rc-empty.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-streamzap.c
 create mode 100644 drivers/media/IR/streamzap.c
 create mode 100644 drivers/media/video/cx23885/cx23885-av.c
 create mode 100644 drivers/media/video/cx23885/cx23885-av.h
 create mode 100644 drivers/media/video/cx25840/cx25840-ir.c
 create mode 100644 drivers/media/video/s5p-fimc/Makefile
 create mode 100644 drivers/media/video/s5p-fimc/fimc-core.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-core.h
 create mode 100644 drivers/media/video/s5p-fimc/fimc-reg.c
 create mode 100644 drivers/media/video/s5p-fimc/regs-fimc.h
 create mode 100644 drivers/media/video/v4l2-ctrls.c
 delete mode 100644 drivers/staging/lirc/lirc_ene0100.c
 delete mode 100644 drivers/staging/lirc/lirc_streamzap.c
 create mode 100644 include/media/v4l2-ctrls.h

