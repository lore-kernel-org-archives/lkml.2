Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0IIW3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:29:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44570 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab0IIW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V00iuNUpZTn5DAAGZUxx81tdN+hlEc4sLrONCxnIXqL39RJ/4uGm6LS7f139OYCoHh
         1UBq8J7BSO9ORYn3kZPW4UIB8qlD9NGOdjc0NyH33fQhTw63p6hXZL/GL/NgaKgcE85B
         x2LPgndLTs2QM6tTCcMXhWj/m70Kefhltt6mc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 086/223]drivers/net/tlan.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:30 -0700
Message-Id: <1284071374-7867-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/tlan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index ccee3ed..ef000b2 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -78,7 +78,7 @@
  * 			     - Updated tlan.txt accordingly.
  * 			     - Adjusted minimum/maximum frame length.
  * 			     - There is now a TLAN website up at
- * 			       http://tlan.kernel.dk
+ * 			       http://hp.sourceforge.net/ 
  *
  * 	v1.7 April 07, 2000  - Started to implement custom ioctls. Driver now
  * 			       reports PHY information when used with Donald
-- 
1.7.2.1

