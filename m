Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1HZJKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:10:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1HZJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:10:08 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] mach-pnx4008: remove including old leds event API header file
Date: Fri, 26 Aug 2011 17:03:32 +0800
Message-Id: <1314349415-889-16-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-pnx4008/time.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pnx4008/time.c b/arch/arm/mach-pnx4008/time.c
index 0c8aad4..4385793 100644
--- a/arch/arm/mach-pnx4008/time.c
+++ b/arch/arm/mach-pnx4008/time.c
@@ -26,7 +26,6 @@
 
 #include <asm/system.h>
 #include <mach/hardware.h>
-#include <asm/leds.h>
 #include <asm/mach/time.h>
 #include <asm/errno.h>
 
-- 
1.7.5

