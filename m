Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1FGOol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1FGOoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:44:39 -0400
Message-ID: <4DEE394F.9070404@redhat.com>
Date: Tue, 07 Jun 2011 11:44:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.0-rc3] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Antti Palosaari (1):
      [media] anysee: return EOPNOTSUPP for unsupported I2C messages

Hans Petter Selasky (1):
      [media] Make nchg variable signed because the code compares this variable against negative values

Ian Armstrong (3):
      [media] ivtv: Make two ivtv_msleep_timeout calls uninterruptable
      [media] ivtvfb: Add sanity check to ivtvfb_pan_display()
      [media] ivtv: Internally separate encoder & decoder standard setting

Jean-FranÃ§ois Moine (5):
      [media] gspca - ov519: Fix a regression for ovfx2 webcams
      [media] gspca - ov519: Change the ovfx2 bulk transfer size
      [media] gspca: Remove coarse_expo_autogain.h
      [media] gspca - stv06xx: Set a lower default value of gain for hdcs sensors
      [media] gspca - ov519: Set the default frame rate to 15 fps

Laurent Pinchart (3):
      [media] ivtvfb: use display information in info not in var for panning
      [media] v4l: Fix media_entity_to_video_device macro argument name
      [media] media: Fix media device minor registration

Mauro Carvalho Chehab (2):
      [media] uvc_entity: initialize return value
      [media] soc_camera: preserve const attribute

Sanjeev Premi (1):
      [media] omap3isp: fix compiler warning

 drivers/media/dvb/dvb-usb/anysee.c               |   17 ++-
 drivers/media/media-devnode.c                    |    4 +-
 drivers/media/video/gspca/coarse_expo_autogain.h |  116 -------------------
 drivers/media/video/gspca/ov519.c                |    8 +-
 drivers/media/video/gspca/sonixj.c               |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c           |   10 +-
 drivers/media/video/ivtv/ivtv-firmware.c         |   11 +-
 drivers/media/video/ivtv/ivtv-ioctl.c            |  129 ++++++++++++----------
 drivers/media/video/ivtv/ivtv-ioctl.h            |    3 +-
 drivers/media/video/ivtv/ivtv-streams.c          |    4 +-
 drivers/media/video/ivtv/ivtv-vbi.c              |    2 +-
 drivers/media/video/ivtv/ivtvfb.c                |   33 ++++--
 drivers/media/video/omap3isp/isp.c               |    2 +-
 drivers/media/video/soc_camera.c                 |    2 +-
 drivers/media/video/uvc/uvc_entity.c             |    2 +-
 include/media/v4l2-dev.h                         |    4 +-
 17 files changed, 131 insertions(+), 220 deletions(-)
 delete mode 100644 drivers/media/video/gspca/coarse_expo_autogain.h

