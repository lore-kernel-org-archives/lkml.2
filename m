Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480Ab0LODuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:50:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651Ab0LODt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872371"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 5/7] msm: timer: Timer support for MSM8960
Date: Tue, 14 Dec 2010 19:49:19 -0800
Message-Id: <1292384961-8851-6-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the macros in the MSM timer driver to support the
MSM8960 chip.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 1154292..c48a449 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -63,7 +63,8 @@ enum timer_location {
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
 #define MSM_DGT_SHIFT (0)
-#elif defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60)
+#elif defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || \
+				      defined(CONFIG_ARCH_MSM8960)
 #define DGT_HZ (24576000 / 4) /* 24.576 MHz (LPXO) / 4 by default */
 #define MSM_DGT_SHIFT (0)
 #else
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

