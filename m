Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1ESB0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:26:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1716 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1ESBZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:25:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="92178953"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: 8660: Add FLUID support
Date: Wed, 18 May 2011 18:25:57 -0700
Message-Id: <1305768357-25394-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.1.339.gb602ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The machine descriptor for FLUID was missing. Adding it allows us
to boot FLUID devices since the basic support for 8660 is the
same.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 98c47ce..35ed594 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -98,3 +98,10 @@ MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
 	.init_machine = msm8x60_init,
 	.timer = &msm_timer,
 MACHINE_END
+
+MACHINE_START(MSM8X60_FLUID, "QCT MSM8X60 FLUID")
+	.map_io = msm8x60_map_io,
+	.init_irq = msm8x60_init_irq,
+	.init_machine = msm8x60_init,
+	.timer = &msm_timer,
+MACHINE_END
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

