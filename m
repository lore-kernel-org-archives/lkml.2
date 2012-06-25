Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2FYVrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2FYVrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:47:32 -0400
Message-ID: <4FE8DC6F.2020901@redhat.com>
Date: Mon, 25 Jun 2012 18:47:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.5-rc5] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a set of fixup patches, several of them are due to regressions.

Regards,
Mauro

Latest commit at the branch: 
099987f0aaf28771261b91a41240b9228f2e32b2 [media] smia: Fix compile failures
The following changes since commit 71006fb22b0f5a2045605b3887ee99a0e9adafe4:

  [media] saa7134-cards: Remove a PCI entry added by mistake (2012-05-21 12:48:44 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 099987f0aaf28771261b91a41240b9228f2e32b2:

  [media] smia: Fix compile failures (2012-06-18 19:52:05 -0300)

----------------------------------------------------------------
Alan Cox (1):
      [media] smia: Fix compile failures

Andrzej Hajda (2):
      [media] v4l/s5p-mfc: corrected encoder v4l control definitions
      [media] v4l/s5p-mfc: added image size align in VIDIOC_TRY_FMT

Antonio Ospite (1):
      [media] gspca_ov534: make AGC and AWB controls independent

Guennadi Liakhovetski (1):
      [media] Revert "[media] media: mx2_camera: Fix mbus format handling"

Hans Verkuil (15):
      [media] Fix vivi regression
      [media] Fix regression in ioctl numbering
      [media] Fix query/enum_dv_timings regression
      [media] V4L2 spec fix
      [media] saa7146_fops: remove unused variable
      [media] cx24110: fix compiler warning
      [media] vino: fix compiler warnings
      [media] v4l2-ioctl: set readbuffers to 2 in g_parm
      [media] v4l2-dev.c: fix g_parm regression in determine_valid_ioctls()
      [media] tuner-core: return the frequency range of the correct tuner
      [media] ivtv: fix support for big-endian systems
      [media] cx18: support big-endian systems
      [media] cx88: fix firmware load on big-endian systems
      [media] bw-qcam: driver and pixfmt documentation fixes
      [media]  Fix VIDIOC_DQEVENT docbook entry

Hans de Goede (10):
      [media] radio/si470x: Add support for the Axentia ALERT FM USB Receiver
      [media] snd_tea575x: Report correct frequency range for EU/US versus JA models
      [media] snd_tea575x: Make the module using snd_tea575x the fops owner
      [media] snd_tea575x: set_freq: update cached freq to the actual achieved frequency
      [media] bttv: Use btv->has_radio rather then the card info when registering the tuner
      [media] bttv: Remove unused needs_tvaudio card variable
      [media] bttv: The Hauppauge 61334 needs the msp3410 to do radio demodulation
      [media] gspca_pac7311: Correct number of controls
      [media] gscpa_sn9c20x: Move clustering of controls to after error checking
      [media] gspca-core: Fix buffers staying in queued state after a stream_off

Janne Huttunen (1):
      [media] cxd2820r: Fix an incorrect modulation type bitmask

Jean-Francois Moine (2):
      [media] gspca - ov534/ov534_9: Fix sccd_read/write errors
      [media] gspca - sonixj: Fix bad values of webcam 0458:7025

Kamil Debski (3):
      [media] s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      [media] s5p-mfc: Fix setting controls
      [media] s5p-fimc: Fix control creation function

Martin Blumenstingl (2):
      [media] em28xx: Add remote control support for Terratec's Cinergy HTC Stick HD
      [media] em28xx: Show a warning if the board does not support remote controls

Michael Krufky (2):
      [media] lg2160: fix off-by-one error in lg216x_write_regs
      [media] smsusb: add autodetection support for USB ID 2040:f5a0

Sachin Kamat (1):
      [media] s5p-mfc: Fix checkpatch error in s5p_mfc_shm.h file

Sakari Ailus (1):
      [media] v4l: Correct create_bufs documentation

Sasha Levin (1):
      [media] USB: Staging: media: lirc: initialize spinlocks before usage

Tomasz Moń (1):
      [media] v4l: mem2mem_testdev: Fix race conditions in driver

 Documentation/DocBook/media/v4l/pixfmt.xml         |    4 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +-
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    5 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    2 +-
 arch/arm/plat-mxc/include/mach/mx2_cam.h           |    2 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/media/common/saa7146_fops.c                |    5 --
 drivers/media/dvb/frontends/cx24110.c              |    4 +-
 drivers/media/dvb/frontends/cxd2820r_c.c           |    2 +-
 drivers/media/dvb/frontends/lg2160.c               |    2 +-
 drivers/media/dvb/siano/smsusb.c                   |    2 +
 drivers/media/radio/radio-maxiradio.c              |    2 +-
 drivers/media/radio/radio-sf16fmr2.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 +
 drivers/media/video/bt8xx/bttv-cards.c             |   84 ++------------------
 drivers/media/video/bt8xx/bttv-driver.c            |    5 ++
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |    1 +
 drivers/media/video/bw-qcam.c                      |   47 ++++++++---
 drivers/media/video/cx18/cx18-driver.c             |   10 +--
 drivers/media/video/cx18/cx18-driver.h             |    2 +-
 drivers/media/video/cx18/cx18-firmware.c           |    9 ++-
 drivers/media/video/cx18/cx18-mailbox.c            |   15 ++--
 drivers/media/video/cx88/cx88-blackbird.c          |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |    1 +
 drivers/media/video/em28xx/em28xx-input.c          |    2 +
 drivers/media/video/gspca/gspca.c                  |    4 +-
 drivers/media/video/gspca/ov534.c                  |   32 +-------
 drivers/media/video/gspca/ov534_9.c                |    1 +
 drivers/media/video/gspca/pac7311.c                |    2 +-
 drivers/media/video/gspca/sn9c20x.c                |   24 +++---
 drivers/media/video/gspca/sonixj.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   18 ++---
 drivers/media/video/ivtv/ivtv-driver.h             |    2 +-
 drivers/media/video/mem2mem_testdev.c              |   50 ++++++------
 drivers/media/video/mx2_camera.c                   |   52 ++----------
 drivers/media/video/s5p-fimc/fimc-core.c           |    2 +-
 drivers/media/video/s5p-mfc/regs-mfc.h             |    5 ++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |   12 +--
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h          |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h          |    3 +-
 drivers/media/video/smiapp/Kconfig                 |    2 +-
 drivers/media/video/smiapp/smiapp-core.c           |    1 +
 drivers/media/video/tuner-core.c                   |    2 +-
 drivers/media/video/v4l2-dev.c                     |    4 +-
 drivers/media/video/v4l2-ioctl.c                   |    1 +
 drivers/media/video/vino.c                         |    4 +-
 drivers/media/video/vivi.c                         |    6 +-
 drivers/staging/media/lirc/lirc_serial.c           |    6 ++
 include/linux/videodev2.h                          |    6 +-
 include/sound/tea575x-tuner.h                      |    3 +-
 sound/i2c/other/tea575x-tuner.c                    |   21 +++--
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/fm801.c                                  |    4 +-
 56 files changed, 220 insertions(+), 278 deletions(-)

