Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab1FJX1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:27:31 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:55526 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab1FJX1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:27:30 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1307748449!24409328!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/lcm.c: quiet sparse noise
Date: Fri, 10 Jun 2011 16:27:14 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101627.14811.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'lcm' is exported to the kernel (EXPORT_SYMBOL_GPL).
Pick up it's definition in <linux/lcm.h> to quiet the sparse noise:

  warning: symbol 'lcm' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/lib/lcm.c b/lib/lcm.c
index 157cd88..10b5cfc 100644
--- a/lib/lcm.c
+++ b/lib/lcm.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/gcd.h>
 #include <linux/module.h>
+#include <linux/lcm.h>
 
 /* Lowest common multiple */
 unsigned long lcm(unsigned long a, unsigned long b)
