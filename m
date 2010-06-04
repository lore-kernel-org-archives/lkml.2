Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0FDRYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0FDRYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:24:47 -0400
Message-ID: <4C0936C1.1050605@redhat.com>
Date: Fri, 04 Jun 2010 14:24:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.35] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:

  Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

Abylay Ospan (1):
      V4L/DVB: cx23885: Check register errors

Andy Walls (1):
      V4L/DVB: cx18, cx23885, v4l2 doc, MAINTAINERS: Update Andy Walls' email address

Ang Way Chuang (1):
      V4L/DVB: dvb-core: Fix ULE decapsulation bug

Ben Hutchings (4):
      V4L/DVB: dw2102: Select tda10023 frontend, not tda10021
      V4L/DVB: budget: Select correct frontends
      V4L/DVB: dib0700: Select dib0090 frontend
      V4L/DVB: m920x: Select simple tuner

Dan Carpenter (3):
      V4L/DVB: em28xx: remove unneeded null checks
      V4L/DVB: video/saa7134: remove duplicate break
      V4L/DVB: video/saa7134: change dprintk() to i2cdprintk()

Dmitri Belimov (1):
      V4L/DVB: tm6000, reset I2C bus function

Guy Martin (2):
      V4L/DVB: TT CT-3650 DVB-C support
      V4L/DVB: stv6110x: Fix kernel null pointer deref

Hans Verkuil (30):
      V4L/DVB: bw-qcam: convert to V4L2
      V4L/DVB: c-qcam: convert to V4L2
      V4L/DVB: V4L2 Spec: Improve the VIDIOC_QUERY_DV_PRESET description
      V4L/DVB: saa7115: add s_mbus_fmt op
      V4L/DVB: cx25840: add support for s_mbus_fmt
      V4L/DVB: saa717x: add support for s_mbus_fmt
      V4L/DVB: ivtv: convert to use s_mbus_fmt
      V4L/DVB: cx18: add s_mbus_fmt support
      V4L/DVB: cx18: remove old g/s_fmt from the cx18_av subdev
      V4L/DVB: saa7127: remove obsolete g_fmt support
      V4L/DVB: saa717x: remove obsolete s_fmt op
      V4L/DVB: v4l2-mediabus.h: add two helper functions
      V4L/DVB: saa6752hs: add g/s_mbus_fmt support
      V4L/DVB: saa7134: convert to use the new mbus API
      V4L/DVB: pvrusb2: convert to s_mbus_fmt
      V4L/DVB: cx23885: convert to s_mbus_fmt
      V4L/DVB: cx231xx: convert to s_mbus_fmt
      V4L/DVB: cx24850: remove obsolete g/s_fmt ops
      V4L/DVB: saa7115: remove obsolete g/s_fmt ops
      V4L/DVB: v4l2-mediabus.h: added V4L2_MBUS_FMT_SGRBG8_1X8
      V4L/DVB: mt9v011: add enum/try/s_mbus_fmt support
      V4L/DVB: tvp5150: remove obsolete g/s_fmt ops
      V4L/DVB: au8522_decoder: g/s_fmt doesn't do anything: remove
      V4L/DVB: v4l2-subdev.h: fix enum_mbus_fmt prototype
      V4L/DVB: tvp514x: do NOT change the std as a side effect
      V4L/DVB: tvp514x: make std_list const
      V4L/DVB: tvp514x: there is only one supported format, so simplify the code
      V4L/DVB: tvp514x: add missing newlines
      V4L/DVB: tvp514x: remove obsolete fmt_list
      V4L/DVB: tvp514x: simplify try/g/s_fmt handling

Hermann Gausterer (1):
      V4L/DVB: Technotrend S2-3200 ships with a TT 1500 remote

Herton Ronaldo Krzesinski (2):
      V4L/DVB: saa7134: add support for Avermedia M733A
      V4L/DVB: saa7134: add RM-K6 remote control support for Avermedia M135A

