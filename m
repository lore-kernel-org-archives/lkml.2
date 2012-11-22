Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2KVTLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:11:11 -0500
Received: from dupo.coraid.com ([208.71.232.133]:35315 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756516Ab2KVTLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:11:03 -0500
Message-Id: <56cf0b754292e4d58421964d5ae07358bbb4f996.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/8] aoe: cleanup: correct comment for aoetgt nout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 20:00:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A misplaced comment was attached to the nout member of the
aoetgt.  This change corrects the comment.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 9655ce3..bfd765c 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -133,7 +133,7 @@ struct aoetgt {
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
-	ushort nout;		/* value of nout when skb was sent */
+	ushort nout;		/* number of AoE commands outstanding */
 	ushort maxout;		/* current value for max outstanding */
 	ushort next_cwnd;	/* incr maxout after decrementing to zero */
 	ushort ssthresh;	/* slow start threshold */
-- 
1.7.1

