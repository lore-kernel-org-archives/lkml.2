Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab1FGUwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:52:38 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22784 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab1FGUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:52:36 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1307479951!26910372!18
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio-ep93xx: fix pr_fmt output
Date: Tue, 7 Jun 2011 13:52:01 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106071352.02183.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this driver now being moved from arch/arm/mach-ep93xx/gpio.c to
drivers/gpio/gpio-ep93xx.c the prefix "ep93xx" is now redundant in the
pr_* output. Using KBUILD_MODNAME is sufficient.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index c33c9a8..3d427b9 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -11,7 +11,7 @@
  *  published by the Free Software Foundation.
  */
 
-#define pr_fmt(fmt) "ep93xx " KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
 #include <linux/module.h>
