Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab1EaPx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab1EaPxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:24 -0400
Date: Tue, 31 May 2011 11:53:23 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155323.3598.73956.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 25/35] drivers/rtc changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/rtc changes for SMBIOS and System Firmware

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
1.7.5.1