Huang Weiyi (1):
      V4L/DVB: ngene: remove unused #include <linux/version.h>

Ian Armstrong (4):
      V4L/DVB: cx2341x: Report correct temporal setting for log-status
      V4L/DVB: ivtvfb : Module load / unload fixes
      V4L/DVB: ivtv: Avoid accidental video standard change
      V4L/DVB: ivtv: Timing tweaks and code re-order to try and improve stability

Igor M. Liplianin (1):
      V4L/DVB: Bug fix: make IR work again for dm1105

Jarod Wilson (2):
      V4L/DVB: IR/imon: clean up usage of bools
      V4L/DVB: IR/imon: add auto-config for 0xffdc rf device

Jean Delvare (1):
      V4L/DVB: FusionHDTV: Use quick reads for I2C IR device probing

Jean-François Moine (2):
      V4L/DVB: gspca - sonixb: Have 0c45:602e handled by sonixb instead of sn9c102
      V4L/DVB: gspca - sonixj: Add information about some potential JPEG webcams

Julia Lawall (2):
      V4L/DVB: drivers/media: Use kzalloc
      V4L/DVB: drivers/media: Eliminate a NULL pointer dereference

Mike Isely (7):
      V4L/DVB: pvrusb2: Fix Gotview hardware support
      V4L/DVB: pvrusb2: Avoid using stack allocated buffers when performing USB I/O
      V4L/DVB: pvrusb2: New feature to mark specific hardware support as experimental
      V4L/DVB: pvrusb2: Fix kernel oops at device unregistration
      V4L/DVB: pvrusb2: Fix USB parent device reference count
      V4L/DVB: pvrusb2: Fix minor internal array allocation
      V4L/DVB: pvrusb2: Fix kernel oops on device tear-down

Oliver Endriss (6):
      V4L/DVB: ngene: Support new device 'Digital Devices DuoFlex S2 miniPCIe'
      V4L/DVB: ngene: Do not call demuxer with interrupts disabled
      V4L/DVB: ngene: Implement support for MSI
      V4L/DVB: ngene: Make command timeout workaround configurable
      V4L/DVB: ngene: MSI cleanup
      V4L/DVB: ngene: Remove debug message

Prarit Bhargava (1):
      V4L/DVB: Add notification to cxusb_dualdig4_rev2_frontend_attach() error 	handling

Randy Dunlap (3):
      V4L/DVB: [-next] IR: fix ir-nec-decoder build, select BITREVERSE
      V4L/DVB: ak881x needs slab.h
      V4L/DVB: media/IR: nec-decoder needs to select BITREV

Stefan Ringel (10):
      V4L/DVB: tm6000: add extension module support
      V4L/DVB: tm6000: Remove an extra ; symbol
      V4L/DVB: tm6000: bugfix incorrect size
      V4L/DVB: tm6000: add vbi message inside the type switch
      V4L/DVB: tm6000: bugfix video image
      V4L/DVB: tm6000: bugfix stabilizing urb data
      V4L/DVB: tm6000: Add control to the power led
      V4L/DVB: tm6000: Properly select the tuners
      V4L/DVB: tm6000: set variable dev_mode in function tm6000_start_stream
      V4L/DVB: tm6000: add DVB support for tuner xc5000

