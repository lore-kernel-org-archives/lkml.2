Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0LCHvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 02:51:01 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41970 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab0LCHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 02:51:00 -0500
Date: Fri, 3 Dec 2010 16:49:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.37-rc5
Message-ID: <20101203074958.GA1602@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Caglar Akyuz (1):
      video: da8xx: Register IRQ as last thing in driver probing.

Daniel Drake (1):
      lxfb: Maintain video processor palette through suspend/resume

Randy Dunlap (1):
      framebuffer: fix fbcmap.c kernel-doc warning

 drivers/video/da8xx-fb.c       |   14 ++++++--------
 drivers/video/fbcmap.c         |    1 +
 drivers/video/geode/lxfb.h     |    4 +++-
 drivers/video/geode/lxfb_ops.c |   20 +++++++++++++++-----
 4 files changed, 25 insertions(+), 14 deletions(-)
