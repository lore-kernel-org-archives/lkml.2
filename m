Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0LJJzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:55:32 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51210 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0LJJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:55:30 -0500
Subject: [RFC PATCH V2 1/5] Add a new sock flag for zero-copy
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 01:55:24 -0800
Message-ID: <1291974924.2167.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shirley Ma <xma@us.ibm.com>

 include/net/sock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a6338d0..ff34ea7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -543,6 +543,7 @@ enum sock_flags {
 	SOCK_TIMESTAMPING_SYS_HARDWARE, /* %SOF_TIMESTAMPING_SYS_HARDWARE */
 	SOCK_FASYNC, /* fasync() active */
 	SOCK_RXQ_OVFL,
+	SOCK_ZEROCOPY,
 };
 
 static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)


