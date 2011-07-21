Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1GUWg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 18:36:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:34123 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1GUWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 18:36:47 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] kgdb compile fix for 3.0 rc7
Date: Thu, 21 Jul 2011 17:36:34 -0500
Message-ID: <1311287795-8579-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up a sparc compile
regression that was picked up early in the 3.0 cycle.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Thanks,
Jason.

---
The following changes since commit 3a5c3743f15f27237ab025736a981e2d0c9fdfed:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-07-18 13:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (1):
      sparc,kgdbts: fix compile regression with kgdb test suite

 arch/sparc/include/asm/ptrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

