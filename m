Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1GFWRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:17:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32876 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1GFWRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:17:34 -0400
Subject: [PATCH V8 1/4 net-next] sock.h: Add a new sock zero-copy flag
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>, mst@redhat.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 15:17:30 -0700
Message-ID: <1309990650.10209.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/net/sock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ae56da6..396f735 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -563,6 +563,7 @@ enum sock_flags {
 	SOCK_TIMESTAMPING_SYS_HARDWARE, /* %SOF_TIMESTAMPING_SYS_HARDWARE */
 	SOCK_FASYNC, /* fasync() active */
 	SOCK_RXQ_OVFL,
+	SOCK_ZEROCOPY, /* buffers from userspace */
 };
 
 static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)


