Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0IKDNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:13:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63956 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0IKDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xbVkbyiTZTLoGF7jlVy85wOCLe9BM4tM9HOtJUBTYssoBzYJ6UR2otr4uEM8G9i7O0
         qkDIZKToFdvNGf7ncNJdIcKuIH6qeUdOwBR4jvBbLhsYRpVydT2ZEPm/GheTiymjBSEN
         IULbMeAlG99jfJ5twTF8deHpnOUXkxZ1LYJSU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/11]fs/reiserfs/procfs.c Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:51 -0700
Message-Id: <1284174771-7033-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
References: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/reiserfs/procfs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 7a99811..6b387b0 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -555,13 +555,11 @@ int reiserfs_proc_info_global_done(void)
  *  . remove remove_save_link() from reiserfs_do_truncate()
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
  *
  * Revision 1.1.8.1  2001/07/11 16:48:50  god
  * proc info support
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
  *
  */
 
-- 
1.7.2.1