Warren Bosworth Focke (1):
      V4L/DVB: gspca - sonixj: Add webcam 0c45:60ce

 Documentation/DocBook/v4l/v4l2.xml                 |    2 +-
 .../DocBook/v4l/vidioc-query-dv-preset.xml         |    6 +-
 Documentation/video4linux/CARDLIST.saa7134         |    5 +-
 Documentation/video4linux/gspca.txt                |    1 +
 MAINTAINERS                                        |    4 +-
 drivers/media/IR/Kconfig                           |    2 +
 drivers/media/IR/imon.c                            |   75 ++-
 drivers/media/IR/ir-keytable.c                     |   17 +-
 drivers/media/IR/ir-sysfs.c                        |    7 +-
 drivers/media/IR/keymaps/Makefile                  |    3 +-
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |   90 ---
 drivers/media/IR/keymaps/rc-avermedia-m135a.c      |  147 ++++
 .../media/IR/keymaps/rc-avermedia-m733a-rm-k6.c    |   95 +++
 drivers/media/dvb/dm1105/dm1105.c                  |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   12 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    4 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    1 +
 drivers/media/dvb/dvb-usb/ttusb2.c                 |   95 +++-
 drivers/media/dvb/firewire/firedtv-1394.c          |    2 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |   26 -
 drivers/media/dvb/frontends/ds3000.c               |    5 +-
 drivers/media/dvb/frontends/stv6110x.c             |    5 +-
 drivers/media/dvb/ngene/ngene-cards.c              |   15 +
 drivers/media/dvb/ngene/ngene-core.c               |   80 ++-
 drivers/media/dvb/ngene/ngene-dvb.c                |   15 +-
 drivers/media/dvb/ngene/ngene-i2c.c                |    1 -
 drivers/media/dvb/ngene/ngene.h                    |    3 +
 drivers/media/dvb/ttpci/Kconfig                    |    5 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    1 +
 drivers/media/video/Kconfig                        |    4 +-
 drivers/media/video/ak881x.c                       |    3 +-
 drivers/media/video/bw-qcam.c                      |  759 +++++++++++---------
 drivers/media/video/bw-qcam.h                      |   69 --
 drivers/media/video/c-qcam.c                       |  634 +++++++++--------
 drivers/media/video/cx18/cx18-alsa-main.c          |    2 +-
 drivers/media/video/cx18/cx18-alsa-mixer.c         |    2 +-
 drivers/media/video/cx18/cx18-alsa-mixer.h         |    2 +-
 drivers/media/video/cx18/cx18-alsa-pcm.c           |    2 +-
 drivers/media/video/cx18/cx18-alsa-pcm.h           |    2 +-
 drivers/media/video/cx18/cx18-alsa.h               |    2 +-
 drivers/media/video/cx18/cx18-av-audio.c           |    2 +-
 drivers/media/video/cx18/cx18-av-core.c            |  127 ++--
 drivers/media/video/cx18/cx18-av-core.h            |    2 +-
 drivers/media/video/cx18/cx18-av-firmware.c        |    2 +-
 drivers/media/video/cx18/cx18-cards.c              |    2 +-
 drivers/media/video/cx18/cx18-cards.h              |    2 +-
 drivers/media/video/cx18/cx18-controls.c           |   11 +-
 drivers/media/video/cx18/cx18-driver.c             |    2 +-
 drivers/media/video/cx18/cx18-driver.h             |    2 +-
 drivers/media/video/cx18/cx18-dvb.c                |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |    2 +-
 drivers/media/video/cx18/cx18-firmware.c           |    2 +-
 drivers/media/video/cx18/cx18-gpio.c               |    2 +-
 drivers/media/video/cx18/cx18-gpio.h               |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx18/cx18-io.c                 |    2 +-
 drivers/media/video/cx18/cx18-io.h                 |    4 +-
 drivers/media/video/cx18/cx18-ioctl.c              |   10 +-
 drivers/media/video/cx18/cx18-ioctl.h              |    2 +-
 drivers/media/video/cx18/cx18-irq.c                |    2 +-
 drivers/media/video/cx18/cx18-irq.h                |    2 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    2 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    2 +-
 drivers/media/video/cx18/cx18-queue.c              |    2 +-
 drivers/media/video/cx18/cx18-queue.h              |    2 +-
 drivers/media/video/cx18/cx18-scb.c                |    2 +-
 drivers/media/video/cx18/cx18-scb.h                |    2 +-
 drivers/media/video/cx18/cx18-streams.c            |    2 +-
 drivers/media/video/cx18/cx18-streams.h            |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    5 +-
 drivers/media/video/cx2341x.c                      |    6 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +
 drivers/media/video/cx23885/cx23885-i2c.c          |   12 +-
 drivers/media/video/cx23885/cx23885-input.c        |    2 +-
 drivers/media/video/cx23885/cx23885-input.h        |    2 +-
 drivers/media/video/cx23885/cx23885-ioctl.c        |    2 +-
 drivers/media/video/cx23885/cx23885-ioctl.h        |    2 +-
 drivers/media/video/cx23885/cx23885-ir.c           |    2 +-
 drivers/media/video/cx23885/cx23885-ir.h           |    2 +-
 drivers/media/video/cx23885/cx23885-video.c        |    5 +-
 drivers/media/video/cx23885/cx23888-ir.c           |    2 +-
 drivers/media/video/cx23885/cx23888-ir.h           |    2 +-
 drivers/media/video/cx25840/cx25840-core.c         |   99 ++--
 drivers/media/video/cx88/cx88-i2c.c                |   16 +-
 drivers/media/video/em28xx/em28xx-core.c           |    7 +-
 drivers/media/video/gspca/sonixb.c                 |    2 -
 drivers/media/video/gspca/sonixj.c                 |    5 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/media/video/ivtv/ivtv-controls.c           |   10 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   11 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    6 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   23 +-
 drivers/media/video/ivtv/ivtvfb.c                  |   14 +-
 drivers/media/video/mt9m001.c                      |    4 +-
 drivers/media/video/mt9m111.c                      |    4 +-
 drivers/media/video/mt9t031.c                      |    2 +-
 drivers/media/video/mt9t112.c                      |    4 +-
 drivers/media/video/mt9v011.c                      |   37 +-
 drivers/media/video/mt9v022.c                      |    4 +-
 drivers/media/video/mx3_camera.c                   |    4 +-
 drivers/media/video/omap/omap_vout.c               |    3 +-
 drivers/media/video/ov772x.c                       |    4 +-
 drivers/media/video/ov9640.c                       |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    1 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |    5 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   37 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   13 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   15 +-
 drivers/media/video/pxa_camera.c                   |    4 +-
 drivers/media/video/rj54n1cb0c.c                   |    4 +-
 drivers/media/video/saa7115.c                      |   19 +-
 drivers/media/video/saa7127.c                      |    8 -
 drivers/media/video/saa7134/saa6752hs.c            |   46 +-
 drivers/media/video/saa7134/saa7134-cards.c        |   55 ++
 drivers/media/video/saa7134/saa7134-empress.c      |    9 +-
 drivers/media/video/saa7134/saa7134-input.c        |   18 +-
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/saa717x.c                      |   38 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |    4 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    2 +-
 drivers/media/video/soc_camera.c                   |    3 +-
 drivers/media/video/soc_camera_platform.c          |    2 +-
 drivers/media/video/tvp514x.c                      |  223 +-----
 drivers/media/video/tvp5150.c                      |   20 -
 drivers/media/video/tw9910.c                       |    2 +-
 drivers/media/video/usbvision/usbvision-video.c    |    3 +-
 drivers/staging/tm6000/Kconfig                     |    3 +-
 drivers/staging/tm6000/tm6000-alsa.c               |   25 +-
 drivers/staging/tm6000/tm6000-cards.c              |   45 +-
 drivers/staging/tm6000/tm6000-core.c               |  121 ++++
 drivers/staging/tm6000/tm6000-dvb.c                |   74 ++-
 drivers/staging/tm6000/tm6000-video.c              |  104 ++--
 drivers/staging/tm6000/tm6000.h                    |   25 +-
 include/media/rc-map.h                             |    3 +-
 include/media/soc_camera.h                         |    2 +-
 include/media/v4l2-mediabus.h                      |   21 +
 include/media/v4l2-subdev.h                        |    2 +-
 139 files changed, 2104 insertions(+), 1581 deletions(-)
 delete mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c
 delete mode 100644 drivers/media/video/bw-qcam.h

