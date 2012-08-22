Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab2HVWzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:55:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53556 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2HVWzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:55:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226084942"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] Miscellaneous MSM fixes
Date: Wed, 22 Aug 2012 15:55:42 -0700
Message-Id: <1345676145-12321-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a small collection of MSM patches I have lying around.
The first removes a useless file and hook that nobody is using.
The second marks some functions static in clock-pcom.c since
they aren't used outside the file and the last removes idle.c
because it's dead code.

Stephen Boyd (3):
  ARM: MSM: Remove msm_hw_reset_hook
  ARM: MSM: clock-pcom: Mark functions static
  ARM: MSM: Remove unused idle.c

 arch/arm/mach-msm/Makefile              |  2 +-
 arch/arm/mach-msm/board-mahimahi.c      |  1 -
 arch/arm/mach-msm/board-sapphire.c      |  1 -
 arch/arm/mach-msm/clock-pcom.c          | 18 ++++++------
 arch/arm/mach-msm/idle.c                | 49 ---------------------------------
 arch/arm/mach-msm/include/mach/system.h | 19 -------------
 arch/arm/mach-msm/proc_comm.c           |  1 -
 arch/arm/mach-msm/smd.c                 |  7 -----
 8 files changed, 10 insertions(+), 88 deletions(-)
 delete mode 100644 arch/arm/mach-msm/idle.c
 delete mode 100644 arch/arm/mach-msm/include/mach/system.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

