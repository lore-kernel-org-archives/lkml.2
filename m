Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0GLSPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0GLSPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:15:09 -0400
Message-ID: <4C3B5BB3.8050704@redhat.com>
Date: Mon, 12 Jul 2010 15:15:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.34] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

For some fixes at V4L/DVB.

Cheers,
Mauro.

The following changes since commit b9f399594d12e353dcb609c25219bdaa76c2a050:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2010-07-08 08:20:41 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_2.6.35

Andy Walls (3):
      V4L/DVB: tuner: Add a definition for the Philips FQ1236 MK5 NTSC tuner
      V4L/DVB: tveeprom: Add an entry for tuner code 168: a TCL M30WTP-4N-E tuner
      V4L/DVB: Documentation: Add the Philips FQ1236 MK5 to video4linux/CARDLIST.tuner

Ian Armstrong (1):
      V4L/DVB: ivtv: Add delay to ensure the decoder always restarts with a blank screen

Laurent Pinchart (2):
      V4L/DVB: uvcvideo: Power line frequency control doesn't support GET_MIN/MAX/RES
      V4L/DVB: uvc: Fix multiple symbols definitions with UVC gadget and host drivers

Pawel Osciak (1):
      V4L/DVB: v4l: mem2mem_testdev: fix g_fmt NULL pointer dereference

Vaibhav Hiremath (3):
      V4L/DVB: OMAP_VOUT:Build FIX: Rebased against latest DSS2 changes
      V4L/DVB: OMAP_VOUT: fix: Replaced dma-sg with dma-contig
      V4L/DVB: OMAP_VOUT: fix: Module params were not working through bootargs

 Documentation/video4linux/CARDLIST.tuner   |    1 +
 drivers/media/common/tuners/tuner-simple.c |    1 +
 drivers/media/common/tuners/tuner-types.c  |   16 +++
 drivers/media/video/ivtv/ivtv-streams.c    |    3 +
 drivers/media/video/mem2mem_testdev.c      |    3 +
 drivers/media/video/omap/Kconfig           |    4 +-
 drivers/media/video/omap/Makefile          |    4 +-
 drivers/media/video/omap/omap_vout.c       |   81 ++++++---------
 drivers/media/video/tveeprom.c             |   15 +++
 drivers/media/video/uvc/uvc_ctrl.c         |    4 +-
 drivers/usb/gadget/f_uvc.c                 |    4 +-
 drivers/usb/gadget/uvc.h                   |   10 +--
 drivers/usb/gadget/uvc_queue.c             |  153 ++++++++++++++-------------
 drivers/usb/gadget/uvc_queue.h             |   20 ----
 drivers/usb/gadget/uvc_v4l2.c              |    2 +-
 drivers/usb/gadget/uvc_video.c             |    6 +-
 drivers/usb/gadget/webcam.c                |    4 +-
 include/media/tuner.h                      |    1 +
 18 files changed, 169 insertions(+), 163 deletions(-)

