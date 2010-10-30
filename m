Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0J3AwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:52:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0J3AwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:52:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6151"; a="59936249"
X-IronPort-AV: E=Sophos;i="4.58,260,1286175600"; 
   d="scan'208";a="15522055"
Subject: [GIT PULL] msm fixes and msm video
From: Daniel Walker <c_dwalke@quicinc.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linus-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 17:52:06 -0700
Message-ID: <1288399926.6631.139.camel@m0nster>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Most of the MSM changes went in with Russell's ARM merge. This is mostly
fixes for issues discovered after Russell merged my tree. It also has a
couple of changes for drivers/video/msm/ which are just run time fixes.

Nothing remotely huge or exciting.

I created a for-linus branch with a merge of msm-fixes, and msm-video.
If your not into that feel free to pull the individual branches,

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-fixes
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-video

So please pull, and have a nice day!

Daniel

---

The following changes since commit 44234d0c465d996145e9c821fa28a981f2e8309d:

  Merge branch 'for-2637/i2c-all' of git://git.fluff.org/bjdooks/linux (2010-10-29 16:15:57 -0700)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git for-linus

Daniel Walker (8):
      drivers: video: msm: fix hang on disable_irq
      drivers: msm: video: add dev_set_name call
      msm: fix compile failure on struct membank node member
      msm: fix Kconfig target board selection
      msm: fix debug-macro.S build failure
      msm: fix compile failure when no debug uart is selected
      msm: Kconfig: drop unused config options
      Merge remote branches 'dwalker/msm-fixes' and 'dwalker/msm-video' into for-linus

Jeff Ohlstein (1):
      msm: timer: Decrease shift on timer clocksource

Joe Perches (1):
      drivers/video/msm/mddi.c: Remove multiple KERN_<level> uses

Vasiliy Kulikov (1):
      arm: mach-msm: fix error handling in msm_iommu_probe()

 arch/arm/mach-msm/Kconfig                    |    9 +++++----
 arch/arm/mach-msm/board-halibut.c            |    1 -
 arch/arm/mach-msm/include/mach/debug-macro.S |   15 +++++++++++++--
 arch/arm/mach-msm/iommu_dev.c                |   22 +++++++++++++---------
 arch/arm/mach-msm/timer.c                    |    2 +-
 drivers/video/msm/mddi.c                     |    5 ++---
 drivers/video/msm/mdp.c                      |    3 ++-
 7 files changed, 36 insertions(+), 21 deletions(-)



