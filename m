Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2JEOud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:50:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2JEOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:50:30 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] net: sctp: Fix typo in socket.c
Date: Fri,  5 Oct 2012 23:50:24 +0900
Message-Id: <1349448624-15060-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in net/sctp/socket.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d37d24f..aaeff63 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -973,7 +973,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
+	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
 			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
-- 
1.8.0.rc0.18.gf84667d

