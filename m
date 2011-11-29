Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1K2TjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:39:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1K2TjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6545"; a="139669238"
Date: Tue, 29 Nov 2011 11:39:08 -0800
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PULL] msm: timer updates for 3.3
Message-ID: <20111129193908.GA1760@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-timer

Stephen Boyd (8):
      msm: timer: Tighten #ifdef for local timer support
      msm: timer: Cleanup #includes and #defines
      msm: timer: Use GPT for clockevents and DGT for clocksource
      msm: timer: Fix ONESHOT mode interrupts
      msm: timer: Remove msm_clocks[] and simplify code
      msm: timer: Remove SoC specific #ifdefs
      msm: timer: Setup interrupt after registering clockevent
      msm: timer: Use clockevents_config_and_register()

 arch/arm/mach-msm/timer.c |  347 ++++++++++++++++-----------------------------
 1 files changed, 124 insertions(+), 223 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
