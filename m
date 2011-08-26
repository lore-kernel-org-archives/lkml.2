Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1HZJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:09:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HZJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:09:50 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] plat-samsung: remove including old leds event API header file
Date: Fri, 26 Aug 2011 17:03:31 +0800
Message-Id: <1314349415-889-15-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/plat-samsung/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index e3bb806..a65ef40 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -29,7 +29,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/system.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 
 #include <asm/irq.h>
-- 
1.7.5

