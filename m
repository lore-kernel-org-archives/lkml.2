Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0FADXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2512 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0FADXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:36 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
       Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org
Subject: [PATCH 21/21] net/sctp/protocol.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:23 -0700
Message-Id: <789ef255b7c046dd11fad6ca8c057354b6306c7f.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sctp/protocol.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 1827498..fef38be 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1216,8 +1216,7 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
-		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
+	sctp_ep_hashtable = kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		printk(KERN_ERR "SCTP: Failed endpoint_hash alloc.\n");
 		status = -ENOMEM;
-- 
1.7.0.3.311.g6a6955

