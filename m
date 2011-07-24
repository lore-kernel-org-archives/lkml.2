Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1GXDmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:42:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46869 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1GXDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:42:10 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: ben-linux@fluff.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] ARM:mach-s3c2410:remove the dup include file leds.h
Date: Sun, 24 Jul 2011 11:39:09 +0800
Message-Id: <1311478749-6323-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

linux/leds.h has been included twice in h1940-bluetooth.c.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index 2c126bb..a5eeb62 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -18,7 +18,6 @@
 #include <linux/leds.h>
 #include <linux/gpio.h>
 #include <linux/rfkill.h>
-#include <linux/leds.h>
 
 #include <mach/regs-gpio.h>
 #include <mach/hardware.h>
-- 
1.7.4.1

