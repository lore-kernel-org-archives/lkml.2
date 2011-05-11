Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab1EKQFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:05:52 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:45484 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756033Ab1EKQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:05:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=tfoZTvL3Y8FkK1B/Z/b/Jhpqonxp6woOMTUluhQfY+rgASL6m4vuCsWOJIEEnuTkn7w5mPFD7jK7Z2+K/zgtg27r246wI8vkqntyPr+s4wobZmhySllI/lwXJyEX2ur5;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Documentation: Remove the obsolete parameters in 2 jbd2 functions.
Date: Wed, 11 May 2011 22:18:41 +0800
Message-Id: <1305123521-2896-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.32.52 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

credits isn't a parameter for jbd2_journal_get_write_access and
jbd2_journal_get_undo_access. So remove the corresponding comments.

Cc: Jan Kara <jack@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd2/transaction.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..0a82612 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -813,7 +813,6 @@ out:
  * int jbd2_journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
  * @handle: transaction to add buffer modifications to
  * @bh:     bh to be used for metadata writes
- * @credits: variable that will receive credits for the buffer
  *
  * Returns an error code or 0 on success.
  *
@@ -931,7 +930,6 @@ out:
  *     non-rewindable consequences
  * @handle: transaction
  * @bh: buffer to undo
- * @credits: store the number of taken credits here (if not NULL)
  *
  * Sometimes there is a need to distinguish between metadata which has
  * been committed to disk and that which has not.  The ext3fs code uses
-- 
1.7.1

