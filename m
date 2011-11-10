Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1KJBAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:00:07 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56446 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1KJBAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:00:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6525"; a="136268396"
Date: Wed, 9 Nov 2011 17:00:03 -0800
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm fixes for 3.2
Message-ID: <20111110010003.GA785@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This contains an additional fix from
https://lkml.org/lkml/2011/11/1/345
so that pull request can be ignored.

The following changes since commit b4beb4bf9934d151bf4581a54ae028927374cb2a:

  Merge branch 'for-linus/i2c-3.2' of git://git.fluff.org/bjdooks/linux (2011-11-01 15:07:19 -0700)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix

Marc Zyngier (1):
      ARM: msm: fix compilation flags for MSM_SCM

Stephen Boyd (1):
      msm: boards: Fix fallout from removal of machine_desc in fixup

 arch/arm/mach-msm/Makefile        |    2 ++
 arch/arm/mach-msm/board-msm7x30.c |    4 ++--
 arch/arm/mach-msm/board-msm8960.c |    4 ++--
 arch/arm/mach-msm/board-msm8x60.c |    4 ++--
 arch/arm/mach-msm/scm.c           |    3 +++
 5 files changed, 11 insertions(+), 6 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
