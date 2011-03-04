Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab1CDI6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:58:17 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34005 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDI6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:58:16 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Fri,  4 Mar 2011 03:58:22 -0500
Message-Id: <1299229102-26414-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b65a0e0c84cf489bfa00d6aa6c48abc5a237100f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-03-03 15:48:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (2):
      Blackfin: outs[lwb]: make sure count is greater than 0
      Blackfin: iflush: update anomaly 05000491 workaround

 arch/blackfin/lib/outs.S          |   16 ++++++++++++----
 arch/blackfin/mach-common/cache.S |    2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)
