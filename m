Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884Ab2ILRKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:10:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2ILQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521333"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 05/24] ARM: msm: io: Remove 7x30 iomap region from 7x00
Date: Wed, 12 Sep 2012 09:58:41 -0700
Message-Id: <1347469140-25069-6-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

This is redundant code.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/io.c | 3 ---
 1 file changed, 3 deletions(-)

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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

