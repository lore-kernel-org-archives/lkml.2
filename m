Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1BWFog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:44:36 -0500
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab1BWFmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:31 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] MAINTAINERS: Quote non-alphanumeric email addresses
Date: Tue, 22 Feb 2011 21:42:02 -0800
Message-Id: <70a2035a61c95dfa12a3eeb9b16433ced527d886.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add quotes around email address with periods and commas.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a9d971e..3508c0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1052,7 +1052,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/TETON BGA MACHINE SUPPORT
-M:	Mark F. Brown <mark.brown314@gmail.com>
+M:	"Mark F. Brown" <mark.brown314@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
@@ -1456,7 +1456,7 @@ F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -1465,7 +1465,7 @@ F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
 M:	Marcel Holtmann <marcel@holtmann.org>
-M:	Gustavo F. Padovan <padovan@profusion.mobi>
+M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
@@ -2913,7 +2913,7 @@ F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
-M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
+M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/scsi/hpsa.txt
@@ -4201,7 +4201,7 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	Lee, Chun-Yi <jlee@novell.com>
+M:	"Lee, Chun-Yi" <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
-- 
1.7.4.rc3

