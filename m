Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab1FFVve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:51:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49045 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1FFVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95789882"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 1/8] msm: gpio: Remove unsupported devices
Date: Mon,  6 Jun 2011 14:51:08 -0700
Message-Id: <1307397075-11733-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM7x25 and MSM7x27 devices are not yet supported in the kernel.
Remove #ifdef-based tables supporting these chips for now.

Signed-off-by: David Brown <davidb@codeaurora.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/mach-msm/gpio.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index 5ea273b..c358ced 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -197,13 +197,6 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 	MSM_GPIO_BANK(3,  68,  94),
 	MSM_GPIO_BANK(4,  95, 106),
 	MSM_GPIO_BANK(5, 107, 121),
-#elif defined(CONFIG_ARCH_MSM7X25) || defined(CONFIG_ARCH_MSM7X27)
-	MSM_GPIO_BANK(0,   0,  15),
-	MSM_GPIO_BANK(1,  16,  42),
-	MSM_GPIO_BANK(2,  43,  67),
-	MSM_GPIO_BANK(3,  68,  94),
-	MSM_GPIO_BANK(4,  95, 106),
-	MSM_GPIO_BANK(5, 107, 132),
 #elif defined(CONFIG_ARCH_MSM7X30)
 	MSM_GPIO_BANK(0,   0,  15),
 	MSM_GPIO_BANK(1,  16,  43),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

