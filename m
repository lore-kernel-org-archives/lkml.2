Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2GFHLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:11:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2GFHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:11:35 -0400
From: Michael Miller <commnerd@gmail.com>
To: axboe@kernel.dk
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Michael Miller <commnerd@gmail.com>
Subject: [PATCH] block/partitions/acorn.c: Changed string pointer declaration to array declaration for fewer asm statements
Date: Fri,  6 Jul 2012 01:14:31 -0600
Message-Id: <1341558871-6572-1-git-send-email-commnerd@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the KernelJanitors page, this fix will remove 2 - 3 asm calls when declaring a string.

Signed-off-by: Michael Miller <commnerd@gmail.com>

---
 block/partitions/acorn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/partitions/acorn.c b/block/partitions/acorn.c
index fbeb697..bf5847e 100644
--- a/block/partitions/acorn.c
+++ b/block/partitions/acorn.c
@@ -168,7 +168,7 @@ int adfspart_check_CUMANA(struct parsed_partitions *state)
 	unsigned int start_blk = 0;
 	Sector sect;
 	unsigned char *data;
-	char *name = "CUMANA/ADFS";
+	char name[] = "CUMANA/ADFS";
 	int first = 1;
 	int slot = 1;
 
-- 
1.7.2.5

