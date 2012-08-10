Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab2HJVSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:18:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20067 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab2HJVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:18:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6799"; a="221829657"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH RESEND 1/2] msm: io: Remove 7x30 iomap region from 7x00
Date: Fri, 10 Aug 2012 14:18:00 -0700
Message-Id: <1344633480-1815-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is redundant code.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/io.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index a1e7b11..2409c0b 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -51,9 +51,6 @@ static struct map_desc msm_io_desc[] __initdata = {
 	defined(CONFIG_DEBUG_MSM_UART3)
 	MSM_DEVICE(DEBUG_UART),
 #endif
-#ifdef CONFIG_ARCH_MSM7X30
-	MSM_DEVICE(GCC),
-#endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
 		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

