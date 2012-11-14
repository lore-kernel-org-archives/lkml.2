Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2KNHwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:52:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2KNHvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:51:02 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 3/6] staging: line6: drop unused CONFIG_LINE6_USB_DUMP_CTRL
Date: Wed, 14 Nov 2012 08:50:43 +0100
Message-Id: <1352879446-23195-4-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
References: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/line6/Kconfig b/drivers/staging/line6/Kconfig
index a5ded12..2101799 100644
--- a/drivers/staging/line6/Kconfig
+++ b/drivers/staging/line6/Kconfig
@@ -23,15 +23,6 @@ menuconfig LINE6_USB
 
 if LINE6_USB
 
-config LINE6_USB_DUMP_CTRL
-	bool "dump control messages"
-	default n
-	help
-	  Say Y here to write control messages sent to and received from
-	  Line6 devices to the syslog.
-
-	  If unsure, say N.
-
 config LINE6_USB_DUMP_MIDI
 	bool "dump MIDI messages"
 	default n
-- 
1.8.0

