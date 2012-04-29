Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2D2KEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 06:04:04 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:40262 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2D2KEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 06:04:02 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ali Bahar <ali@internetDog.org>,
        Michael Fiedler <michael.fiedler@informatik.stud.uni-erlangen.de>,
        Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <error27@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] staging/rtl8712: Remove version.h includes
Date: Sun, 29 Apr 2012 16:03:43 +0600
Message-Id: <1335693823-8673-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are version.h includes that are not needed , reported by make versioncheck
files:
1. drivers/staging/rtl8712/osdep_service.h
2. drivers/staging/rtl8712/rtl871x_ioctl_linux.c

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/staging/rtl8712/osdep_service.h       |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 9ba6033..cabf774 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -29,7 +29,6 @@
 #define _SUCCESS	1
 #define _FAIL		0
 
-#include <linux/version.h>
 #include <linux/spinlock.h>
 
 #include <linux/interrupt.h>
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index ef35bc2..a44d539 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -43,7 +43,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <net/iw_handler.h>
-- 
1.7.9.5

