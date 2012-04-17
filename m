Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2DQLB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:01:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2DQLBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:01:23 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 14/18] ARM: plat-samsung: remove including old leds event API header file
Date: Tue, 17 Apr 2012 18:53:41 +0800
Message-Id: <1334660025-20442-15-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/plat-samsung/time.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index 4dcb11c..60552e2 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 
 #include <asm/irq.h>
-- 
1.7.9.5

