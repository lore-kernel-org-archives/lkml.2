Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2DXRzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:55:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57658 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab2DXRy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:54:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6691"; a="184522578"
Date: Tue, 24 Apr 2012 10:54:57 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm fixes for 3.4rc
Message-ID: <20120424175457.GA5013@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a boot problem with the MSM8660 target on device tree
caused by the conversion of the ARM GIC driver to proper IRQ domain
support.

The following changes since commit af33eadc73e4a5d35a966c1c7ffe28a8424c9d96:

  ARM: msm: Fix section mismatches in proc_comm.c (2012-04-13 10:23:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-fix

for you to fetch changes up to 2b7b9a7d6c676691cd746a654e2c3b06a6feb9ba:

  ARM: msm: Fix gic irqdomain support (2012-04-23 16:13:27 -0700)

----------------------------------------------------------------
David Brown (1):
      ARM: msm: Fix gic irqdomain support

 arch/arm/boot/dts/msm8660-surf.dts |    4 ++--
 arch/arm/mach-msm/board-msm8x60.c  |   25 +++++++++++++++----------
 2 files changed, 17 insertions(+), 12 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
