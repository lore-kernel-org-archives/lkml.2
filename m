Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2HUXu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 19:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab2HUXu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 19:50:56 -0400
Message-ID: <50341EDA.5080109@redhat.com>
Date: Tue, 21 Aug 2012 20:50:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.6-rc3] media fixes
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For bug fixes, at soc_camera, si470x, uvcvideo, iguanaworks IR driver, 
radio_shark Kbuild fixes, and at the V4L2 core (radio fixes).

Thank you!
Mauro

-

The following changes since commit 8762541f067d371320731510669e27f5cc40af38:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-07-31 18:47:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 991b3137f21e13db4711f313edbe67d49bed795b:

  [media] media: soc_camera: don't clear pix->sizeimage in JPEG mode (2012-08-15 19:24:28 -0300)

----------------------------------------------------------------
Albert Wang (1):
      [media] media: soc_camera: don't clear pix->sizeimage in JPEG mode

Alex Gershgorin (1):
      [media] media: mx3_camera: buf_init() add buffer state check

Fabio Estevam (2):
      [media] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
      [media] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare

Guenter Roeck (1):
      [media] Add USB dependency for IguanaWorks USB IR Transceiver

Hans Verkuil (5):
      [media] DocBook: Remove a spurious character
      [media] si470x: v4l2-compliance fixes
      [media] mem2mem_testdev: fix querycap regression
      [media] VIDIOC_ENUM_FREQ_BANDS fix
      [media] Add missing logging for rangelow/high of hwseek

Hans de Goede (4):
      [media] radio-shark*: Remove work-around for dangling pointer in usb intfdata
      [media] radio-shark*: Call cancel_work_sync from disconnect rather then release
      [media] radio-shark: Only compile led support when CONFIG_LED_CLASS is set
      [media] radio-shark2: Only compile led support when CONFIG_LED_CLASS is set

Javier Martin (1):
      [media] media: mx2_camera: Fix clock handling for i.MX27

Jayakrishnan Memana (1):
      [media] uvcvideo: Reset the bytesused field when recycling an erroneous buffer

 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   2 +-
 drivers/media/radio/radio-shark.c                  | 151 +++++++++++----------
 drivers/media/radio/radio-shark2.c                 | 137 ++++++++++---------
 drivers/media/radio/si470x/radio-si470x-common.c   |   3 +
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   5 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   2 +-
 drivers/media/rc/Kconfig                           |   1 +
 drivers/media/video/mem2mem_testdev.c              |   2 +-
 drivers/media/video/mx1_camera.c                   |   4 +-
 drivers/media/video/mx2_camera.c                   |  47 ++++---
 drivers/media/video/mx3_camera.c                   |  22 +--
 drivers/media/video/soc_camera.c                   |   3 +-
 drivers/media/video/soc_mediabus.c                 |   6 +
 drivers/media/video/uvc/uvc_queue.c                |   1 +
 drivers/media/video/v4l2-ioctl.c                   |  10 +-
 15 files changed, 217 insertions(+), 179 deletions(-)

