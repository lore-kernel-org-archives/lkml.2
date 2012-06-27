Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2F0PoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:44:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56620 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F0PoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:44:23 -0400
From: Michael Miller <commnerd@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Michael Miller <commnerd@gmail.com>
Subject: [PATCH] block/partitions/acorn.c: Changed string pointer declaration to array declaration for fewer asm statements
Date: Wed, 27 Jun 2012 09:41:20 -0600
Message-Id: <1340811680-3556-1-git-send-email-commnerd@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

