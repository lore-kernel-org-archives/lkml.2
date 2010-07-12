Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0GLUxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:53:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab0GLUvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:03 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net
Subject: [PATCH 24/36] fs/ecryptfs: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:16 -0700
Message-Id: <98ae7e6c316dcdfdf5f19acd84ad4befa42f2a14.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 0032a9f..40186b9 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -477,7 +477,7 @@ ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
 static inline struct ecryptfs_file_info *
 ecryptfs_file_to_private(struct file *file)
 {
-	return (struct ecryptfs_file_info *)file->private_data;
+	return file->private_data;
 }
 
 static inline void
-- 
1.7.1.337.g6068.dirty

