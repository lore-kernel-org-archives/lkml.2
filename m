Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab0LODuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:50:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab0LODt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872368"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 2/7] msm: Physical offset for MSM8960
Date: Tue, 14 Dec 2010 19:49:16 -0800
Message-Id: <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the physical memory offset value for the Qualcomm
MSM8960 chip.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/memory.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
index 070e17d..014bbd3 100644
--- a/arch/arm/mach-msm/include/mach/memory.h
+++ b/arch/arm/mach-msm/include/mach/memory.h
@@ -25,6 +25,8 @@
 #define PHYS_OFFSET		UL(0x00200000)
 #elif defined(CONFIG_ARCH_MSM8X60)
 #define PHYS_OFFSET		UL(0x40200000)
+#elif defined(CONFIG_ARCH_MSM8960)
+#define PHYS_OFFSET		UL(0x40200000)
 #else
 #define PHYS_OFFSET		UL(0x10000000)
 #endif
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

