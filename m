Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2EGV6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:58:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47785 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2EGV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:58:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6704"; a="188426987"
Date: Mon, 7 May 2012 14:58:28 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm-core changes for v3.5.
Message-ID: <20120507215828.GA21748@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are some minor fixes, and Daniel's fixup of the sapphire target
support.

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-core

for you to fetch changes up to 2935b1facdfb77d5f03d9036cc0da8c889f59a02:

  ARM: msm: fix compilation flags for MSM_SCM (part 2) (2012-05-01 16:44:11 -0700)

----------------------------------------------------------------
Daniel Walker (1):
      arm: msm: fix up very basic HTC Sapphire support

Danny Kukawka (1):
      arch/arm/mach-msm: linux/gpio.h included twice

Stephen Boyd (2):
      ARM: msm: Drop useless teq from DEBUG_LL support
      ARM: msm: fix compilation flags for MSM_SCM (part 2)

 arch/arm/mach-msm/Kconfig                    |   10 +-
 arch/arm/mach-msm/Makefile                   |    1 +
 arch/arm/mach-msm/board-msm7x30.c            |    1 -
 arch/arm/mach-msm/board-qsd8x50.c            |    1 -
 arch/arm/mach-msm/board-sapphire.c           |   18 +--
 arch/arm/mach-msm/board-sapphire.h           |  224 ++++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/debug-macro.S |    3 +-
 arch/arm/mach-msm/scm.c                      |    3 +
 8 files changed, 239 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-sapphire.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
