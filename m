Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2HJOLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611Ab2HJOLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:11:40 -0400
Date: Fri, 10 Aug 2012 23:11:38 +0900 (JST)
Message-Id: <20120810.231138.1502296611506727538.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] Declaring rawv6 protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring rawv6 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index ef0579d..15006ce 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1226,6 +1226,9 @@ struct proto rawv6_prot = {
 	.compat_getsockopt = compat_rawv6_getsockopt,
 	.compat_ioctl	   = compat_rawv6_ioctl,
 #endif
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 #ifdef CONFIG_PROC_FS
-- 
1.7.11.2

