Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1KUNCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:02:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:4105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab1KUNCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77534876"
Date: Mon, 21 Nov 2011 21:02:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] writeback bits for 3.2-rc3
Message-ID: <20111121130217.GA21433@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull 3 clean fixes on dirty throttling, thanks!

The following changes since commit 6aaf05f472c97ebceff47d9eef464574f1a55727:

  Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6 (2011-11-16 07:33:50 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-linus

Jan Kara (1):
      mm: Make task in balance_dirty_pages() killable

Wu Fengguang (2):
      writeback: hard throttle 1000+ dd on a slow USB stick
      writeback: remove vm_dirties and task->dirties

 include/linux/init_task.h |    1 -
 include/linux/sched.h     |    1 -
 kernel/fork.c             |    5 -----
 mm/page-writeback.c       |   23 +++++++----------------
 4 files changed, 7 insertions(+), 23 deletions(-)

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Commit 468e6a20afaccb67e2a7d7f60d301f90e1c6f301
from git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOykMEAAoJECvKgwp+S8JaRw0P/j1WbITfF6kTCSnP0mwif9B/
HVM1ZTv0yeOUAy2HA5Aw5RrBBE1B0gavF2z+8GHTVg1bCwnvQnXJLaQA4CAN/VAr
vZsaNMcYZLAk26q/GA4n9DddjS4wxe8lul/gr9Oe+mHK5qh7ewjLGrRn0x91bpbj
QqR6AfG68uNBOK4X8fgSKgoph5o2UYKrj9wC3yoXbuoHpFGpID+64U0CGJzU1Amj
J53d75hwOaPkB6BuA2Qm7fz6G3FfOL33p2+fy834E1bD7IkR8ivACPQ3nl2Kg7er
8pshcRh20U1BVqMu7gWF61b/uCJFoNxgc6F8EbL58YKMES6rQOqPeObWSqe+N7lh
klGPc2KIAY6AsoRLGLQVMvC7rnzyh6bFO8oCjr21pf2J0if14BmxuDt4NcuxNtnu
DqI+llZ28uGhjJ6xH0wJjI1rcczFDPen8AQ01TvuY5jNwAqWSN+pvvxaNpSbaY0a
hu1Zy772KP4JJsXhiS8tcD9hnUg479uyfiSluZ2Ev036qLo/hLlzWAttz7cdktT7
fzMKBQKggHCYtTuhgdWEJPhTsXQpxN7ThXIIT0Ikgp8quQv8f29tkGSNdHz8RZs3
PVYIZqCnei4cKCIlHIZVMWHFj44xU6zy+HdXYXGqGdmr6Nc22mESrfr3tSZa3sQw
NyLT0xUX20XDR7XiQNSp
=OqXJ
-----END PGP SIGNATURE-----

