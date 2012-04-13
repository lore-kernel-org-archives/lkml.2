Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000Ab2DMLaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:30:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2DMLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:30:15 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: [PATCH 15/18] ARM: mach-pnx4008: remove including old leds event API header file
Date: Fri, 13 Apr 2012 19:26:14 +0800
Message-Id: <1334316377-23915-16-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-pnx4008/time.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-pnx4008/time.c b/arch/arm/mach-pnx4008/time.c
index 0cfe8af..47a7ae9 100644
--- a/arch/arm/mach-pnx4008/time.c
+++ b/arch/arm/mach-pnx4008/time.c
@@ -25,7 +25,6 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/leds.h>
 #include <asm/mach/time.h>
 #include <asm/errno.h>
 
-- 
1.7.9.5

