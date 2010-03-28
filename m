Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0C1F1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:27:04 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:34553 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0C1F1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jhbo+O4LLeXxuiAKb3jzjxIFiXzAd63hMPToVhJ8AUlhQdJNIT4BpOJ/5322wv+eaC
         /WLM+KMKTrhGhFHXflZmr2LzRqmZ8p2XMqGNggavEhbUjTw97lzHLndE6q4xk72Hsal6
         dm7OiuTPeOs0FMFijZNDzjliQM2LOk/UnrIHc=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 2/2] Staging: asus_oled: Coding Style issue
Date: Sun, 28 Mar 2010 16:45:33 +1100
Message-Id: <1269755133-12966-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor issue with a space before a tab.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
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

