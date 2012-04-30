Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2D3Hkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:40:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2D3Hka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:40:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 16/19] ARM: mach-pnx4008: remove including old leds event API header file
Date: Mon, 30 Apr 2012 15:37:21 +0800
Message-Id: <1335771444-26361-17-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com>
References: <1335771444-26361-1-git-send-email-bryan.wu@canonical.com>
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

