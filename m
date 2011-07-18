Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1GRNOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab1GRNJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:10 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, rtc-linux@googlegroups.com
Subject: [PATCH 24/34] drivers/rtc changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:38 -0400
Message-Id: <1310994528-26276-25-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Cc: rtc-linux@googlegroups.com
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/rtc/rtc-cmos.c |    1 -
 drivers/rtc/rtc-mrst.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 911e75c..56b9d6d 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -34,7 +34,6 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/of.h>
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 0cec565..ce8cef4 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -27,7 +27,6 @@
  *  * Alarm function is also limited to hr/min/sec.
  */
 
-#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-- 
1.6.5.2

