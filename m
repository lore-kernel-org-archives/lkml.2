Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2BXTPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:15:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab2BXTPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:15:42 -0500
Message-ID: <4F47E1DA.9040407@redhat.com>
Date: Fri, 24 Feb 2012 17:15:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.3-rc5] media fixes
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest commit at the branch: 
fda27874de91d5a8b9a018b3bc74b14578994908 [media] hdpvr: update picture controls to support firmware versions > 0.15
The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Janne Grunau (1):
      [media] hdpvr: fix race conditon during start of streaming

Jarod Wilson (1):
      [media] imon: don't wedge hardware after early callbacks

Laurent Pinchart (1):
      [media] omap3isp: Fix crash caused by subdevs now having a pointer to devnodes

Randy Dunlap (1):
      [media] wl128x: fix build errors when GPIOLIB is not enabled

Taylor Ralph (1):
      [media] hdpvr: update picture controls to support firmware versions > 0.15

 drivers/media/radio/wl128x/Kconfig      |    4 +-
 drivers/media/rc/imon.c                 |   26 +++++++++++++++---
 drivers/media/video/hdpvr/hdpvr-core.c  |   18 ++++++++++--
 drivers/media/video/hdpvr/hdpvr-video.c |   46 ++++++++++++++++++++++---------
 drivers/media/video/hdpvr/hdpvr.h       |    1 +
 drivers/media/video/omap3isp/ispccdc.c  |    2 +-
 6 files changed, 74 insertions(+), 23 deletions(-)

