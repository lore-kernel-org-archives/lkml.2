Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2ILQ7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2ILQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521461"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 16/24] ARM: msm: Rename board-msm8x60 to signify its DT only status
Date: Wed, 12 Sep 2012 09:58:52 -0700
Message-Id: <1347469140-25069-17-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Rename this file to signify that this board is only supported via
devicetree.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                             | 2 +-
 arch/arm/mach-msm/{board-msm8x60.c => board-dt-8660.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm/mach-msm/{board-msm8x60.c => board-dt-8660.c} (100%)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 5fd0464..8794148 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o b
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
-obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
+obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
 obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-dt-8660.c
similarity index 100%
rename from arch/arm/mach-msm/board-msm8x60.c
rename to arch/arm/mach-msm/board-dt-8660.c
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

