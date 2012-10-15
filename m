Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2JOR0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:26:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44300 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2JOR0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:26:49 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 10/14] staging: csr: Fixed return(xxx); --> return xxx; on io.c
Date: Tue, 16 Oct 2012 02:25:32 +0900
Message-Id: <1350321936-2664-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just fixed the coding style errors like return(xxx); to return xxx;.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index e85fe94..ae069f0 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -956,7 +956,7 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 	if (offset >= written) {
 		*eof = 1;
 		kfree(orig_p);
-		return(0);
+		return 0;
 	}
 
 	if (offset + count > written) {
@@ -970,7 +970,7 @@ uf_read_proc(char *page, char **start, off_t offset, int count,
 
 	kfree(orig_p);
 
-	return(actual_amount_to_copy);
+	return actual_amount_to_copy;
 } /* uf_read_proc() */
 #endif
 
-- 
1.7.9.5

