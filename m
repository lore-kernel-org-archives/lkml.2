Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2AMGVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:21:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:43761 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2AMGVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:21:45 -0500
Message-ID: <1326435694.23910.229.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jan 2012 17:21:34 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please pull this couple of important bug fixes (a commit
that went in breaks booting on some machines, this fixes
it properly).

Thanks !

Cheers,
Ben.

The following changes since commit 7b3480f8b701170c046e1ed362946f5f0d005e13:

  Merge tag 'for-linus-3.3' of git://git.infradead.org/mtd-2.6 (2012-01-10 13:45:22 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      powerpc: Fix RCU idle and hcall tracing

Li Zhong (1):
      powerpc: Fix unpaired __trace_hcall_entry and __trace_hcall_exit

 arch/powerpc/kernel/idle.c              |   12 ++----------
 arch/powerpc/platforms/pseries/hvCall.S |    3 ++-
 arch/powerpc/platforms/pseries/lpar.c   |   14 ++++++++++----
 3 files changed, 14 insertions(+), 15 deletions(-)


