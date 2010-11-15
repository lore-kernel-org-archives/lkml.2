Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab0KODIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:08:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1234 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab0KODF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:57 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Joern Engel <joern@logfs.org>, logfs@logfs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 34/44] fs/logfs: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:53 -0800
Message-Id: <0c990bdacb2f9bf256acbb06ca59130585f600b7.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/logfs/readwrite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 6127baf..b4304f2 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -481,7 +481,7 @@ static int inode_write_alias(struct super_block *sb,
 			val = inode_val0(inode);
 			break;
 		case INODE_USED_OFS:
-			val = cpu_to_be64(li->li_used_bytes);;
+			val = cpu_to_be64(li->li_used_bytes);
 			break;
 		case INODE_SIZE_OFS:
 			val = cpu_to_be64(i_size_read(inode));
-- 
1.7.3.1.g432b3.dirty

