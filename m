Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2DQK6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:58:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2DQK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:58:05 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 07/18] ARM: mach-integrator: move CM_CTRL to header file for accessing by other functions
Date: Tue, 17 Apr 2012 18:53:34 +0800
Message-Id: <1334660025-20442-8-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
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
1.7.9.5

