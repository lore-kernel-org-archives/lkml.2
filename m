Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab2EKScT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:32:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2EKScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:32:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6708"; a="187846773"
Date: Fri, 11 May 2012 11:32:16 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm-core changes for v3.5, take 2
Message-ID: <20120511183216.GA13034@codeaurora.org>
References: <20120507215828.GA21748@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507215828.GA21748@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor fixes to msm.  Dropped Sapphire support from Daniel Walker
until concerns are addressed.

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-core

for you to fetch changes up to 26e87b13834f04fc209e887f124e8ef4f3ca526c:

  ARM: msm: fix compilation flags for MSM_SCM (part 2) (2012-05-11 11:08:37 -0700)

----------------------------------------------------------------
Danny Kukawka (1):
      arch/arm/mach-msm: linux/gpio.h included twice

Stephen Boyd (2):
      ARM: msm: Drop useless teq from DEBUG_LL support
      ARM: msm: fix compilation flags for MSM_SCM (part 2)

 arch/arm/mach-msm/board-msm7x30.c            |    1 -
 arch/arm/mach-msm/board-qsd8x50.c            |    1 -
 arch/arm/mach-msm/include/mach/debug-macro.S |    3 +--
 arch/arm/mach-msm/scm.c                      |    3 +++
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
