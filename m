Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2BGNfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:35:20 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:36698
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755841Ab2BGNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:35:19 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: arnd@arndb.de, greg@kroah.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] char: Fix typo in viotape.c
Date: Tue,  7 Feb 2012 22:33:56 +0900
Message-Id: <1328621636-1839-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "allocat" to "allocate" in
drivers/char/viotape.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/char/viotape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index ad6e64a..8b34c65 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -976,7 +976,7 @@ int __init viotap_init(void)
 
 	tape_class = class_create(THIS_MODULE, "tape");
 	if (IS_ERR(tape_class)) {
-		printk(VIOTAPE_KERN_WARN "Unable to allocat class\n");
+		printk(VIOTAPE_KERN_WARN "Unable to allocate class\n");
 		ret = PTR_ERR(tape_class);
 		goto unreg_chrdev;
 	}
-- 
1.7.6.5

