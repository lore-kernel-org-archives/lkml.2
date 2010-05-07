Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0EGAuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 20:50:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0EGAuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 20:50:11 -0400
Date: Thu, 6 May 2010 21:49:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.34] V4L/DVB fixes
Message-ID: <20100506214954.7953e52e@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
  Linus Torvalds (1):
        Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.34

Bjørn Mork (1):
      V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer 	dereference"

Dan Carpenter (2):
      V4L/DVB: omap24xxcam: potential buffer overflow
      V4L/DVB: video: testing unsigned for less than 0

Erik Andrén (1):
      V4L/DVB: gspca - stv06xx: Remove the 046d:08da from the stv06xx driver

Hans Verkuil (3):
      V4L/DVB: feature-removal: announce videotext.h removal
      V4L/DVB: v4l: fix config dependencies: mxb and saa7191 are V4L2 drivers, not V4L1
      V4L/DVB: saa7146: fix regression of the av7110/budget-av driver

John Ellson (1):
      V4L/DVB: gspca: make usb id 0461:0815 get handled by the right driver

Michael Hunold (1):
      V4L/DVB: saa7146: fix up bytesperline if it is an impossible value

Murali Karicheri (1):
      V4L/DVB: V4L: vpfe_capture - free ccdc_lock when memory allocation fails

Muralidharan Karicheri (1):
      V4L/DVB: V4L - vpfe capture - fix for kernel crash

Oliver Endriss (1):
      V4L/DVB: ngene: Workaround for stuck DiSEqC pin

Stefan Herbrechtsmeier (1):
      V4L/DVB: pxa_camera: move fifo reset direct before dma start

Uwe Kleine-König (1):
      V4L/DVB: mx1-camera: compile fix

Vaibhav Hiremath (1):
      V4L/DVB: V4L - Makfile:Removed duplicate entry of davinci

Yong Zhang (1):
      V4L/DVB: gspca - sn9c20x: Correct onstack wait_queue_head declaration

 Documentation/feature-removal-schedule.txt   |   23 +++++++++++++++
 arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h |    8 +++++-
 drivers/media/common/saa7146_fops.c          |   11 +++----
 drivers/media/common/saa7146_video.c         |    8 +++--
 drivers/media/dvb/frontends/stv090x.c        |    4 +++
 drivers/media/dvb/ttpci/budget.c             |    3 --
 drivers/media/video/Kconfig                  |    4 +-
 drivers/media/video/Makefile                 |    2 -
 drivers/media/video/davinci/vpfe_capture.c   |   38 +++++++++++++++----------
 drivers/media/video/gspca/sn9c20x.c          |    2 +-
 drivers/media/video/gspca/spca508.c          |    1 -
 drivers/media/video/gspca/spca561.c          |    1 +
 drivers/media/video/gspca/stv06xx/stv06xx.c  |    2 -
 drivers/media/video/hexium_gemini.c          |    3 --
 drivers/media/video/hexium_orion.c           |    4 ---
 drivers/media/video/mx1_camera.c             |    8 ++---
 drivers/media/video/mxb.c                    |   17 +++++------
 drivers/media/video/omap24xxcam.c            |    2 +-
 drivers/media/video/pxa_camera.c             |   11 ++++---
 drivers/media/video/sh_mobile_ceu_camera.c   |    2 +-
 include/media/saa7146_vv.h                   |    1 -
 21 files changed, 90 insertions(+), 65 deletions(-)



-- 

Cheers,
Mauro
