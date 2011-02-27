Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1B0EfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:35:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1B0Ee4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O3XsmVOCF4CPJf7VMtNyc2UbvOvtbQGrt2KtdXEIQdbCE99DWhRvqcFDw1WMvafEU0
         PHOuq+QyPhqh2AMK61eLl/hCII9tFsjtFs/9q9KgoOaTowqvWw7M0LRGApjNZQKjrzKs
         a0M3jdgr86CljKfdLA4SpZom7caACqIXQ/jzA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org
Subject: [PATCH 16/17]mm:shmem.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:09 -0800
Message-Id: <1298781250-2718-17-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Hugh Dickins <hughd@google.com>
CC: linux-mm@kvack.org
---
 mm/shmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5ee67c9..3cdb243 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -779,7 +779,7 @@ static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 			 * If truncating down to a partial page, then
 			 * if that page is already allocated, hold it
 			 * in memory until the truncation is over, so
-			 * truncate_partial_page cannnot miss it were
+			 * truncate_partial_page cannot miss it were
 			 * it assigned to swap.
 			 */
 			if (newsize & (PAGE_CACHE_SIZE-1)) {
-- 
1.7.4.1

