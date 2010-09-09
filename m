Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0IIWg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37652 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab0IIWg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X8eQ+TuaihIil0S/l/j63LVO7JYMbI8yQAxWmmcOOIa2gEiw6h+4FZb2DQs6xlayrO
         aJ+fQCXuyrMaFrpHaL2HwVnWuviGsIMirE7oBkG+6rZrkETTMj3ZfOb5CKe+hTgXEDNn
         uG8NQckGV2XI54jpDJXLNMyjZvo07/exNSS5o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 107/223]drivers/net/irda/ma600-sir.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:36 -0700
Message-Id: <1284071809-8149-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/irda/ma600-sir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/ma600-sir.c b/drivers/net/irda/ma600-sir.c
index e912164..186697f 100644
--- a/drivers/net/irda/ma600-sir.c
+++ b/drivers/net/irda/ma600-sir.c
@@ -4,7 +4,7 @@
  * Version:       0.1
  * Description:   Implementation of the MA600 dongle
  * Status:        Experimental.
- * Author:        Leung <95Etwl@alumni.ee.ust.hk> http://www.engsvr.ust/~eetwl95
+ * Author:        Leung <95Etwl@alumni.ee.ust.hk> 
  * Created at:    Sat Jun 10 20:02:35 2000
  * Modified at:   Sat Aug 16 09:34:13 2003
  * Modified by:   Martin Diehl <mad@mdiehl.de> (modified for new sir_dev)
@@ -253,7 +253,7 @@ static int ma600_reset(struct sir_dev *dev)
 	return 0;
 }
 
-MODULE_AUTHOR("Leung <95Etwl@alumni.ee.ust.hk> http://www.engsvr.ust/~eetwl95");
+MODULE_AUTHOR("Leung <95Etwl@alumni.ee.ust.hk>");
 MODULE_DESCRIPTION("MA600 dongle driver version 0.1");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("irda-dongle-11"); /* IRDA_MA600_DONGLE */
-- 
1.7.2.1

