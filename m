Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1COFB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36260 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1COFBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772011"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeff Ohlstein <johlstei@codeaurora.org>, San Mehat <san@google.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 01/11] msm: dma: Guard for multiple file inclusion
Date: Mon, 14 Mar 2011 22:01:04 -0700
Message-Id: <1300165274-8544-2-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

The include guard was missing the #define, leading to errors if one
included dma.h twice.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/dma.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
index 05583f5..ece09e0 100644
--- a/arch/arm/mach-msm/include/mach/dma.h
+++ b/arch/arm/mach-msm/include/mach/dma.h
@@ -1,6 +1,7 @@
 /* linux/include/asm-arm/arch-msm/dma.h
  *
  * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -14,6 +15,7 @@
  */
 
 #ifndef __ASM_ARCH_MSM_DMA_H
+#define __ASM_ARCH_MSM_DMA_H
 
 #include <linux/list.h>
 #include <mach/msm_iomap.h>
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

