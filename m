Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1IFNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 09:34:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46236 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1IFNeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 09:34:05 -0400
Message-ID: <4E662127.5020903@gmail.com>
Date: Tue, 06 Sep 2011 21:33:27 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/idr.c: fix comment for function ida_get_new_above
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3 kernel.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index db040ce..58b56e1 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -767,8 +767,8 @@ EXPORT_SYMBOL(ida_pre_get);
  * @starting_id: id to start search at
  * @p_id:	pointer to the allocated handle
  *
- * Allocate new ID above or equal to @ida.  It should be called with
- * any required locks.
+ * Allocate new ID above or equal to @starting_id.  It should be called
+ * with any required locks.
  *
  * If memory is required, it will return %-EAGAIN, you should unlock
  * and go back to the ida_pre_get() call.  If the ida is full, it will
-- 
1.7.1

