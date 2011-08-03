Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1HCOTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:19:36 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38790 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1HCOTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:19:31 -0400
Subject: [PATCH] [TRIVIAL] Fix kernel-doc comment typo '@id'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 16:18:39 +0200
Message-ID: <1312381119.30457.5.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with scripts/kernel-doc only.

 lib/idr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index e15502e..e0abbc1 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -858,7 +858,7 @@ EXPORT_SYMBOL(ida_get_new_above);
  * and go back to the idr_pre_get() call.  If the idr is full, it will
  * return %-ENOSPC.
  *
- * @id returns a value in the range %0 ... %0x7fffffff.
+ * @p_id returns a value in the range %0 ... %0x7fffffff.
  */
 int ida_get_new(struct ida *ida, int *p_id)
 {
-- 
1.7.4.4

