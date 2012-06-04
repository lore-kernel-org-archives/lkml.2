Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2FDLS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:18:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2FDLSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:18:25 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wanpeng Li <liwp.linux@gmail.com>, Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] buffer_read_full_page:make comments tidy
Date: Mon,  4 Jun 2012 19:16:54 +0800
Message-Id: <1338808614-4261-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since the function has already have comments "Stage two: xxx" and "Stage
3: xxx", so add "Stage one: xxx" in order to make comments tidy.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ad5938c..e49b6a1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2086,6 +2086,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	nr = 0;
 	i = 0;
 
+	/* Stage one: find the buffers */
 	do {
 		if (buffer_uptodate(bh))
 			continue;
@@ -2138,7 +2139,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	}
 
 	/*
-	 * Stage 3: start the IO.  Check for uptodateness
+	 * Stage three: start the IO.  Check for uptodateness
 	 * inside the buffer lock in case another process reading
 	 * the underlying blockdev brought it uptodate (the sct fix).
 	 */
-- 
1.7.9.5

