Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339Ab2C3MDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:03:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350Ab2C3MAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:00:14 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: tony@atomide.com, linux@arm.linux.org.uk, rpurdie@rpsys.net,
        manuel.lauss@gmail.com, cjb@laptop.org, cbou@mail.ru,
        dwmw2@infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org
Subject: [PATCH 07/18] ARM: mach-integrator: move CM_CTRL to header file for accessing by other functions
Date: Fri, 30 Mar 2012 19:58:22 +0800
Message-Id: <1333108713-12707-8-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333108713-12707-1-git-send-email-bryan.wu@canonical.com>
References: <1333108713-12707-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-integrator/core.c            |    2 --
 arch/arm/mach-integrator/include/mach/cm.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index eaf6c63..8c53562 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -172,8 +172,6 @@ static struct amba_pl010_data integrator_uart_data = {
 	.set_mctrl = integrator_uart_set_mctrl,
 };
 
-#define CM_CTRL	IO_ADDRESS(INTEGRATOR_HDR_CTRL)
-
 static DEFINE_RAW_SPINLOCK(cm_lock);
 
 /**
diff --git a/arch/arm/mach-integrator/include/mach/cm.h b/arch/arm/mach-integrator/include/mach/cm.h
index 445d57a..1a78692e 100644
--- a/arch/arm/mach-integrator/include/mach/cm.h
+++ b/arch/arm/mach-integrator/include/mach/cm.h
@@ -3,6 +3,8 @@
  */
 void cm_control(u32, u32);
 
+#define CM_CTRL	IO_ADDRESS(INTEGRATOR_HDR_CTRL)
+
 #define CM_CTRL_LED			(1 << 0)
 #define CM_CTRL_nMBDET			(1 << 1)
 #define CM_CTRL_REMAP			(1 << 2)
-- 
1.7.9.1

