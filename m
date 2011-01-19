Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1ASU1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:27:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1ASUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:25:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70910656"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 07/11] msm: Add MSM 8960 cpu_is check
Date: Wed, 19 Jan 2011 12:25:43 -0800
Message-Id: <1295468747-22796-8-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/cpu.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/cpu.h b/arch/arm/mach-msm/include/mach/cpu.h
index e1ba9db..a9481b0 100644
--- a/arch/arm/mach-msm/include/mach/cpu.h
+++ b/arch/arm/mach-msm/include/mach/cpu.h
@@ -24,6 +24,7 @@
 #define cpu_is_msm7x30()	0
 #define cpu_is_qsd8x50()	0
 #define cpu_is_msm8x60()	0
+#define cpu_is_msm8960()	0
 
 #ifdef CONFIG_ARCH_MSM7X00A
 # undef cpu_is_msm7x01
@@ -45,4 +46,9 @@
 # define cpu_is_msm8x60()	1
 #endif
 
+#ifdef CONFIG_ARCH_MSM8960
+# undef cpu_is_msm8960
+# define cpu_is_msm8960()	1
+#endif
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

