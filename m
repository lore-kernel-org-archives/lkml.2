Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2IYXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:32:03 -0400
Received: from nm29.bullet.mail.sp2.yahoo.com ([98.139.91.99]:24764 "HELO
	nm29.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754682Ab2IYXcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:32:00 -0400
X-Yahoo-Newman-Id: 335495.79969.bm@omp1012.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: biTAvsIVM1nTEeeWsKqEDiN5heYh5en4dPWj6vpLbBhH9eW
 HkrHbw._C4ZI6jr54qkAhus3nT28vmf6cZ9uIKVo02No6XxZuQOSTdOZlEUM
 hZo5dwb9sQorwYch6f7mzfWIb3ScdBOcEtbSTk1EAsQZPZoxQ45l4WVP7GFq
 i_h6QutLPVzrcHfVpzxyQRV.tECCyE6yg9xeCQ_faP.4bUYxyCEztLxNuiHk
 szqt4OrKTe.XFCqOLO7Y5stuqBKdoKt1VTtwrrEev8YXtjzNRC3qbzFocKtn
 o_Jero1nY9Tg0w8SyKicznFT55B_uV8Zdkxmrij6AxsYvfS3DlKnt_8Mxf5S
 u20De4UmQg6mpvBppEHLFkxxoa_VR1x4jq.FV_mqm7Hmv878N29rO50Ex8_S
 XCdIeoLJ3QmFQnkg33b7CUu0StFh262VUmAzBQ8Sg9kBuU2Md7LaG
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 19/25] rbtree.h: add doc comments for struct rb_node
Date: Tue, 25 Sep 2012 18:31:53 -0500
Message-Id: <1348615913-10589-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 3ef30b9..f1fbdea 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -100,6 +100,19 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 #include <linux/bug.h>
 #include <linux/kconfig.h>
 
+/**
+ * struct rb_node
+ * @rb_parent_color: Contains the color in the lower 2 bits (although only bit
+ * 		     zero is currently used) and the address of the parent in
+ * 		     the rest (lower 2 bits of address should always be zero on
+ * 		     any arch supported).  If the node is initialized and not a
+ * 		     member of any tree, the parent point to its self.  If the
+ * 		     node belongs to a tree, but is the root element, the
+ * 		     parent will be NULL.  Otherwise, parent will always
+ * 		     point to the parent node in the tree.
+ * @rb_right:        Pointer to the right element.
+ * @rb_left:         Pointer to the left element.
+ */
 struct rb_node
 {
 	unsigned long  rb_parent_color;
-- 
1.7.3.4

