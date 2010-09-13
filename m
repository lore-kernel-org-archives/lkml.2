Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0IMUrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:47:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42821 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0IMUrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:47:06 -0400
Subject: RFC PATCH 1/2] macvtap: A new sock zero copy flag
From: Shirley Ma <mashirle@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, mst@redhat.com, Avi Kivity <avi@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1284410580.13351.10.camel@localhost.localdomain>
References: <1284410580.13351.10.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:47:01 -0700
Message-ID: <1284410821.13351.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* Add a new flag to support sock zero copy from user space to kernel */

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 include/net/sock.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index adab9dc..80172de 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -543,6 +543,7 @@ enum sock_flags {
 	SOCK_TIMESTAMPING_SYS_HARDWARE, /* %SOF_TIMESTAMPING_SYS_HARDWARE */
 	SOCK_FASYNC, /* fasync() active */
 	SOCK_RXQ_OVFL,
+	SOCK_ZEROCOPY, /* zerocopy from user space to kernel */
 };
 
 static inline void sock_copy_flags(struct sock *nsk, struct sock *osk)


