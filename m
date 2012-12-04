Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2LDPbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:31:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63552 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2LDP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:19 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] HID: i2c-hid: enhance Kconfig
Date: Tue,  4 Dec 2012 16:27:44 +0100
Message-Id: <1354634875-5182-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "comment" part can never be displayed, so we can remove it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/Kconfig | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/Kconfig b/drivers/hid/i2c-hid/Kconfig
index 5b7d4d8..64ce108 100644
--- a/drivers/hid/i2c-hid/Kconfig
+++ b/drivers/hid/i2c-hid/Kconfig
@@ -7,15 +7,12 @@ config I2C_HID
 	depends on I2C && INPUT
 	select HID
 	---help---
-	  Say Y here if you want to use the HID over i2c protocol
-	  implementation.
+	  Say Y here if you use a keyboard, a touchpad, a touchscreen, or any
+	  other HID based devices which is connected to your computer via I2C.
 
 	  If unsure, say N.
 
 	  This support is also available as a module.  If so, the module
 	  will be called i2c-hid.
 
-comment "Input core support is needed for HID over I2C input layer"
-	depends on I2C_HID && INPUT=n
-
 endmenu
-- 
1.8.0.1

