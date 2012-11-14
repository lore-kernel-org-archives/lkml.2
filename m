Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2KNHvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:51:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2KNHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:51:00 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 2/6] staging: line6: drop CONTROL from CONFIG_LINE6_USB_DUMP_ANY
Date: Wed, 14 Nov 2012 08:50:42 +0100
Message-Id: <1352879446-23195-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
References: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_LINE6_USB_DUMP_CTRL is no longer used by the code and therefore
no longer plays a role in CONFIG_LINE6_USB_DUMP_ANY.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 9dd8ff4..7770635 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -20,7 +20,7 @@
 
 #define DRIVER_NAME "line6usb"
 
-#if defined(CONFIG_LINE6_USB_DUMP_CTRL) || defined(CONFIG_LINE6_USB_DUMP_MIDI) || defined(CONFIG_LINE6_USB_DUMP_PCM)
+#if defined(CONFIG_LINE6_USB_DUMP_MIDI) || defined(CONFIG_LINE6_USB_DUMP_PCM)
 #define CONFIG_LINE6_USB_DUMP_ANY
 #endif
 
-- 
1.8.0

