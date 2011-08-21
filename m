Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1HUW6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:58:03 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:40446 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110Ab1HUW57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:57:59 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] [media] Logging cleanups
Date: Sun, 21 Aug 2011 15:56:43 -0700
Message-Id: <cover.1313966088.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First block of logging message cleanups for drivers/media.

Joe Perches (14):
  [media] saa7146: Use current logging styles
  [media] rc-core.h: Surround macro with do {} while (0)
  [media] ene_ir: Use current logging styles
  [media] winbond-cir: Use current logging styles
  [media] bt8xx: Use current logging styles
  [media] cx18: Use current logging styles
  [media] et61x251: Use current logging styles
  [media] gl860: Use current logging styles
  [media] m5602: Use current logging styles
  [media] finepix: Use current logging styles
  [media] pac207: Use current logging styles
  [media] sn9c20x: Use current logging styles
  [media] t613: Use current logging styles
  [media] gspca: Use current logging styles

 drivers/media/common/saa7146_core.c                |   74 +++---
 drivers/media/common/saa7146_fops.c                |  118 +++++----
 drivers/media/common/saa7146_hlp.c                 |   14 +-
 drivers/media/common/saa7146_i2c.c                 |   60 ++--
 drivers/media/common/saa7146_vbi.c                 |   48 ++--
 drivers/media/common/saa7146_video.c               |  171 ++++++------
 drivers/media/dvb/ttpci/av7110_v4l.c               |   32 ++-
 drivers/media/dvb/ttpci/budget-av.c                |   42 ++--
 drivers/media/rc/ene_ir.c                          |   73 +++---
 drivers/media/rc/ene_ir.h                          |   19 +-
 drivers/media/rc/winbond-cir.c                     |    6 +-
 drivers/media/video/bt8xx/bttv-cards.c             |  242 ++++++++---------
 drivers/media/video/bt8xx/bttv-driver.c            |  294 ++++++++++----------
 drivers/media/video/bt8xx/bttv-gpio.c              |    4 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |   56 ++--
 drivers/media/video/bt8xx/bttv-input.c             |   37 ++--
 drivers/media/video/bt8xx/bttv-risc.c              |   25 +-
 drivers/media/video/bt8xx/bttv-vbi.c               |    9 +-
 drivers/media/video/bt8xx/bttvp.h                  |   18 +-
 drivers/media/video/cx18/cx18-alsa-main.c          |   26 +-
 drivers/media/video/cx18/cx18-alsa-mixer.c         |    2 +
 drivers/media/video/cx18/cx18-alsa-pcm.c           |   12 +-
 drivers/media/video/cx18/cx18-alsa.h               |   32 +-
 drivers/media/video/cx18/cx18-audio.c              |    2 +
 drivers/media/video/cx18/cx18-av-audio.c           |    2 +
 drivers/media/video/cx18/cx18-av-core.c            |    2 +
 drivers/media/video/cx18/cx18-av-firmware.c        |    2 +
 drivers/media/video/cx18/cx18-av-vbi.c             |    1 +
 drivers/media/video/cx18/cx18-controls.c           |    3 +
 drivers/media/video/cx18/cx18-driver.c             |   35 ++--
 drivers/media/video/cx18/cx18-driver.h             |  177 +++++++-----
 drivers/media/video/cx18/cx18-dvb.c                |    2 +
 drivers/media/video/cx18/cx18-fileops.c            |    9 +-
 drivers/media/video/cx18/cx18-firmware.c           |    4 +-
 drivers/media/video/cx18/cx18-gpio.c               |    2 +
 drivers/media/video/cx18/cx18-i2c.c                |    2 +
 drivers/media/video/cx18/cx18-io.c                 |    2 +
 drivers/media/video/cx18/cx18-ioctl.c              |    4 +-
 drivers/media/video/cx18/cx18-irq.c                |    2 +
 drivers/media/video/cx18/cx18-mailbox.c            |    2 +
 drivers/media/video/cx18/cx18-queue.c              |    2 +
 drivers/media/video/cx18/cx18-scb.c                |    2 +
 drivers/media/video/cx18/cx18-streams.c            |    2 +
 drivers/media/video/cx18/cx18-vbi.c                |    2 +
 drivers/media/video/cx18/cx18-video.c              |    2 +
 drivers/media/video/et61x251/et61x251.h            |   66 +++--
 drivers/media/video/et61x251/et61x251_core.c       |    2 +
 drivers/media/video/et61x251/et61x251_tas5130d1b.c |    2 +
 drivers/media/video/gspca/benq.c                   |   18 +-
 drivers/media/video/gspca/conex.c                  |    6 +-
 drivers/media/video/gspca/cpia1.c                  |    7 +-
 drivers/media/video/gspca/etoms.c                  |    6 +-
 drivers/media/video/gspca/finepix.c                |    8 +-
 drivers/media/video/gspca/gl860/gl860.c            |    8 +-
 drivers/media/video/gspca/gspca.c                  |   46 ++--
 drivers/media/video/gspca/gspca.h                  |   22 +-
 drivers/media/video/gspca/jeilinj.c                |   10 +-
 drivers/media/video/gspca/kinect.c                 |   36 ++-
 drivers/media/video/gspca/konica.c                 |   16 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |    9 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |   28 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |   21 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |   19 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |   21 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   35 ++-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |   30 ++-
 drivers/media/video/gspca/mars.c                   |    6 +-
 drivers/media/video/gspca/mr97310a.c               |   24 +-
 drivers/media/video/gspca/nw80x.c                  |    9 +-
 drivers/media/video/gspca/ov519.c                  |   41 ++--
 drivers/media/video/gspca/ov534.c                  |   12 +-
 drivers/media/video/gspca/ov534_9.c                |   12 +-
 drivers/media/video/gspca/pac207.c                 |   14 +-
 drivers/media/video/gspca/pac7302.c                |   15 +-
 drivers/media/video/gspca/pac7311.c                |   15 +-
 drivers/media/video/gspca/se401.c                  |   46 ++--
 drivers/media/video/gspca/sn9c2028.c               |   14 +-
 drivers/media/video/gspca/sn9c20x.c                |   74 +++---
 drivers/media/video/gspca/sonixj.c                 |   22 +-
 drivers/media/video/gspca/spca1528.c               |    8 +-
 drivers/media/video/gspca/spca500.c                |    6 +-
 drivers/media/video/gspca/spca501.c                |    4 +-
 drivers/media/video/gspca/spca505.c                |    8 +-
 drivers/media/video/gspca/spca508.c                |    6 +-
 drivers/media/video/gspca/spca561.c                |    4 +-
 drivers/media/video/gspca/sq905.c                  |   17 +-
 drivers/media/video/gspca/sq905c.c                 |   10 +-
 drivers/media/video/gspca/sq930x.c                 |   21 +-
 drivers/media/video/gspca/stk014.c                 |   16 +-
 drivers/media/video/gspca/stv0680.c                |    6 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   18 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   10 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    4 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |    8 +-
 drivers/media/video/gspca/sunplus.c                |   10 +-
 drivers/media/video/gspca/t613.c                   |   12 +-
 drivers/media/video/gspca/vc032x.c                 |   13 +-
 drivers/media/video/gspca/vicam.c                  |   12 +-
 drivers/media/video/gspca/w996Xcf.c                |    8 +-
 drivers/media/video/gspca/xirlink_cit.c            |   14 +-
 drivers/media/video/gspca/zc3xx.c                  |   14 +-
 drivers/media/video/hexium_gemini.c                |   42 ++--
 drivers/media/video/hexium_orion.c                 |   38 ++--
 drivers/media/video/mxb.c                          |   80 +++---
 include/media/rc-core.h                            |    7 +-
 include/media/saa7146.h                            |   36 ++-
 107 files changed, 1539 insertions(+), 1294 deletions(-)

-- 
1.7.6.405.gc1be0

