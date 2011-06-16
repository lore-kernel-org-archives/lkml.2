Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1FPGyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:54:24 -0400
Received: from linux-sh.org ([111.68.239.195]:57811 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1FPGyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:54:22 -0400
Date: Thu, 16 Jun 2011 15:53:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev fixes for 3.0-rc4
Message-ID: <20110616065339.GA25825@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a pretty straightforward set of fixes. It doesn't yet
address the console locking / suspend/resume issue as that's still
pending feedback.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-3.x.git fbdev-fixes-for-linus

Which contains:

Geert Uytterhoeven (1):
      fbdev/atyfb: Fix 2 defined-but-not-used warnings

Guennadi Liakhovetski (1):
      fbdev: sh_mobile_hdmi: fix regression: statically enable RTPM

Jingoo Han (3):
      video: s3c-fb: fix misleading kfree in remove function
      video: s3c-fb: fix virtual resolution checking
      video: s3c-fb: move enabling channel for window

Wanlong Gao (1):
      efifb: Fix call to wrong unregister function

 drivers/video/aty/atyfb_base.c |   10 ++++------
 drivers/video/efifb.c          |    2 +-
 drivers/video/s3c-fb.c         |   22 ++++++++++------------
 drivers/video/sh_mobile_hdmi.c |   18 +++++-------------
 4 files changed, 20 insertions(+), 32 deletions(-)
