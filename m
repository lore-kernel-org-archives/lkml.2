Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0KMNpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:45:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0KMNpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:45:38 -0500
Message-ID: <4CDE9677.3060506@redhat.com>
Date: Sat, 13 Nov 2010 11:45:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.36-rc2] drivers/media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a few bug fixes on some drivers, and for Arnd's patch to finish the BKL removal 
from V4L/DVB, as discussed during the KS/2010.

Thanks!
Mauro

The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Arnd Bergmann (1):
      [media] v4l: kill the BKL

Daniel Drake (1):
      [media] cafe_ccic: fix subdev configuration

Dmitri Belimov (1):
      [media] saa7134: Fix autodetect for Behold A7 and H7 TV cards

Janusz Krzysztofik (4):
      [media] SoC Camera: OMAP1: update for recent framework changes
      [media] SoC Camera: OMAP1: update for recent videobuf changes
      [media] SOC Camera: OMAP1: typo fix
      [media] SoC Camera: ov6650: minor cleanups

Jean Delvare (1):
      [media] BZ#22292: dibx000_common: Restore i2c algo pointer

Sascha Hauer (2):
      [media] ARM mx3_camera: check for DMA engine type
      [media] soc-camera: Compile fixes for mx2-camera

Stefan Ringel (1):
      [media] tm6000: bugfix set tv standards

 drivers/media/Kconfig                        |    1 -
 drivers/media/dvb/frontends/dibx000_common.c |    1 +
 drivers/media/video/cafe_ccic.c              |    5 ++-
 drivers/media/video/cx231xx/cx231xx-417.c    |    6 +---
 drivers/media/video/cx23885/cx23885-417.c    |    9 +-------
 drivers/media/video/cx23885/cx23885-video.c  |    5 ----
 drivers/media/video/mx2_camera.c             |   13 ++++-------
 drivers/media/video/mx3_camera.c             |    4 +++
 drivers/media/video/omap1_camera.c           |   16 +++++++-------
 drivers/media/video/ov6650.c                 |    4 +--
 drivers/media/video/saa7134/saa7134-cards.c  |   24 ++++++++++----------
 drivers/media/video/se401.c                  |    7 ++---
 drivers/media/video/stk-webcam.c             |    4 ---
 drivers/media/video/tlg2300/pd-main.c        |   13 +++--------
 drivers/media/video/usbvideo/vicam.c         |   29 ++++++++++++-------------
 drivers/media/video/v4l2-dev.c               |    7 +++--
 drivers/media/video/zoran/zoran.h            |    1 +
 drivers/media/video/zoran/zoran_card.c       |    1 +
 drivers/media/video/zoran/zoran_driver.c     |   27 ++++++++++++++++++-----
 drivers/staging/tm6000/tm6000-video.c        |    1 +
 20 files changed, 86 insertions(+), 92 deletions(-)

