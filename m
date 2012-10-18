Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2JRBze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:55:34 -0400
Received: from noserose.net ([66.220.18.76]:44740 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753251Ab2JRBzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:55:33 -0400
Date: Wed, 17 Oct 2012 18:55:31 -0700
Message-Id: <66b454e6f49c6e239174293c4b51edf1de5e516f.1350524227.git.ecashin@coraid.com>
In-Reply-To: <cover.1350524227.git.ecashin@coraid.com>
References: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 7/9] aoe: cleanup: remove unused ata_scnt function
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 2bb8c7d..82e16c4 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -552,16 +552,6 @@ sthtith(struct aoedev *d)
 	return 1;
 }
 
-static inline unsigned char
-ata_scnt(unsigned char *packet) {
-	struct aoe_hdr *h;
-	struct aoe_atahdr *ah;
-
-	h = (struct aoe_hdr *) packet;
-	ah = (struct aoe_atahdr *) (h+1);
-	return ah->scnt;
-}
-
 static void
 rexmit_timer(ulong vp)
 {
-- 
1.7.1

