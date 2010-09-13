Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0IMKcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:32:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59105 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0IMKcO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 13 Sep 2010 06:32:14 -0400
Message-Id: <4C8E19C80200007800015B18@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:32:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <khali@linux-fr.org>
Cc: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: x86/hwmon: remove inclusion of unnecessary headers from
	 {core,pkg,via-cpu}temp.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These likely originate from these drivers being clones of one another
and/or other drivers which actually needed these includes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/hwmon/coretemp.c    |    1 -
 drivers/hwmon/pkgtemp.c     |    1 -
 drivers/hwmon/via-cputemp.c |    2 --
 3 files changed, 4 deletions(-)

--- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-no-delay-h/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
--- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-no-delay-h/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/jiffies.h>
--- linux-2.6.36-rc4/drivers/hwmon/via-cputemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-hwmon-no-delay-h/drivers/hwmon/via-cputemp.c	2010-09-13 00:00:00.000000000 +0200
@@ -22,10 +22,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/jiffies.h>
 #include <linux/hwmon.h>
 #include <linux/sysfs.h>
 #include <linux/hwmon-sysfs.h>



