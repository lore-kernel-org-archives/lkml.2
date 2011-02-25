Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1BYGPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:15:04 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:48187 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1BYGPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DZmq6c3uD5NUssrCDrmO9WoQmgwaVQY79X5vn+IULv86TTYe6jbpJAr0OnjevMsz/Z
         a+AIFF3FuzjKBtCD2tXioY/OyDfoBUe14eDOeIDEjyN7xMPIYtJxWXpKL4TjWb+96e3I
         PAVuXEuiIuhPji+m/Giarc354hHqE+7MxHuRc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, caratorn@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 16/21]drivers:staging:vt6655:device_main.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:14:42 -0800
Message-Id: <1298614482-4075-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/vt6655/device_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f5028d9..8950c9d 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3032,7 +3032,7 @@ int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Parameter)
 
 buffer = kmalloc(1024, GFP_KERNEL);
 if(buffer==NULL) {
-  printk("alllocate mem for file fail?\n");
+  printk("allocate mem for file fail?\n");
   result = -1;
   goto error1;
 }
-- 
1.7.4.1

