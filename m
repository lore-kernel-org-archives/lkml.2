Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2HJOHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:07:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab2HJOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:07:35 -0400
Date: Fri, 10 Aug 2012 23:07:33 +0900 (JST)
Message-Id: <20120810.230733.361844971892827940.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] Declaring tcp protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring tcp protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/tcp_ipv4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 272241f..e361a26 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2645,6 +2645,9 @@ struct proto tcp_prot = {
 	.destroy_cgroup		= tcp_destroy_cgroup,
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 EXPORT_SYMBOL(tcp_prot);
 
-- 
1.7.11.2

