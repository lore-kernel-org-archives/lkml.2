Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2LMLbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:31:17 -0500
Received: from pmx.elettra.trieste.it ([140.105.206.203]:36768 "EHLO
	pmx.elettra.trieste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2LMLbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:31:16 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 06:31:16 EST
From: Alessio Igor Bogani <abogani@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: vfs: Remove useless function prototypes
Date: Thu, 13 Dec 2012 12:22:39 +0100
Message-Id: <1355397760-17768-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.12.13.110624
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, FROM_NAME_PHRASE 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8e22cc88d68ca1a46d7d582938f979eb640ed30f removes the (un)lock_super
function definitions but forgets to remove their prototypes.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 include/linux/fs.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 408fb1e..f5642da 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1444,10 +1444,6 @@ static inline void sb_start_intwrite(struct super_block *sb)
 
 extern bool inode_owner_or_capable(const struct inode *inode);
 
-/* not quite ready to be deprecated, but... */
-extern void lock_super(struct super_block *);
-extern void unlock_super(struct super_block *);
-
 /*
  * VFS helper functions..
  */
-- 
1.7.9.5

