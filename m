Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1I1UBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:01:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1I1UBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:01:00 -0400
Message-ID: <4E837CF8.3060605@redhat.com>
Date: Wed, 28 Sep 2011 17:00:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.2] media fixes
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
	git://linuxtv.org/mchehab/for_linus.git v4l_for_linus

For a few fixes at the omap3 and UVC video drivers.

Thanks!
Mauro

-

Last commit at the branch: e74d83aad3709a17d68f01481f2b5f240250b1c3 [media] omap3isp: Fix build error in ispccdc.c

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://linuxtv.org/mchehab/for_linus.git v4l_for_linus

Archit Taneja (1):
      [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2

Dave Young (1):
      [media] v4l: Make sure we hold a reference to the v4l2_device before using it

Hans Verkuil (1):
      [media] v4l: Fix use-after-free case in v4l2_device_release

Joerg Roedel (1):
      [media] omap3isp: Fix build error in ispccdc.c

Laurent Pinchart (1):
      [media] uvcvideo: Fix crash when linking entities

Ming Lei (1):
      [media] uvcvideo: Set alternate setting 0 on resume if the bus has been reset

 drivers/media/video/omap/omap_vout.c   |   13 -------------
 drivers/media/video/omap3isp/ispccdc.c |    1 +
 drivers/media/video/uvc/uvc_driver.c   |    2 +-
 drivers/media/video/uvc/uvc_entity.c   |    2 +-
 drivers/media/video/uvc/uvc_video.c    |   10 +++++++++-
 drivers/media/video/uvc/uvcvideo.h     |    2 +-
 drivers/media/video/v4l2-dev.c         |   11 +++++++++++
 drivers/media/video/v4l2-device.c      |    2 ++
 8 files changed, 26 insertions(+), 17 deletions(-)

