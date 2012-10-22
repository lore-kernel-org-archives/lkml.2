Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2JVQe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:34:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37978 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:34:28 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, sfrench@samba.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] fs: cifs: Fix typo in fs/cifs
Date: Tue, 23 Oct 2012 01:34:20 +0900
Message-Id: <1350923660-8083-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in fs/cifs.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/cifs/link.c    | 2 +-
 fs/cifs/readdir.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 51dc2fb..9f6c4c4 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -76,7 +76,7 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	}
 	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update iwth link_str", __func__);
+		cERROR(1, "%s: Could not update with link_str", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index b0f4a42..dc3433f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -408,7 +408,7 @@ static void cifs_fill_dirent_std(struct cifs_dirent *de,
 		const FIND_FILE_STANDARD_INFO *info)
 {
 	de->name = &info->FileName[0];
-	/* one byte length, no endianess conversion */
+	/* one byte length, no endianness conversion */
 	de->namelen = info->FileNameLength;
 	de->resume_key = info->ResumeKey;
 }
-- 
1.8.0.rc3.16.g8ead1bf

