Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2HJOJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:09:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab2HJOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:09:39 -0400
Date: Fri, 10 Aug 2012 23:09:37 +0900 (JST)
Message-Id: <20120810.230937.530171707326780193.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] Declaring tcpv6 protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring tcpv6 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv6/tcp_ipv6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5a439e9..9152d02 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2043,6 +2043,9 @@ struct proto tcpv6_prot = {
 #ifdef CONFIG_MEMCG_KMEM
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 static const struct inet6_protocol tcpv6_protocol = {
-- 
1.7.11.2

