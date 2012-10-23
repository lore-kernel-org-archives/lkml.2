Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab2JWUIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:08:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49798 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab2JWUIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:08:15 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 065/193] drivers/media/video/pvrusb2: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:18 -0700
Message-Id: <1351022666-6960-66-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Mike Isely <isely@pobox.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/usb/pvrusb2/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
index 32b11c1..60a2604 100644
--- a/drivers/media/usb/pvrusb2/Kconfig
+++ b/drivers/media/usb/pvrusb2/Kconfig
@@ -17,9 +17,9 @@ config VIDEO_PVRUSB2
 	  module will be called pvrusb2
 
 config VIDEO_PVRUSB2_SYSFS
-	bool "pvrusb2 sysfs support (EXPERIMENTAL)"
+	bool "pvrusb2 sysfs support"
 	default y
-	depends on VIDEO_PVRUSB2 && SYSFS && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2 && SYSFS
 	---help---
 	  This option enables the operation of a sysfs based
 	  interface for query and control of the pvrusb2 driver.
@@ -33,9 +33,9 @@ config VIDEO_PVRUSB2_SYSFS
 	  Note: This feature is experimental and subject to change.
 
 config VIDEO_PVRUSB2_DVB
-	bool "pvrusb2 ATSC/DVB support (EXPERIMENTAL)"
+	bool "pvrusb2 ATSC/DVB support"
 	default y
-	depends on VIDEO_PVRUSB2 && DVB_CORE && EXPERIMENTAL
+	depends on VIDEO_PVRUSB2 && DVB_CORE
 	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.7.9.5

