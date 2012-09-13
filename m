Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2IMS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:57:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7108 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2IMS5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:57:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="234069323"
Date: Thu, 13 Sep 2012 11:57:36 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 4/5] msm board changes
Message-ID: <20120913185736.GD30032@codeaurora.org>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-board-for-3.7

for you to fetch changes up to 33fcb13dc543af610c7c930dbfeeed6e6ed02376:

  ARM: msm: Allow 8960 and 8660 to compile together (2012-09-13 11:17:47 -0700)

----------------------------------------------------------------
Final parts to allow msm8660 and msm8960 to build into the same
kernel.  This won't work without the changes from msm-dt-for-3.7.

----------------------------------------------------------------
Stephen Boyd (2):
      ARM: msm: Allow msm_iomap-8x60 and msm_iomap-8960 to coexist
      ARM: msm: Allow 8960 and 8660 to compile together

 arch/arm/mach-msm/Kconfig                       |  8 ++++++--
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h | 11 -----------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |  3 +--
 arch/arm/mach-msm/io.c                          |  2 --
 4 files changed, 7 insertions(+), 17 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
