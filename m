Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1DTTnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:43:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34528 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab1DTTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:43:08 -0400
Subject: [PATCH V3 1/8] Add a new sock zerocopy flag
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303328216.19336.18.camel@localhost.localdomain>
References: <1303328216.19336.18.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 12:42:25 -0700
Message-ID: <1303328545.19336.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sock zerocopy flag is used to support lower level device DMA 
userspace buffers.

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/net/sock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 01810a3..daa0a80 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -562,6 +562,7 @@ enum sock_flags {
 	SOCK_TIMESTAMPING_SYS_HARDWARE, /* %SOF_TIMESTAMPING_SYS_HARDWARE */
 	SOCK_FASYNC, /* fasync() active */
 	SOCK_RXQ_OVFL,
+	SOCK_ZEROCOPY,
 };
 
 static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)


