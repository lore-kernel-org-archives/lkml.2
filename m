Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0DINBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:01:45 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36515 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0DINBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:01:44 -0400
From: Gunnar Gudvardarson <gunni@wave.is>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gunnar Gudvardarson <gunni@wave.is>
Subject: [PATCH] Staging: asus_oled: asus_oled.c removed an unnessecary space, making it checkpatch clean
Date: Fri,  9 Apr 2010 13:01:09 +0000
Message-Id: <1270818069-3400-1-git-send-email-gunni@wave.is>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first linux kernel patch i have ever made, i don't even
know the C programming language except reading the syntax (basic)

It didn't compile on my machine due to invalid configuration of something
on my machine, because i have not yet learned how to configure the compiler.

Signed-off-by: Gunnar Gudvardarson <gunni@wave.is>
---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 7ebecc9..5b279fb 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -771,7 +771,7 @@ static struct usb_driver oled_driver = {
 };
 
 static CLASS_ATTR_STRING(version, S_IRUGO,
-		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
+			ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
-- 
1.6.3.3

