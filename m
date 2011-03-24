Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1CXFLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:11:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45606 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1CXFLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:11:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Thu, 24 Mar 2011 01:11:45 -0400
Message-Id: <1300943505-20078-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300943456-19840-1-git-send-email-vapier@gentoo.org>
References: <1300943456-19840-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4bbba111d94781d34081c37856bbc5eb33f6c72a:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-03-23 07:58:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Graf Yang (1):
      Blackfin: SMP: flush CoreB cache when shutting down

Mike Frysinger (3):
      Blackfin: wire up new syncfs syscall
      Blackfin: enable atomic64_t support
      Blackfin: bf54x: re-enable anomaly 05000353 for all revs

 arch/blackfin/Kconfig                           |    1 +
 arch/blackfin/include/asm/atomic.h              |    2 ++
 arch/blackfin/include/asm/unistd.h              |    3 ++-
 arch/blackfin/mach-bf548/include/mach/anomaly.h |    6 +++++-
 arch/blackfin/mach-bf561/hotplug.c              |    9 +++++++++
 arch/blackfin/mach-common/entry.S               |    1 +
 6 files changed, 20 insertions(+), 2 deletions(-)
