Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1ILQsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:48:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55455 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1ILQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:48:07 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 10/10] hwspinlock: add MAINTAINERS entries
Date: Mon, 12 Sep 2011 19:47:05 +0300
Message-Id: <1315846025-11453-11-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update MAINTAINERS with entries for hwspinlock/core and hwspinlock/omap
files.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 MAINTAINERS |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28f65c2..92cee8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2953,6 +2953,14 @@ F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
+HARDWARE SPINLOCK CORE
+M:	Ohad Ben-Cohen <ohad@wizery.com>
+S:	Maintained
+F:	Documentation/hwspinlock.h
+F:	drivers/hwspinlock/hwspinlock_core.c
+F:	drivers/hwspinlock/hwspinlock_internal.h
+F:	include/linux/hwspinlock.h
+
 HARMONY SOUND DRIVER
 M:	Kyle McMartin <kyle@mcmartin.ca>
 L:	linux-parisc@vger.kernel.org
@@ -4625,6 +4633,13 @@ S:	Maintained
 F:	drivers/video/omap2/
 F:	Documentation/arm/OMAP/DSS
 
+OMAP HARDWARE SPINLOCK SUPPORT
+M:	Ohad Ben-Cohen <ohad@wizery.com>
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/hwspinlock/omap_hwspinlock.c
+F:	arch/arm/mach-omap2/hwspinlock.c
+
 OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
-- 
1.7.4.1

