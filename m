Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2AUBSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:18:32 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35348
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752446Ab2AUBSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:18:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH/RESEND] [trivial] sctp : Fix typo in net/sctp/socket.c
Date: Sat, 21 Jan 2012 10:18:01 +0900
Message-Id: <1327108681-1682-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masanari Iida<standby24x7@gmail.com>

Correct a typo "sctp_setsocktopt_bindx" to "sctp_setsockopt_bindx"
in net/sctp/socket.c
---
 net/sctp/socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 408ebd0..658483e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -970,7 +970,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
+	SCTP_DEBUG_PRINTK("sctp_setsockopt_bindx: sk %p addrs %p"
 			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
-- 
1.7.6.5

