Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0L1GWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:22:41 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36432 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0L1GWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CxtLc8jIhNjUEBnntJWfEQTTzqRSX7iF+xJSCPWuPgbMRJ7Eh1uwF2wMlz5oP83qSe
         LX1/YVinetgEjE4meEGrl5orZFSwGv/nH0gZNlJdZlmaxYHJ/8fyRnqH8yCAfYFWt8Cj
         W9q1prgt+pX92JBBfw1pZdI/oiCERgckbFn1M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]staging:zram:xvmalloc.c Fix a typo.
Date: Mon, 27 Dec 2010 22:22:31 -0800
Message-Id: <1293517351-3158-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not exactly sure if this is a typo or not, due to my search
results comming up with not that many hits. Either its dereferenceable
or dereferencable from the two I choose the later. if it's wrong let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/zram/xvmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 3fdbb8a..4f07439 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -46,7 +46,7 @@ static void clear_flag(struct block_header *block, enum blockflags flag)
 }
 
 /*
- * Given <page, offset> pair, provide a derefrencable pointer.
+ * Given <page, offset> pair, provide a dereferencable pointer.
  * This is called from xv_malloc/xv_free path, so it
  * needs to be fast.
  */
-- 
1.6.5.2.180.gc5b3e

