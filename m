Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1CJEow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:44:52 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55629 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1CJEom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:44:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78880697"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 1/3] msm: 8660: Add clock control regions to iomap
Date: Wed,  9 Mar 2011 20:44:32 -0800
Message-Id: <1299732274-10742-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.203.g07873
In-Reply-To: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I9e72f10d0da1d6aaaaf7df85d33b998edf424f6f
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    8 ++++++++
 arch/arm/mach-msm/io.c                          |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 3b19b8f..ddfc85b 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -53,6 +53,14 @@
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
 
+#define MSM_CLK_CTL_BASE        IOMEM(0xFA010000)
+#define MSM_CLK_CTL_PHYS        0x00900000
+#define MSM_CLK_CTL_SIZE        SZ_16K
+
+#define MSM_LPASS_CLK_CTL_BASE  IOMEM(0xFA015000)
+#define MSM_LPASS_CLK_CTL_PHYS  0x28000000
+#define MSM_LPASS_CLK_CTL_SIZE  SZ_4K
+
 #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
 
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index cec6ed1..b0d3c90 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -108,6 +108,8 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
+	MSM_DEVICE(CLK_CTL),
+	MSM_DEVICE(LPASS_CLK_CTL),
 };
 
 void __init msm_map_msm8x60_io(void)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

