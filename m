Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1DNT1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:27:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42865 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab1DNT1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:27:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Thu, 14 Apr 2011 15:27:12 -0400
Message-Id: <1302809232-1925-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 85f2e689a5c8fb6ed8fdbee00109e7f6e5fefcb6:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86 (2011-04-13 09:15:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Graf Yang (1):
      Blackfin: SMP: make all barriers handle cache issues

Mike Frysinger (2):
      Blackfin: gptimers: fix thinko when disabling timers
      Blackfin: time-ts: ack gptimer sooner to avoid missing short ints

Sonic Zhang (1):
      Blackfin: SMP: fix cache flush loop

 arch/blackfin/include/asm/system.h |   36 ++++++++++++++++++------------------
 arch/blackfin/kernel/gptimers.c    |    2 +-
 arch/blackfin/kernel/time-ts.c     |    8 +++++++-
 arch/blackfin/mach-common/smp.c    |   21 +++++++++++++++++----
 4 files changed, 43 insertions(+), 24 deletions(-)
