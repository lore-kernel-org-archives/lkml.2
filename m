Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2DMSIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:08:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61015 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2DMSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:08:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="179222188"
Date: Fri, 13 Apr 2012 11:08:40 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>
Subject: [GIT PULL] msm fixes for 3.4rc
Message-ID: <20120413180840.GA17558@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd/Olof.  Here are some fixes for msm that fix problems caused by
the latest ARM code.  The ones from Daniel remove unneeded fixups that
now cause compilation failures.  Mine fix section mismatches, that
were incompletely fixed earlier.

Thanks,
David

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-fix

for you to fetch changes up to af33eadc73e4a5d35a966c1c7ffe28a8424c9d96:

  ARM: msm: Fix section mismatches in proc_comm.c (2012-04-13 10:23:17 -0700)

----------------------------------------------------------------
Daniel Walker (2):
      arm: msm: halibut: remove unneeded fixup
      arm: msm: trout: fix compile failure

David Brown (2):
      video: msm: Fix section mismatches in mddi.c
      ARM: msm: Fix section mismatches in proc_comm.c

 arch/arm/mach-msm/board-halibut.c     |    3 ---
 arch/arm/mach-msm/board-trout-panel.c |    1 +
 arch/arm/mach-msm/board-trout.c       |    1 +
 arch/arm/mach-msm/proc_comm.c         |    2 +-
 drivers/video/msm/mddi.c              |    8 ++++----
 5 files changed, 7 insertions(+), 8 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
