Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2IMS4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:56:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63491 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2IMS4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:56:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="236374523"
Date: Thu, 13 Sep 2012 11:56:33 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/5] msm non-critical fixes
Message-ID: <20120913185633.GB30032@codeaurora.org>
References: <20120913185342.GA29823@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913185342.GA29823@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-noncrit-for-3.7

for you to fetch changes up to 10717e04d3502cf4a8aa6408d59093e2bbb4645b:

  ARM: msm: Fix early debug uart mapping on some memory configs (2012-09-13 10:48:35 -0700)

----------------------------------------------------------------
Some non-critical fixes for msm platforms.  The missing FPGA init call
fix is necessary to compile the 8660 target.  The iomapping calls are
needed to prevent duplicate mappings with differing attributes.  And,
the debug UART change keeps the debug UART working on targets with
more than 512MB of memory.

----------------------------------------------------------------
David Brown (1):
      ARM: msm: Remove call to missing FPGA init on 8660

Rohit Vaswani (2):
      ARM: msm: io: Remove 7x30 iomap region from 7x00
      ARM: msm: io: Change the default static iomappings to be shared

Stephen Boyd (1):
      ARM: msm: Fix early debug uart mapping on some memory configs

 arch/arm/mach-msm/board-msm8x60.c               |  5 -----
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |  2 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |  2 +-
 arch/arm/mach-msm/io.c                          | 25 +++++++++++++------------
 4 files changed, 15 insertions(+), 19 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
