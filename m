Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2BAOyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:54:51 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41500
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756487Ab2BAOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:54:49 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: bharrosh@panasas.com, bhalevy@tonian.com, osd-dev@open-osd.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] exofs: Fix typo in super.c
Date: Wed,  1 Feb 2012 23:53:46 +0900
Message-Id: <1328108026-2550-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "faild" to "failed" in
fs/exofs/super.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/exofs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index d22cd16..b8369f0 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -565,7 +565,7 @@ int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
 
 	aoded = kzalloc(sizeof(*aoded), GFP_KERNEL);
 	if (unlikely(!aoded)) {
-		EXOFS_ERR("ERROR: faild allocating Device array[%d]\n",
+		EXOFS_ERR("ERROR: failed allocating Device array[%d]\n",
 			  numdevs);
 		return -ENOMEM;
 	}
-- 
1.7.6.5

