Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2HKUdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:33:00 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755019Ab2HKUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:41 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 12/15] ipv6: declaring udplitev6 protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:15 +0900
Message-Id: <1344715638-22997-12-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring udplitev6 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv6/udplite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 1d08e21..9013897 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -57,6 +57,7 @@ struct proto udplitev6_prot = {
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
 	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.has_own_proc_entry= 1,
 };
 
 static struct inet_protosw udplite6_protosw = {
-- 
1.7.11.2

