Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637Ab2JaPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:48:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52384 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab2JaPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:48:25 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/Resend] [trivial] net: sctp: Fix typo in net/sctp
Date: Thu,  1 Nov 2012 00:48:19 +0900
Message-Id: <1351698499-15192-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in net/sctp/socket.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 59d16ea..a60d1f8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -974,7 +974,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
+	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
 			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
-- 
1.8.0.rc3.16.g8ead1bf

