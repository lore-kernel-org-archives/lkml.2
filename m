Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1ERAy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1ERAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:54:55 -0400
Message-ID: <4DD318BE.3000306@redhat.com>
Date: Tue, 17 May 2011 21:54:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v2.6.39-rc7] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For the following fixes:
	- v4l2 core: fix two bad behaviours at subdev interface;
	- cx88: fix remote control suport;
	- soc-camera: fix a regression on image size calculus.

Thanks!
Mauro

-

The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:

  Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Hans Verkuil (1):
      [media] v4l2-subdev: fix broken subdev control enumeration

Laurent Pinchart (1):
      [media] v4l: Release module if subdev registration fails

Lawrence Rust (1):
      [media] Fix cx88 remote control input

Sergio Aguirre (1):
      [media] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c

 drivers/media/video/cx88/cx88-input.c |    2 +-
 drivers/media/video/soc_camera.c      |   48 ++++++++++++++++++++++++++++----
 drivers/media/video/v4l2-device.c     |    5 +++-
 drivers/media/video/v4l2-subdev.c     |   14 +++++-----
 4 files changed, 54 insertions(+), 15 deletions(-)

