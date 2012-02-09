Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2BIO64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:58:56 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37549
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153Ab2BIO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:58:55 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in tcm_mod_builder.py
Date: Thu,  9 Feb 2012 23:58:28 +0900
Message-Id: <1328799508-2227-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "alocate" to "allocate" in
Documentation/target/tcm_mod_builder.py

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/target/tcm_mod_builder.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 6e21b8b..a78879b 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -775,7 +775,7 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 			buf += "	struct " + fabric_mod_name + "_nacl *nacl;\n\n"
 			buf += "	nacl = kzalloc(sizeof(struct " + fabric_mod_name + "_nacl), GFP_KERNEL);\n"
 			buf += "	if (!nacl) {\n"
-			buf += "		printk(KERN_ERR \"Unable to alocate struct " + fabric_mod_name + "_nacl\\n\");\n"
+			buf += "		printk(KERN_ERR \"Unable to allocate struct " + fabric_mod_name + "_nacl\\n\");\n"
 			buf += "		return NULL;\n"
 			buf += "	}\n\n"
 			buf += "	return &nacl->se_node_acl;\n"
-- 
1.7.6.5

