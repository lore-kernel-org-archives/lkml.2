Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1BYGNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:13:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61640 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1BYGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LoNaDnP3AxABCGHKf93LVc/gYsWF1pjjEc5z3Dz24coRak3cq9JfqKMK8AVjNss7dk
         H7/fEU+IRcnW40puwvxuAjcvVQewfufWBJOzWfmycS4EuaoTkOYnlIoPw2O+lqMhucfx
         0MdyCz30NqoGOLvebv2o2PjxS81YNUPcpoag8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, more.andres@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 12/21]drivers:staging:vt6656:main_usb.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:13:27 -0800
Message-Id: <1298614407-3919-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/vt6656/main_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7cc3d24..7b5b7c5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1454,7 +1454,7 @@ static unsigned char *Config_FileOperation(PSDevice pDevice)
 
     buffer = kmalloc(1024, GFP_KERNEL);
     if(buffer==NULL) {
-      printk("alllocate mem for file fail?\n");
+      printk("allocate mem for file fail?\n");
       result = -1;
       goto error1;
     }
-- 
1.7.4.1

