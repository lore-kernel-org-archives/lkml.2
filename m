Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1GALud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:50:33 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:48540 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab1GALub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:50:31 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 07:50:31 EDT
From: Tobias Klauser <tklauser@distanz.ch>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: Fixup kerneldoc for generic_permission()
Date: Fri,  1 Jul 2011 13:44:51 +0200
Message-Id: <1309520691-17741-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.7.1.113314
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, __ANY_URI 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flags parameter went away in
5c90c1601f00154f8695951469f25f33579272ed

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/namei.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f181e4c..73fc34a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -213,7 +213,6 @@ other_perms:
  * generic_permission -  check for access rights on a Posix-like filesystem
  * @inode:	inode to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
- * @flags:	IPERM_FLAG_ flags.
  *
  * Used to check for read/write/execute permissions on a file.
  * We use "fsuid" for this, letting us set arbitrary permissions
-- 
1.7.5.4

