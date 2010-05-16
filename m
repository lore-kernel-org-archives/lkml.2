Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0EPNhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 09:37:12 -0400
Received: from smtp-out116.alice.it ([85.37.17.116]:1164 "EHLO
	smtp-out116.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0EPNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 09:37:10 -0400
From: Morgan Gatti <morgan.gatti@gmail.com>
To: gregkh@suse.de, ak@linux.intel.com, kevin.granade@gmail.com,
       devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, sjakub@gmail.com,
       Morgan Gatti <morgan.gatti@gmail.com>
Subject: [PATCH 2/2] Staging:asus_oled:fix style issue in assus_oled.c
Date: Sun, 16 May 2010 15:37:01 +0200
Message-Id: <1274017021-2727-1-git-send-email-morgan.gatti@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 16 May 2010 13:37:04.0716 (UTC) FILETIME=[DF3440C0:01CAF4FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the assus_oled.c file that fix the space and tabs errors founded
by the checkpatch.pl tool
Signed-off-by: Morgan Gatti <morgan.gatti@gmail.com>
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
1.7.0.4

