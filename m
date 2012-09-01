Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2IAUi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 16:38:27 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:36692 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab2IAUi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 16:38:26 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2012 16:38:26 EDT
From: Marcus Karlsson <mk@acc.umu.se>
To: gregkh@linuxfoundation.org
Cc: xiaoguangrong@linux.vnet.ibm.com, konrad.wilk@oracle.com, mk@acc.umu.se,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zcache: fix spelling of comment
Date: Sat,  1 Sep 2012 22:29:46 +0200
Message-Id: <1346531386-9524-1-git-send-email-mk@acc.umu.se>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling in tmem.c:
Transcedent -> Transcendent

Signed-off-by: Marcus Karlsson <mk@acc.umu.se>
---
 drivers/staging/zcache/tmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
index eaa9021..56c8e60 100644
--- a/drivers/staging/zcache/tmem.c
+++ b/drivers/staging/zcache/tmem.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2009-2011, Dan Magenheimer, Oracle Corp.
  *
- * The primary purpose of Transcedent Memory ("tmem") is to map object-oriented
+ * The primary purpose of Transcendent Memory ("tmem") is to map object-oriented
  * "handles" (triples containing a pool id, and object id, and an index), to
  * pages in a page-accessible memory (PAM).  Tmem references the PAM pages via
  * an abstract "pampd" (PAM page-descriptor), which can be operated on by a
-- 
1.7.12

