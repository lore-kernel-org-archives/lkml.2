Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1LAA3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:29:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1LAA3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:29:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6546"; a="140146347"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ARM: msm: Remove cpu_is test for msm7201 soc
Date: Wed, 30 Nov 2011 16:29:04 -0800
Message-Id: <1322699344-28422-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the last bits of this target are gone, the CPU test is no
longer useful.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/cpu.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/cpu.h b/arch/arm/mach-msm/include/mach/cpu.h
index a9481b0..e5e7fb5 100644
--- a/arch/arm/mach-msm/include/mach/cpu.h
+++ b/arch/arm/mach-msm/include/mach/cpu.h
@@ -20,17 +20,11 @@
 
 /* TODO: For now, only one CPU can be compiled at a time. */
 
-#define cpu_is_msm7x01()	0
 #define cpu_is_msm7x30()	0
 #define cpu_is_qsd8x50()	0
 #define cpu_is_msm8x60()	0
 #define cpu_is_msm8960()	0
 
-#ifdef CONFIG_ARCH_MSM7X00A
-# undef cpu_is_msm7x01
-# define cpu_is_msm7x01()	1
-#endif
-
 #ifdef CONFIG_ARCH_MSM7X30
 # undef cpu_is_msm7x30
 # define cpu_is_msm7x30()	1
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

