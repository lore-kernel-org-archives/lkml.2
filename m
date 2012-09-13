Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2IMSzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:55:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2IMSzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:55:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="236374241"
Date: Thu, 13 Sep 2012 11:55:52 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 1/5] msm cleanups
Message-ID: <20120913185552.GA30032@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup-for-3.7

for you to fetch changes up to e63770acb3c1e7334885ed4673aed1375f93484a:

  ARM: msm: Remove uncompiled board-msm7x27 (2012-09-13 11:13:08 -0700)

----------------------------------------------------------------
Various cleanups for the msm targets.  Most of this is removing dead
code, along with a fix of a sparse warning, a list fix from a semantic
patch, and marking some functions as static.

----------------------------------------------------------------
Stephen Boyd (6):
      ARM: msm: Remove msm_hw_reset_hook
      ARM: msm: clock-pcom: Mark functions static
      ARM: msm: Remove unused idle.c
      ARM: msm: Fix sparse warnings due to incorrect type
      ARM: msm: Remove unused acpuclock-arm11
      ARM: msm: Remove uncompiled board-msm7x27

Wei Yongjun (1):
      ARM: msm: dma: use list_move_tail instead of list_del/list_add_tail

 arch/arm/mach-msm/Makefile              |   4 +-
 arch/arm/mach-msm/acpuclock-arm11.c     | 525 --------------------------------
 arch/arm/mach-msm/acpuclock.h           |  32 --
 arch/arm/mach-msm/board-mahimahi.c      |   1 -
 arch/arm/mach-msm/board-msm7x27.c       | 170 -----------
 arch/arm/mach-msm/board-sapphire.c      |   1 -
 arch/arm/mach-msm/clock-pcom.c          |  18 +-
 arch/arm/mach-msm/dma.c                 |   3 +-
 arch/arm/mach-msm/idle.c                |  49 ---
 arch/arm/mach-msm/include/mach/board.h  |  10 -
 arch/arm/mach-msm/include/mach/system.h |  19 --
 arch/arm/mach-msm/io.c                  |   3 +-
 arch/arm/mach-msm/proc_comm.c           |   1 -
 arch/arm/mach-msm/smd.c                 |   7 -
 arch/arm/mach-msm/timer.c               |   2 +-
 15 files changed, 14 insertions(+), 831 deletions(-)
 delete mode 100644 arch/arm/mach-msm/acpuclock-arm11.c
 delete mode 100644 arch/arm/mach-msm/acpuclock.h
 delete mode 100644 arch/arm/mach-msm/board-msm7x27.c
 delete mode 100644 arch/arm/mach-msm/idle.c
 delete mode 100644 arch/arm/mach-msm/include/mach/system.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
