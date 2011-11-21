Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1KUQnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:43:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab1KUQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:43:38 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3]fs:btrfs:free-space-cache.c Remove extra semicolon.
Date: Mon, 21 Nov 2011 08:43:28 -0800
Message-Id: <1321893808-3721-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
References: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes an extra semicolon. 
Note: I have not compile tested this patch, so am unsure if this breaks things.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: linux-btrfs@vger.kernel.org

---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 181760f..75a7b11 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -418,7 +418,7 @@ static void io_ctl_set_crc(struct io_ctl *io_ctl, int index)
 	}
 
 	if (index == 0)
-		offset = sizeof(u32) * io_ctl->num_pages;;
+		offset = sizeof(u32) * io_ctl->num_pages;
 
 	crc = btrfs_csum_data(io_ctl->root, io_ctl->orig + offset, crc,
 			      PAGE_CACHE_SIZE - offset);
-- 
1.7.5.4

