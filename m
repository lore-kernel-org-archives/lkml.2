Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1A0AOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:14:43 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15922 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1A0AOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:14:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71899492"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] msm: Warning fix in trout gpio board file
Date: Wed, 26 Jan 2011 16:14:24 -0800
Message-Id: <1296087264-9659-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296087264-9659-1-git-send-email-davidb@codeaurora.org>
References: <1296087264-9659-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-msm/board-trout-gpio.c: In function 'trout_gpio_to_irq':
arch/arm/mach-msm/board-trout-gpio.c:77: error: unused variable 'msm_gpio'

Change-Id: I21177f74f156b3fe56dd39dcd524998229e27ff9
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-trout-gpio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
index a604ec1..31117a4 100644
--- a/arch/arm/mach-msm/board-trout-gpio.c
+++ b/arch/arm/mach-msm/board-trout-gpio.c
@@ -74,8 +74,6 @@ static int msm_gpiolib_direction_output(struct gpio_chip *chip,
 
 static int trout_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct msm_gpio_chip *msm_gpio = to_msm_gpio_chip(chip);
-
 	return TROUT_GPIO_TO_INT(offset + chip->base);
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

