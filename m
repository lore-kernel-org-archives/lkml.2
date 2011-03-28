Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1C1H10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:27:26 -0400
Received: from mswedge2.sunplus.com ([124.219.29.227]:54039 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1C1H1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:27:25 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 03:27:24 EDT
In-Reply-To: <20110325141528.825456671@linutronix.de>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Subject: [GIT PULL] score arch fixes for 2.6.39
X-KeepSent: FB188476:85B76899-48257861:00264A49;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFFB188476.85B76899-ON48257861.00264A49-48257861.002784C6@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 28 Mar 2011 15:11:39 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 8.5.1|September 28, 2009) at 2011/03/28 ?? 03:11:39,
	Serialize complete at 2011/03/28 ?? 03:11:39
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull score arch fixes for Linux 2.6.39.
It's include some fixed for score irq files.

Thanks
--liqin

------

The following changes since commit 
16c29dafcc86024048f1dbb8349d31cb22c7c55a:
  Linus Torvalds (1):
        Merge branch 'syscore' of 
git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  git://gitserver.sunplusct.com/linux-2.6-score.git for-linus

Chen Liqin (1):
      score: lost a semicolon in asm/irqflags.h

Thomas Gleixner (4):
      score: Convert irq_chip to new functions
      score: Select GENERIC_HARDIRQS_NO_DEPRECATED
      score: Convert to new irq function names
      score: Use generic show_interrupts()

 arch/score/Kconfig                |    2 +
 arch/score/include/asm/irqflags.h |    2 +-
 arch/score/kernel/irq.c           |   53 
+++++-------------------------------
 3 files changed, 11 insertions(+), 46 deletions(-)

