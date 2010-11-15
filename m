Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab0KODH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:07:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1247 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907Ab0KODF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:59 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 37/44] fs/ubifs: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:56 -0800
Message-Id: <902d76520da2f65e5dc44339dccb07159947f23d.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ubifs/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/scan.c b/fs/ubifs/scan.c
index 3e1ee57..36216b4 100644
--- a/fs/ubifs/scan.c
+++ b/fs/ubifs/scan.c
@@ -328,7 +328,7 @@ struct ubifs_scan_leb *ubifs_scan(const struct ubifs_info *c, int lnum,
 		if (!quiet)
 			ubifs_err("empty space starts at non-aligned offset %d",
 				  offs);
-		goto corrupted;;
+		goto corrupted;
 	}
 
 	ubifs_end_scan(c, sleb, lnum, offs);
-- 
1.7.3.1.g432b3.dirty

