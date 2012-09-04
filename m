Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2IDQ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:28:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49057 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab2IDQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:28:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 1/3] Documentation/rbtree.txt: Fix possible typo in example
Date: Tue,  4 Sep 2012 17:28:08 +0100
Message-Id: <1346776090-4631-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
References: <1346776090-4631-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The example code for rb_erase() usage has a function call to mysearch().
Presumably this ought to be my_search() to match the example code
earlier in the document.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 Documentation/rbtree.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 8d32d85..d4a31e0 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -146,7 +146,7 @@ To remove an existing node from a tree, call:
 
 Example:
 
-  struct mytype *data = mysearch(&mytree, "walrus");
+  struct mytype *data = my_search(&mytree, "walrus");
 
   if (data) {
   	rb_erase(&data->node, &mytree);
-- 
1.7.12

