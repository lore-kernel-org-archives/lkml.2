Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2HKUcz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:32:55 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754989Ab2HKUch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:37 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 10/15] ipv6: declaring tcpv6 protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:13 +0900
Message-Id: <1344715638-22997-10-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring tcpv6 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv6/tcp_ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index aa41b0e..741cb3b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2017,6 +2017,7 @@ struct proto tcpv6_prot = {
 #ifdef CONFIG_MEMCG_KMEM
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
+	.has_own_proc_entry= 1,
 };
 
 static const struct inet6_protocol tcpv6_protocol = {
-- 
1.7.11.2

