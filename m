Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2FFKyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56671 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2FFKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:36 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 09/11] mm: frontswap: remove unused variable in init
Date: Wed,  6 Jun 2012 12:55:13 +0200
Message-Id: <1338980115-2394-9-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index b98df99..c0cd8bc 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -321,8 +321,6 @@ EXPORT_SYMBOL(frontswap_curr_pages);
 
 static int __init init_frontswap(void)
 {
-	int err = 0;
-
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *root = debugfs_create_dir("frontswap", NULL);
 	if (root == NULL)
@@ -334,7 +332,7 @@ static int __init init_frontswap(void)
 	debugfs_create_u64("invalidates", S_IRUGO,
 				root, &frontswap_invalidates);
 #endif
-	return err;
+	return 0;
 }
 
 module_init(init_frontswap);
-- 
1.7.8.6

