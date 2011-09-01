Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1IAAXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:23:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52260 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1IAAXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:23:08 -0400
Message-ID: <4E5ED061.6020502@gmail.com>
Date: Thu, 01 Sep 2011 08:22:57 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cleanup: small fix on comment for block_invalidatepage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is aganist 3.1-rc3.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a80b04..936d603 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1470,13 +1470,13 @@ static void discard_buffer(struct buffer_head * bh)
 }
 
 /**
- * block_invalidatepage - invalidate part of all of a buffer-backed page
+ * block_invalidatepage - invalidate part or all of a buffer-backed page
  *
  * @page: the page which is affected
  * @offset: the index of the truncation point
  *
  * block_invalidatepage() is called when all or part of the page has become
- * invalidatedby a truncate operation.
+ * invalidated by a truncate operation.
  *
  * block_invalidatepage() does not have to release all buffers, but it must
  * ensure that no dirty buffer is left outside @offset and that no I/O
-- 
1.7.1


