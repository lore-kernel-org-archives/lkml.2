Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2HMFws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:52:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50300 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2HMFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:52:46 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, olof@lixom.net
Subject: [PATCH 07/18] ARM: mach-integrator: move CM_CTRL to header file for accessing by other functions
Date: Mon, 13 Aug 2012 13:51:31 +0800
Message-Id: <1344837102-11850-8-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-integrator/core.c            | 2 --
 arch/arm/mach-integrator/include/mach/cm.h | 2 ++
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
1.7.11.4

