Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1B0Eev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1B0Ees (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ArqX7Wv7OuDra/nlkn20+AknzbLbQfIcJRNjwjrIUwsymYUWU0XnAB69KmZ+EBSfV2
         Q6LVNzuIyWWzoO7lSYQY2jiIVK6kIp6/JcYkZQ78Ujgb2b88fUE48vyihJvpTPjpIIsO
         J9wUf3V1ovru78C+H4Qg5JprJQOJzJdI9oBJ0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 11/17]fs:btrfs:disk-io.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:04 -0800
Message-Id: <1298781250-2718-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Chris Mason <chris.mason@oracle.com> 
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..100b07f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2493,7 +2493,7 @@ int close_ctree(struct btrfs_root *root)
 	 * ERROR state on disk.
 	 *
 	 * 2. when btrfs flips readonly just in btrfs_commit_super,
-	 * and in such case, btrfs cannnot write sb via btrfs_commit_super,
+	 * and in such case, btrfs cannot write sb via btrfs_commit_super,
 	 * and since fs_state has been set BTRFS_SUPER_FLAG_ERROR flag,
 	 * btrfs will cleanup all FS resources first and write sb then.
 	 */
-- 
1.7.4.1

